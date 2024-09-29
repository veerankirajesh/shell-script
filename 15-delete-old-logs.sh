#!/bin/bash

SOURCE_DIE="/tmp/shell-script.logs"

R="\e[31m"
G="e\[32m"
Y="e\[33m"
N="e\0m"

if [! -d $SOURCE_DIE]
then
    echo -e "$R::source directory:$SOURCE_DIR does not exit $N"
fi

FILES_TO_DELETE=$(find $SOURCE_DIR -type f -mtime +14 -name "*.log")

while IFS= read -r line

do
    echo "Deleting file: $line"
    rm -rf $line
done <<< $FILES_TO_DELETE    