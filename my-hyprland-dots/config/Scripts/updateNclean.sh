#!/bin/bash

echo "first we are gonna delete orphaned useless packages"

sleep 3

sudo pacman -Rns $(pacman -Qdtq) --noconfirm

sleep 1

yay -Rns $(yay -Qdtq) --noconfirm

sleep 1

flatpak remove --unused

sleep 2

echo "now we are gonna clear da caches"

sleep 4

sudo pacman -Scc --noconfirm

sleep 1

yay -Scc --noconfirm

sleep 1

flatpak remove --delete-data

sleep 2 

echo "now we are gonna update"

sleep 2

sudo pacman -Syu --noconfirm

sleep 1

yay -Syu --noconfirm

sleep 1

flatpak update

echo "your system is now clean and updated!!"
