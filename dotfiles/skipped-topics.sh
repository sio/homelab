#!/usr/bin/env bash
#
# Find topics that are not included into any topic list
#


DOTFILES=$(dirname "$0")


# Read topic list filenames from commandline or use defaults
if [[ -z "$@" ]]
then
    TOPICS=("$DOTFILES/topic"*)
else
    TOPICS=("$@")
fi


# Check each topic against all lists
IFS=$'\n'
missing=()
for topic in $(find "$DOTFILES" -mindepth 1 -maxdepth 1 -type d)
do
    if ! grep -qE "^$(basename "$topic")([\r\n]*|$)" "${TOPICS[@]}"
    then
        missing+=("$topic")
    fi
done


# Report missing topics
if [[ ${#missing[@]} -gt 0 ]]
then
    printf "The following topics are not included into any topic list:\n"
    printf "    %s\n" "${missing[@]}"
else
    printf "All topics are placed in the topic lists\n"
fi
