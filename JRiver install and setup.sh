#!/bin/bash

##more or less a reminder of things I am going to have to do later.


## HINT: Look at this https://github.com/apt-mirror/apt-mirror



sudo usermod -a -G adm,sudo,audio $USER

curl http://files.jriver.com/mediacenter/channels/v22/latest/MediaCenter-22.0.30-amd64.deb

mediacenter22 /RestoreFromFile ~/Downloads/"Media Center22 Linux-YYYYYY.mjr"

