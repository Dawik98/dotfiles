#!/bin/bash 

mv ~/.config/$1/ ~/Documents/Programming/dotfiles/
ln -s ~/Documents/Programming/dotfiles/$1 $HOME/.config/



