# Falcon


![Falcon](falcon_logo.png)


**What is BLE?**

BLE stands for "Bluetooth Low Energy". BLE  is a variation of the Bluetooth wireless standard designed for low power consumption. This was developed for applications that work with low power devices and have to contend with weak signals such as fitness devices, proximity sensors, bulbs and locks.

<br/>
<br/>

**Why does BLE need Penetration testing?**

"With low power, comes low security". These devices interact with humans every single day with least security embedded on it. If and when an attacker compromises any of these devices, it could not just result in data theft but also has a physical impact to a user. This brings out the need to assess  every device.  

<br/>

Falcon is a BLE Penetration testing tool that can automate and perform a list of attacks that should be screened for, to prevent exploitation of BLE devices. We have narrowed down all the possible BLE attacks to five fundamental ones, which are key to building and therefore preventing a range of other attacks.

Following are the list of attacks that Falcon does,

1. Gain illegal access - This attack exploits the authorization by gaining illegal access to a device.

2. Sniffing            - This attack performs an eaves dropping on any BLE device to capture the valid transaction of packets.

3. Replay attack       - Combination of both Man In The Middle and Replay attack to retransmit the captured valid packets to a device.

4. Denial of Service   - This attack keeps sending heart beats to a connection infinitely making it not able to connect with other users.

5. BLE Jammer 1        - Performing DoS attack on any and every active devices in the range.

6. BLE Jammer 2        - With more BLE adapters to act as beacons, it is possible to crash the 3 advertisement channels.

<br/>
<br/>


**Required hardwares:** <br/>
**--------------------------------**

BLE adapters  <br/>
Ubertooth - Bluetooth sniffer <br/>
A BLE device to perform the testing <br/>

<br/>
<br/>


**Installation:** <br/>
**------------------**

Falcon needs a few pre-requisites to be installed to make the tool become fully functional.
Run the install.sh file from the terminal,

$ bash install.sh


<br/>
<br/>


**Usage:** <br/>
**-----------**

Make sure the BLE adapter and Ubertooth are connected to the system.
Run the falcon.sh file from the terminal,

$ bash falcon.sh

When prompted, enter the choice of your attack.


1. Illegal access gets you the list of write handles in a BLE device.

2. Sniffing gives you the format of the values you can use to change the characteristics in a BLE device.

3. With the help of previously fetced "write handle (Illegal access)" and "characterisitic value format (Sniffing)" you can now give input to change the functionalities of a device.

4.  Replay attack involves using an additional system or a Raspberry pi to act as a slave machine.

5.  Denial of service is successful when a device is not currently in connection with any other client application.

6. BLE Jammer 1 also is applicable only if the devices are not currently in connection with any other client applications.

7. BLE Jammer 2 sends out advertisement packets from a BLE adapter to act as a beacon with the least possible delay between packets to flood the 3 advertisement channels.

8. Exit clears all the scan files and terminates the application.


