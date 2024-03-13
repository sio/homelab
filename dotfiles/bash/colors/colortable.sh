#!/bin/bash
#
#   https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797

header() {
    printf "\e[1m\n$@\n\e[0m"
}
newline() {
    local i="$1"
    if (( i==15 | i==7 | ( (i>15) & ((i-15)%6==0) ) )); then
        printf "\n";
    fi
}

header "Background colors"
for i in {0..255} ; do
    printf "\e[48;5;%sm %3d \e[0m " "$i" "$i"
    newline "$i"
done

header "Foreground colors"
for i in {0..255} ; do
    printf "\e[38;5;%sm %3d \e[0m " "$i" "$i"
    newline "$i"
done

header "Foreground colors, bold"
for i in {0..255} ; do
    printf "\e[1m\e[38;5;%sm %3d \e[0m " "$i" "$i"
    newline "$i"
done
