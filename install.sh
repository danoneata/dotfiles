#!/bin/bash

cd "$(dirname "$0")"
# git pull

function do_it() {
    for file in "`ls`"
    do
        # ln -sf $file ~/.$file
    done
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    do_it
else
    read -p "This may overwrite existing files in your home directory. Do you want to continue? (y/n)" -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        do_it
    fi
fi

unset do_it
source ~/.bash_profile
