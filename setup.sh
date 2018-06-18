#! /bin/bash

sudo timedatectl set-timezone Asia/Tokyo
sudo sed -i -e '/ja_JP.UTF-8/s/^# *//' /etc/locale.gen
sudo locale-gen

# UART
# see https://gist.github.com/CLCL/e0f840461e20a3a83179b4941d45c203
echo "
> # UART
> enable_uart=1" | sudo tee -a /boot/config.txt
sudo raspi-config nonint do_serial 1
sudo sed -i -e 's/enable_uart=0/enable_uart=1/' /boot/config.txt
sudo systemctl stop serial-getty@ttyS0.service
sudo systemctl mask serial-getty@ttyS0.service

sudo apt-get update

# install required packages
sudo apt-get install -y emacs jq eject usb-modeswitch

# install node
sudo apt-get install -y nodejs npm
sudo npm cache clean
sudo npm install npm n -g
sudo n lts

# install AWS IoT SDK
npm install aws-iot-device-sdk
npm install serialport
npm install node-nmea
