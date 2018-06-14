#! /bin/bash

sudo apt-get update

# install required packages
sudo apt-get install -y emacs jq eject

# install node
sudo apt-get install -y nodejs npm
sudo npm cache clean
sudo npm install npm n -g
sudo n lts

# install AWS IoT SDK
npm install aws-iot-device-sdk
