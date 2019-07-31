#!/usr/bin/env bash

# Build Markdown table of contents for directory tree containing *.md files
#
# Copyright 2019 Vitaly Potyarkin
# Licensed under Apache License, version 2.0


main() {
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
    local oldlevel=0
    local filepath
    while read -r filepath
    do
        local relative_path
        relative_path="${filepath#$workdir}"
        relative_path="${relative_path#/}"

        local level="$(tree_level "$relative_path")"
        local basedir="$(dirname "$relative_path")"

        [[ "$basedir" == "$olddir" ]] && level="$oldlevel"
        [[ $((level-oldlevel)) > 1 ]] && level=$((oldlevel+1))
        oldlevel="$level"

        if [[ "$basedir" != "$olddir" && "$basedir" != "." ]]
        then
            if [[ "$(echo "$files"|grep -cE "^$(dirname "$filepath")/[^/]*$")" > 1 ]]
            then  # $basedir contains multiple markdown files
                print_repeat "$((level-1))" "$TAB"
                printf -- "- $(basename "$basedir")\n"
                olddir="$basedir"
            else  # promote the only *.md file to directory level
                level=$((level-1))
            fi
        fi

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
