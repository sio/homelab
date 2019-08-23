#!/usr/bin/env bash

# Build Markdown table of contents for directory tree containing *.md files
#
# Copyright 2019 Vitaly Potyarkin
# Licensed under Apache License, version 2.0


TAB="    "   # indentation unit


main() {
    local dir="$1"
    local output="$(basename "$2")"
    case "$#" in
    1)
        if [[ "$dir" =~ ^(-h|--help|--usage)$ ]]
        then
            main  # call without args to trigger help message
        else
            generate_toc "$dir"
        fi
        ;;
    2)
        generate_toc "$dir" | grep -v "($output)" > "$2"
        ;;
    *)
        printf "%s\n" \
            "Usage: $(basename "$0") DIRECTORY [TOC_FILE]" \
            "" \
            "Generate Markdown table of contents for directory tree that contains *.md files." \
            "If TOC_FILE is provided it will be used for output instead of stdout."
        ;;
    esac
}

generate_toc() {
    local workdir="$1"
    if [[ -z "$workdir" ]]
    then
        echo "No workdir specified" >&2
        return 1
    fi

    local files=$(find "$workdir" -type f -iname '*.md'|LC_COLLATE=C.UTF-8 sort)

    local oldpath=''
    local number_of_parents=0

    local filepath
    local IFS=''
    while read -r filepath
    do
        local relative_path
        relative_path="${filepath#$workdir}"
        relative_path="${relative_path#/}"

        local level="$(tree_level "$relative_path")"
        local common_level="$(common_base_level "$relative_path" "$oldpath")"

        if [[ "$((level - common_level))" -eq 0 ]]
        then  # same directory as before
            number_of_parents=0
        else  # switching to a different directory
            if [[ "$(echo "$files"|grep -cE "^$(dirname "$filepath")/[^/]*$")" -eq 1 ]]
            then  # promote the only *.md file to directory level
                level=$((level - 1))
            fi
            number_of_parents=$((level - common_level))
        fi

        #echo "$level" "$common_level" "$number_of_parents"  #debug
        print_toc_item "$filepath" "$relative_path" "$level" "$number_of_parents"
        oldpath="$relative_path"
    done <<< "$files"
}


print_toc_item() {
    local filepath="$1"
    local relative_path="$2"
    local level="$3"
    local number_of_parents="$4"
    [ -z "$number_of_parents" ] && number_of_parents=0

    local IFS='/'
    local path_elements
    read -ra path_elements <<< "$filepath"

    # Print parent directories headers
    local i
    for ((i = level - number_of_parents; i < level; i++))
    do
        print_repeat "$i" "$TAB"
        printf -- "- ${path_elements[i+1]}\n"
    done

    # Print a hyperlink to the file itself
    print_repeat "$level" "$TAB"
    printf -- "- [$(get_title "$filepath")]($relative_path)\n"
}


print_repeat() {
    local repeats="$1"
    local string="$2"

    local i
    for ((i=0; i<"$repeats"; i++))
    do
        printf "$string"
    done
}


tree_level() {
    local path="$1"
    local delimiter="/"
    local result="${path//[^$delimiter]/}"
    echo "${#result}"
}


common_base_level() {
    local this="$1"
    local other="$2"
    local i
    local common_base=""
    for ((i=0; i<"${#this}"; i++))
    do
        if [[ "${this:i:1}" == "${other:i:1}" ]]
        then
            continue
        else
            break
        fi
    done
    common_base="${this:0:i}"
    tree_level "$common_base"
}


get_title() {
    local mdfile="$1"
    local header=$(head "$mdfile"|grep -E '^#'|head -n1)

    if [[ -z "$header" ]]
    then
        echo "$(basename "$mdfile")"
        return
    fi

    local i char
    for ((i=0; i<${#mdfile}; i++))
    do
        char=${header:$i:1}
        [[ "$char" != "#" && "$char" != " " ]] && break
    done
    echo "${header:$i}"
}


# if __name__ == '__main__'   //  <https://stackoverflow.com/a/45988155>
get_caller() { echo "${FUNCNAME[1]}"; }
if [[ "$(get_caller)" == "main" ]]
then
    main "$@"
fi
