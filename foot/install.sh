#!/usr/bin/env bash

rm -rf $HOME/.local/share/applications/foot.desktop
ln -s foot.desktop $HOME/.local/share/applications/foot.desktop

rm -rf $HOME/.local/bin/foot-launch
ln -s foot-launch $HOME/.local/bin/foot-launch

ln -s $HOME/.dotfiles/foot $HOME/.config
