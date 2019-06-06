#!/bin/bash

cd
sudo apt-get update
sudo apt-get updgrade
sudo apt-get install make
sudo apt-get install gcc

#bluetooth libraries
sudo apt-get install libelf-dev
sudo apt-get install bluez

wget https://www.kernel.org/pub/linux/bluetooth/bluez-5.41.tar.xz
tar xvf bluez-5.41.tar.xz
sudo apt-get install libudev-dev libical-dev libreadline6-dev libdbus-1-dev libglib2.0-dev
cd bluez-5.41
./configure
make
sudo make install
cd ..

#Ubertooth installation
sudo apt-get install cmake libusb-1.0-0-dev g++ libbluetooth-dev \
pkg-config libpcap-dev python-numpy python-pyside python-qt4

wget https://github.com/greatscottgadgets/libbtbb/archive/2018-12-R1.tar.gz -O libbtbb-2018-12-R1.tar.gz
tar -xf libbtbb-2018-12-R1.tar.gz
cd libbtbb-2018-12-R1
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig

cd

wget https://github.com/greatscottgadgets/ubertooth/releases/download/2018-12-R1/ubertooth-2018-12-R1.tar.xz
tar xf ubertooth-2018-12-R1.tar.xz
cd ubertooth-2018-12-R1/host
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig

cd

sudo apt-get install wireshark wireshark-dev libwireshark-dev cmake
cd libbtbb-2018-12-R1/wireshark/plugins/btbb
mkdir build
cd build
cmake -DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu/wireshark/libwireshark3/plugins ..
make
sudo make install

cd

sudo apt-get install wireshark wireshark-dev libwireshark-dev cmake
cd libbtbb-2018-12-R1/wireshark/plugins/btbredr
mkdir build
cd build
cmake -DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu/wireshark/libwireshark3/plugins ..
make
sudo make install

cd

#to convert pcap to text file
sudo apt-get install tshark

#nodejs and npm modules for replay attack
sudo apt-get install nodejs
sudo apt-get install npm

echo -e "\n\n"
echo -e "Checking nodejs version "
echo -e "\n"
node -v
echo -e "Checking npm version "
echo -e "\n"
npm -v
echo -e "\n\n"
echo -e "Falcon works stable on node version v8.10.0 and npm v3.5.2"

cd

#installing node modules
sudo clear
npm install noble
npm install bleno
npm install gattacker

#installing pexpect for DoS
pip install pexpect

