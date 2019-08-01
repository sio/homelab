#!/usr/bin/env bash

# Build Markdown table of contents for directory tree containing *.md files
#
# Copyright 2019 Vitaly Potyarkin
# Licensed under Apache License, version 2.0


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
    local TAB="    "
    local workdir="$1"
    if [[ -z "$workdir" ]]
    then
        echo "No workdir specified" >&2
        return 1
    fi

    local files=$(find "$workdir" -type f -iname '*.md'|LC_COLLATE=C.UTF-8 sort)

    local IFS=''
    local olddir='.'
    local level_old=0
    local level_shifted=0
    local filepath
    while read -r filepath
    do
        local relative_path
        relative_path="${filepath#$workdir}"
        relative_path="${relative_path#/}"

        local level="$(tree_level "$relative_path")"
        local basedir="$(dirname "$relative_path")"

        if [[ "$level" == "$level_old" && "$level_shifted" -gt 0 ]]
        then
            level="$level_shifted"
        elif [[ $((level-level_old)) -gt 1 ]]
        then
            if [[ "$level_shifted" -gt 0 ]]
            then
                level_shifted=$((level_shifted+1))
            else
                level_shifted=$((level_old+1))
            fi
            level_old="$level"
            level="$level_shifted"
        else
            level_old="$level"
            level_shifted=0
        fi

        if [[ "$basedir" != "$olddir" && "$basedir" != "." ]]
        then
            if [[ "$(echo "$files"|grep -cE "^$(dirname "$filepath")/[^/]*$")" -gt 1 ]]
            then  # $basedir contains multiple markdown files
                print_repeat "$((level-1))" "$TAB"
                printf -- "- $(basename "$basedir")\n"
            else  # promote the only *.md file to directory level
                level=$((level-1))
            fi
        fi
        olddir="$basedir"

        print_repeat "$level" "$TAB"
        printf -- "- [$(get_title "$filepath")]($relative_path)\n"
    done <<< "$files"
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
