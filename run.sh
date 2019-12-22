#!/bin/bash
:<<EOF
Change the source of RasoberryPi
EOF

path_main=$(dirname $(readlink -f $0))
path_source_software="/etc/apt/sources.list"
path_source_system="/etc/apt/sources.list.d/raspi.list"
path_source_software_config="${path_main}/config/software.source."
path_source_system_config="${path_main}/config/system.source."
path_website_list="${path_main}/config/website.list"

echo "Start executing the script."
# TODO: Get the system version code
echo "Step 1: Get the system version code."
version_code=`cat /etc/os-release | grep 'VERSION_CODENAME'`
echo $version_code
if [[ $version_code =~ "buster" ]]; then
  path_source_software_config="${path_source_software_config}buster"
  path_source_system_config="${path_source_system_config}buster"
# elif [[ $version_code =~ "stretch" ]]; then
#   echo "[Warn] The system is not up-to-date, it is recommended to update"
#   path_source_software_config="${path_source_software_config}stretch"
#   path_source_system_config="${path_source_system_config}stretch"
# elif [[ $version_code =~ "jessie" ]]; then
#   echo "[Warn] The system is not up-to-date, it is recommended to update"
#   path_source_software_config="${path_source_software_config}jessie"
#   path_source_system_config="${path_source_system_config}jessie"
else
echo "[Error] Unsupported system version code. Exit!"
exit 1
fi

# TODO: Determine network.
echo "Step 2: Determine whether to connect to the network?"
ping -c 1 114.114.114.114 > /dev/null 2>&1
if [ ! $? -eq 0 ]; then
  echo "    [Error] The network is not connected. Please continue after connecting!"
  exit 1
else
  echo "    [OK] The network is connected."
fi

# TODO: Determine if a profile exists.
echo "Step 3: Determine if a profile exists."
if ! [ -f "${path_website_list}" ]
then
  echo "    [Not Exist] website list file: ${path_website_list}"
  exit 1
else
  echo "    [Exist] website list file: ${path_website_list}"
fi

if ! [ -f "${path_source_software_config}" ]
then
  echo "    [Not Exist] software source file: ${path_source_software_config}"
  exit 1
else
  echo "    [Exist] software source file: ${path_source_software_config}"
fi

if ! [ -f "${path_source_system_config}" ]
then
  echo "    [Not Exist] system source file: ${path_source_system_config}"
  exit 1
else
  echo "    [Exist] system source file: ${path_source_system_config}"
fi

# TODO: Select the source that needs to be replaced.
echo "Step 4: Select the source that needs to be replaced."
echo "Source List (In getting information, Please wait a moment):"
# Read ini file sections
# input : 
#   para1: file path
# return: section list
readIniSections() {
    file=$1;
    val=$(awk '/\[/{printf("%s ",$1)}' ${file} | sed 's/\[//g' | sed 's/\]//g')
    echo ${val}
}

# Read ini file val
# input :
#   para1: file path
#   para2: section name
#   para3: item name
# return item value
readIni() {
    file=$1;section=$2;item=$3;
    val=$(awk -F '=' '/\['${section}'\]/{a=1} (a==1 && "'${item}'"==$1){a=0;print $2}' ${file}) 
    echo ${val}
}

website_infos=`readIniSections $path_website_list`
website_infos_array=($website_infos)
list_index=0
printf "    |%-6s |%-16s |%-16s |%-16s |%-16s |%-10s\r\n" number name http_code time_connect speed_download url
for var in $website_infos
do
  website_val=`readIni $path_website_list $var website`
  #domain=`echo ${website_val} | awk -F'[/:]' '{print $4}'`
  result=`curl -m 5 -o /dev/null -s -w %{http_code}:%{time_connect}:%{speed_download} $website_val`
  result_array=(${result//:/ })  
  printf "    |%-6s |%-16s |%-16s |%-16s |%-16s |%-10s\r\n" $list_index $var ${result_array[0]} ${result_array[1]} ${result_array[2]} $website_val
  list_index=`expr $list_index + 1`
done
result_name="raspbian"
while true
do
  read -p "Please enter the number where the source needs to be replaced (Default 0): " result
  if [ -z $result ];then
    result=0
  fi
  ipt_val=`echo $result |sed 's/[-0-9]//g'`
  if [ ! -z $ipt_val ];then
    echo "[ERROR] The input is wrong, Please enter a pure number!"
  elif [ $result -gt `expr $list_index - 1` ];then
    echo "[ERROR] The input is wrong, Number out of range!"
  else
    result_name=${website_infos_array[result]}
    echo "Replacing a source named : " $result_name
    break
  fi
done
result_url=`readIni $path_website_list $result_name website`
result_url=(${result_url//\//\\\/}) 
result_urlpi=`readIni $path_website_list $result_name websitepi`
result_urlpi=(${result_urlpi//\//\\\/}) 
#echo $result_url
#exit 1

# TODO: Replace with the selected source.
echo "Step 5: Replace with the selected source."
# Back up the original file
if ! [ -f "${path_source_software}.bak" ]
then
  echo "    [Not Exist] software source original file, Back up files"
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
else
  echo "    [Exist] software source original file: ${path_source_software}.bak"
fi

if ! [ -f "${path_source_system}.bak" ]
then
  echo "    [Not Exist] system source original file, Back up files"
  sudo cp /etc/apt/sources.list.d/raspi.list /etc/apt/sources.list.d/raspi.list.bak
else
  echo "    [Exist] system source original file: ${path_source_system}.bak"
fi
echo "sudo sed -e \"s/source_url/${result_url}/g\" \"$path_source_software_config\" > ${path_source_software}" | sudo bash
echo "sudo sed -e \"s/source_url/${result_urlpi}/g\" \"$path_source_system_config\" > ${path_source_system}" | sudo bash

# TODO: Update the list of sources.
echo "Step 6: Update the list of sources."
echo "    Please wait a minute to update the source list."
sudo apt-get update #>/dev/null 2>&1
read -p "Do you want to perform the update? It will take some time to execute (yes/no, default: no): " result
if [[ $result == "yes" || $result == "y" ]]; then
  echo "Start the update task (Press Ctrl+C to exit)."
  sudo apt-get upgrade -y #>/dev/null 2>&1
  sudo apt-get dist-upgrade 
else 
  echo "Upgrade action cancellation"
fi
echo "[OK] The source was replaced successfully."





