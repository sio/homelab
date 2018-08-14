#!/usr/bin/env bash

# Setup script for the dotfiles
#
# Dotfiles are organized by topic.
# Topics suffixed with `.system` are treated as targeting /etc/ directory
# instead of $HOME.
#
# File suffixes correspond to bootstrap actions:
#     .copy - for files to be copied over to new location
#     .link - for files to be linked to from new location
#     .append - for files to be appended to the target file
# All other files and directories are ignored.
#
# Example:
#     topic-foo/vimrc.link:
#        Will be symlinked from ~/.vimrc
#     topic-bar/bashrc.copy
#        Will be copied over to ~/.bashrc
#     topic-baz.system/etc/default/keyboard.copy
#        Will be copied to /etc/default/keyboard
#     topic-baz.system/file/without/valid/suffix
#        Will be ignored
#
# The script depends on the following tools:
#     - GNU coreutils: fmt, ln, mkdir, cp, readlink
#     - GNU find


# Fail loudly on any error
set -e


# Global parameters
DOTFILES=$(readlink -m "$(dirname "$0")")
DOTFILES_BACKUP="$HOME/.dotfiles-overwritten/"
SUFFIXES="link|append|copy"


install_topic() {
    local topic="$1"
    local file files ifs_backup

    if [[ -z "$topic" ]]
    then
        echo "install_topic() requires topic name as an argument" >&2
        return 1
    fi

    files=$( \
        find \
            "$DOTFILES/$topic" \
            -regextype posix-egrep \
            -regex ".*\.($SUFFIXES)" \
    )

    if [[ ! -z "$files" ]]
    then
        echo -e "\nCONFIGURING TOPIC: $topic"
    fi

    ifs_backup="$IFS"
    IFS=$'\n'
    for file in $files
    do
        install_file "$file"
    done
    IFS="$ifs_backup"
}


install_file() {
    local file="$1"
    local action target destination overwritten output

    if [[ -z "$file" ]]
    then
        echo "install_file() requires file name as an argument" >&2
        return 1
    fi

    action=$(get_action "$file")
    target=$(get_target "$file")

    # Handle system-wide actions
    if [[ "$action" == *-system ]]
    then
        destination="/etc/$target"
        if [[ "$user" != "root" ]]
        then
            echo "Must be root to change system configuration" >&2
            return 1
        fi
        action="${action%%-*}"  # strip -system suffix
    else
        destination="$HOME/.$target"
    fi

    # Backup existing files before overwriting
    if [[ -e "$destination" ]]
    then
        mkdir -p "$DOTFILES_BACKUP"
        cp --parents "$destination" "$DOTFILES_BACKUP"
        overwritten=", old file backed up"
    else
        overwritten=""
    fi

    # Perform actual action
    execute_action() {
        case "$action" in
        link)
            ln -sfv "$file" "$destination" ;;
        copy)
            cp -v "$file" "$destination" ;;
        append)
            local newline="^"
            local pattern=$(tr '\n' "$newline" < "$file")
            touch "$destination"
            if tr '\n' "$newline" < "$destination" | grep -qF "$pattern"
            then
                :  # already appended
            else
                cat "$file" >> "$destination"
            fi
            echo "'$file' -> '$destination'"
            ;;
        esac
    }

    # Execute verbosely
    echo -e "\n  [$action$overwritten]"
    mkdir -p "$(dirname "$destination")"
    output=$(execute_action)  # separate statement to propagate errors properly
    echo "    $output" | fmt -c -w "$COLUMNS"
}


# Calculate (relative) target path for a dotfile
get_target() {
    local dotfile reply
    dotfile=$(_relative_dotfile_path "$1")

    reply="${dotfile%.*}"  # remove action suffix
    reply="${reply#*/}"  # remove topic
    echo "$reply"
}


# Select action required to install the dotfile
get_action() {
    local dotfile reply suffix
    dotfile=$(_relative_dotfile_path "$1")
    suffix="${dotfile##*.}"

    if [[ $suffix =~ ^($SUFFIXES)$ ]]
    then
        reply="$suffix"
    else
        echo "Invalid dotfile suffix: $suffix ($dotfile)" >&2
        return 1
    fi

    if [[ "${dotfile%%/*}" == *.system ]]
    then
        reply="$reply-system"
    fi

    echo "$reply"
}


# Make relative dotfile path
_relative_dotfile_path() {
    local absolute=$(readlink -m "$1")
    echo "${absolute/#$DOTFILES\//}"
}
