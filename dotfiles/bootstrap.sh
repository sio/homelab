#!/usr/bin/env bash

# Setup script for the dotfiles
#
# Dotfiles are organized by topic.
#
# If topic directory contains a file named `dotfiles.meta`, it will be sourced
# upon installing that topic. Use this to specify non-standard target directory
# for dotfiles (PREFIX) instead of $HOME or to mark the topic that requires
# root privileges (SCOPE=system).
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
#     topic-baz/etc/default/keyboard.copy with PREFIX=/etc
#        Will be copied to /etc/default/keyboard
#     topic-baz/file/without/valid/suffix
#        Will be ignored
#
# The script depends on the following tools:
#     - GNU coreutils: fmt, ln, mkdir, cp, readlink, tr (and others)
#     - GNU find
#     - GNU grep


# Fail loudly on any error
set -e
set -o pipefail


# Global parameters
DOTFILES=$(readlink -m "$(dirname "$0")")
DOTFILES_BACKUP="$HOME/.dotfiles-overwritten/"
SUFFIXES="link|append|copy"
COLUMNS=$(tput cols)


main() {
    local topic item
    if [[ -s "$1" ]]  # topic lists
    then
        for item in "$@"
        do
            grep -Ev '^\s*#|^\s*$' "$item" | while read -r topic
            do
                install_topic "$topic"
            done
        done
    elif [[ ! -z "$1" && -d "$DOTFILES/$1" ]]  # topic names
    then
        for item in "$@"
        do
            install_topic "$item"
        done
    else
        printf "%s\n" \
            "Usage: $(basename "$0") TOPIC [TOPIC2 ...] or" \
            "       $(basename "$0") FILENAME [FILENAME2 ...]" \
            "" \
            "Bootstrap script for $DOTFILES" \
            "" \
            "Install dotfiles either for individual TOPICs provided as arguments" \
            "or for everal topics listed in FILENAMEs (one topic per line, blank "\
            "lines and lines starting with hash symbol are ignored)" \
            "" \
            "All arguments have to be either TOPICs or FILENAMEs. Mixing argument" \
            "types is not supported and will lead to an error"
    fi
}


install_topic() {
    local topic="$1"
    local file files ifs_backup meta

    if [[ -z "$topic" ]]
    then
        echo "$FUNCNAME() requires topic name as an argument" >&2
        return 1
    fi

    files=$( \
        find \
            "$DOTFILES/$topic" \
            -regextype posix-egrep \
            -regex ".*\.($SUFFIXES)" \
    )

    [[ -z "$files" ]] && return

    # Initialize extra metadata
    local PREFIX="$HOME"
    local SCOPE="user"

    # Load custom metadata
    meta="$DOTFILES/$topic/dotfiles.meta"
    [[ -s "$meta" ]] && source "$meta"

    # Handle system-wide actions
    if [[ "$SCOPE" == "system" && "$user" != "root" ]]
    then
        echo "Must be root to change system configuration" >&2
        return 1
    fi

    # Install all files
    echo -e "\nCONFIGURING TOPIC: $topic"
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
        echo "$FUNCNAME() requires file name as an argument" >&2
        return 1
    fi

    action=$(get_action "$file")
    target=$(get_target "$file")

    # Calculate destination
    if [[ "$PREFIX" == "$HOME" ]]
    then
        destination="$HOME/.$target"
    else
        destination="$PREFIX/$target"
    fi

    # Backup existing files before overwriting
    if [[ -e "$destination" ]]
    then
        mkdir -p "$DOTFILES_BACKUP"
        cp --backup=numbered --parents "$destination" "$DOTFILES_BACKUP"
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


get_target() {
    local dotfile reply
    dotfile=$(relative_dotfile_path "$1")

    reply="${dotfile%.*}"  # remove action suffix
    reply="${reply#*/}"  # remove topic
    echo "$reply"
}


get_action() {
    local dotfile suffix reply
    dotfile=$(relative_dotfile_path "$1")
    suffix="${dotfile##*.}"

    if [[ $suffix =~ ^($SUFFIXES)$ ]]
    then
        reply="$suffix"
    else
        echo "Invalid dotfile suffix: $suffix ($dotfile)" >&2
        return 1
    fi

    if [[ "$OSTYPE" == "msys" && "$reply" == "link" ]]
    then
        reply="copy"  # Windows can't handle symlinks easily
    fi

    echo "$reply"
}


relative_dotfile_path() {
    local absolute=$(readlink -m "$1")
    echo "${absolute/#$DOTFILES\//}"
}


# Invoke commandline interface
main "$@"
