#!/bin/bash
# file: screen_capture.sh
# description: capture screen
# author: psychosis448
# date: 2020-04-02
# version: 0.1
# bash_version: 5.0.16

IMG=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 8)
import -window root "$HOME/img/sc/$IMG.png"
