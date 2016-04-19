#!/bin/bash

set -eu
DOTDIR=$(pwd)

cd
for DOTFILE in $DOTDIR/files/*
do
    FILENAME=$(basename $DOTFILE)
    rm -f .$FILENAME
done
