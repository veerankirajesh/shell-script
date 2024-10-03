#!/bin/bash

NAME=""
WISHES="Good Morning"

USAGE(){
    echo "USAGE:: $(basename $0) -n <name> -w <wishes>"
    echo "options::"
    echo " -n, specify the name (mondatory)"
    echo " -w, specify the wishes.(optional).Good morning"
    echo " -h, Display Help and exit"
}

while getopts ":n:w:h" opt; do
    case $opt in
        n) NAME="$OPTARG";;
        w) WISHES="$OPTARG";;
        \?) echo "invalid options: -"$OPTARG"" >&2; USAGE; exit;;
        :) USAGE; exit;;
        h) USAGE; exit;;
    esac
done

#if [ -z "$NAME" ] || [ -z "$WISHES" ]; then
if [ -z "$NAME" ]; then # now wishes is optional
    #echo "ERROR: Both -n and -w are mandatory options."
    echo "ERROR: -n is mandatory."
    USAGE
    exit 1
fi

echo "Hello $NAME. $WISHES. I have been learning Shell Script."