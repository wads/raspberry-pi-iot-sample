#! /bin/bash

sudo apt-get update

# install required packages
sudo apt-get install -y emacs jq

# install node
sudo apt-get install -y nodejs npm
sudo npm cache clean
sudo npm install npm n -g
sudo n lts
