#!/bin/sh

mkdir -p ~/.config/kak/autoload/
cp init.kak ~/.config/kak/autoload/
mkdir -p ~/.config/kak/plugins/
git clone https://github.com/andreyorst/plug.kak.git ~/.config/kak/plugins/plug.kak

