# 更新日志
- 2019-11-24: 脚本开发完成，仅支持buster版本系统

# 部署说明

由于树莓派默认源下载速度慢，所以开发该脚本，用于更换国内源。

## 更换源
打开文件夹，运行 `run.sh` 脚本
```shell
./run
```

运行结果如下：
```shell
Start executing the script.
Step 1: Get the system version code.
VERSION_CODENAME=buster
Step 2: Determine whether to connect to the network?
    [OK] The network is connected.
Step 3: Determine if a profile exists.
    [Exist] website list file: /home/pi/raspi_source_change/config/website.list
    [Exist] software source file: /home/pi/raspi_source_change/config/software.source.buster
    [Exist] system source file: /home/pi/raspi_source_change/config/system.source.buster
Step 4: Select the source that needs to be replaced.
Source List (In getting information, Please wait a moment):
    |number |name             |http_code        |time_connect     |speed_download   |url       
    |0      |raspbian         |200              |0.833397         |1074.000         |http://raspbian.raspberrypi.org/raspbian/
    |1      |ustc             |200              |0.099745         |2722.000         |http://mirrors.ustc.edu.cn/raspbian/raspbian/
    |2      |aliyun           |200              |0.122724         |2914.000         |http://mirrors.aliyun.com/raspbian/raspbian/
    |3      |tuna.tsinghua    |200              |0.040178         |14298.000        |http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/
    |4      |scau             |200              |0.053885         |10876.000        |https://mirrors.scau.edu.cn/raspbian/
    |5      |neusoft          |200              |0.031657         |32744.000        |http://mirrors.neusoft.edu.cn/raspbian/raspbian/
    |6      |cqu              |200              |0.054576         |3622.000         |http://mirrors.cqu.edu.cn/raspbian/raspbian/
Please enter the number where the source needs to be replaced (Default 0): 3
Replacing a source named :  tuna.tsinghua
Step 5: Replace with the selected source.
    [Exist] software source original file: /etc/apt/sources.list.bak
    [Exist] system source original file: /etc/apt/sources.list.d/raspi.list.bak
Step 6: Update the list of sources.
    Please wait a minute to update the source list.
Hit:1 http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian buster InRelease
Reading package lists... Done
W: Target Packages (main/binary-armhf/Packages) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
W: Target Packages (main/binary-all/Packages) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
W: Target Translations (main/i18n/Translation-en_GB) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
W: Target Translations (main/i18n/Translation-en) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
W: Target Packages (main/binary-armhf/Packages) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
W: Target Packages (main/binary-all/Packages) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
W: Target Translations (main/i18n/Translation-en_GB) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
W: Target Translations (main/i18n/Translation-en) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
Do you want to perform the update? It will take some time to execute (yes/no, default: no): y
Start the update task (Press Ctrl+C to exit).
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Calculating upgrade... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Calculating upgrade... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
[OK] The source was replaced successfully.
```

## 还原备份
打开文件夹，运行 `restore.sh` 脚本
```shell
./restore
```
运行结果如下：
```shell
Start executing the script.
Step 1: Determine whether to connect to the network?
    [OK] The network is connected.
Step 2: Determine if the backup file exists?
    [Exist] software list backup file: /etc/apt/sources.list.bak
    [Exist] system source backup file: /etc/apt/sources.list.d/raspi.list.bak
Are you sure you are restoring the source file? (yes/no, default: no): y
Start the restore task (Press Ctrl+C to exit).
Step 3: Update the list of sources.
    Please wait a minute to update the source list.
Get:1 http://mirrors.aliyun.com/raspbian/raspbian buster InRelease [15.0 kB]
Get:2 http://mirrors.aliyun.com/raspbian/raspbian buster/main armhf Packages [13.0 MB]
Get:3 http://mirrors.aliyun.com/raspbian/raspbian buster/contrib armhf Packages [58.7 kB]                                                                                                                                  
Get:4 http://mirrors.aliyun.com/raspbian/raspbian buster/non-free armhf Packages [103 kB]                                                                                                                                  
Get:5 http://mirrors.aliyun.com/raspbian/raspbian buster/rpi armhf Packages [1,360 B]                                                                                                                                      
Fetched 13.2 MB in 13s (1,041 kB/s)                                                                                                                                                                                        
Reading package lists... Done
W: Target Packages (main/binary-armhf/Packages) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
W: Target Packages (main/binary-all/Packages) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
W: Target Translations (main/i18n/Translation-en_GB) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
W: Target Translations (main/i18n/Translation-en) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
W: Target Packages (main/binary-armhf/Packages) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
W: Target Packages (main/binary-all/Packages) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
W: Target Translations (main/i18n/Translation-en_GB) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
W: Target Translations (main/i18n/Translation-en) is configured multiple times in /etc/apt/sources.list:1 and /etc/apt/sources.list.d/raspi.list:1
Do you want to perform the update? It will take some time to execute (yes/no, default: no): y
Start the update task (Press Ctrl+C to exit).
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Calculating upgrade... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Calculating upgrade... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
[OK] The source was restored successfully.
```