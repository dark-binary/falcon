#!/bin/bash
sudo hciconfig hci3 down
sudo hciconfig hci3 up
sudo hcitool -i hci3 cmd 0x08 0x0008 1E 02 01 1A 1A FF 4C 00 02 15 E2 0A 39 F4 73 F5 4B C4 A1 3F 17 D1 AD 07 A9 61 FF 03 FF 03 C8 04
sudo hcitool -i hci3 cmd 0x08 0x0006 01 00 01 00 00 00 00 00 00 00 00 00 00 07 00
sudo hcitool -i hci3 cmd 0x08 0x000A 01
sudo hciconfig hci3 noscan
