#!/bin/bash

cd "$(dirname "$0")"
# cd
# git clone https://github.com/danoneata/dotfiles

function do_it() {
    for file in "`ls`"
    do
        # TODO ln -f doesn't force overwriting the existing file. 
        # Find another way: move existing files to a backup folder and then create links.
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
