#!/bin/bash
hci=$1
sudo hciconfig $hci down
sudo hciconfig $hci up

echo -e "\n\n"
echo -e "Starting to advertise on $hci"
echo -e "\n\n"
sudo hcitool -i $hci cmd 0x08 0x0008 1E 02 01 1A 1A FF 4C 00 02 15 E2 0A 39 F4 73 F5 4B C4 A1 2F 17 D1 AD 07 A9 61 FF FF FF FF C8 04
sudo hcitool -i $hci cmd 0x08 0x0006 01 00 01 00 00 00 00 00 00 00 00 00 00 07 00
sudo hcitool -i $hci cmd 0x08 0x000A 01
sudo hciconfig $hci noscan
