#!/bin/bash

set -eu
DOTDIR=$(pwd)

cd
for DOTFILE in $DOTDIR/files/*
do
    FILENAME=$(basename $DOTFILE)
    ln -s $DOTFILE .$FILENAME
done
