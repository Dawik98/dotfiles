#!/bin/bash 

mv "$1" ~/Documents/Programming/dotfiles/
ln -s ~/Documents/Programming/dotfiles/"$1" "$1"



