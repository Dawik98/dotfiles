#!/bin/bash 

mv $HOME/.config/$1/ ~/Documents/Programming/dotfiles/
ln -s ~/Documents/Programming/dotfiles/$1 $HOME/.config/



