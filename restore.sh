#!/bin/bash
:<<EOF
Restore the source of RasoberryPi
EOF

path_main=$(dirname $(readlink -f $0))
path_source_software="/etc/apt/sources.list"
path_source_system="/etc/apt/sources.list.d/raspi.list"
path_source_software_bak="/etc/apt/sources.list.bak"
path_source_system_bak="/etc/apt/sources.list.d/raspi.list.bak"

# TODO: Determine network.
echo "Step 1: Determine whether to connect to the network?"
ping -c 1 114.114.114.114 > /dev/null 2>&1
if [ ! $? -eq 0 ]; then
  echo "    [Error] The network is not connected. Please continue after connecting!"
  exit 1
else
  echo "    [OK] The network is connected."
fi

# TODO: Determine if the backup file exists?
echo "Step 2: Determine if the backup file exists?"
if ! [ -f "${path_source_software_bak}" ]
then
  echo "    [Not Exist] software list backup file: ${path_source_software_bak}"
  exit 1
else
  echo "    [Exist] software list backup file: ${path_source_software_bak}"
fi

if ! [ -f "${path_source_system_bak}" ]
then
  echo "    [Not Exist] system source backup file: ${path_source_system_bak}"
  exit 1
else
  echo "    [Exist] system source backup file: ${path_source_system_bak}"
fi

read -p "Are you sure you are restoring the source file? (yes/no, default: no):" result
if [[ $result == "yes" || $result == "y" ]]; then
  echo "Start the restore task (Press Ctrl+C to exit)."
  sudo cp /etc/apt/sources.list.bak /etc/apt/sources.list
  sudo cp /etc/apt/sources.list.d/raspi.list.bak /etc/apt/sources.list.d/raspi.list
  sudo rm /etc/apt/sources.list.bak
  sudo rm /etc/apt/sources.list.d/raspi.list.bak
else
  echo "Action cancellation."
  exit 1
fi

# TODO: Update the list of sources.
echo "Step 3: Update the list of sources."
echo "    Please wait a minute to update the source list."
sudo apt-get update #>/dev/null 2>&1
read -p "Do you want to perform the update? It will take some time to execute (yes/no, default: no):" result
if [[ $result == "yes" || $result == "y" ]]; then
  echo "Start the update task (Press Ctrl+C to exit)."
  sudo apt-get upgrade -y #>/dev/null 2>&1
  sudo apt-get dist-upgrade 
else 
  echo "Upgrade action cancellation"
fi
echo "[OK] The source was replaced successfully."


