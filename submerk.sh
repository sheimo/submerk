#!/bin/bash
#-Metadata----------------------------------------------------#
#  Filename: submerk.sh             (Update: 2018-06-21) #
#-Info--------------------------------------------------------#
#  Subfinder + Amass + httpscreenshot wrapper                 #
#-Author(s)---------------------------------------------------#
#  sheimo ~ https://github.com/sheimo                         #
#-Operating System--------------------------------------------#
#  Designed for: Kali Linux 2018.2 [x64] (VM - VMware)       #
#     Tested on: Kali Linux 2018.2 x64/x84/full/light/mini/vm #
#-Licence-----------------------------------------------------#
#  MIT License ~ http://opensource.org/licenses/MIT           #
#-------------------------------------------------------------#
#
#Future improvements - Check if exists if not download and install
#
echo "Just gonna install dependencies cause it's quick"
#
#amass - https://github.com/caffix/amass.git
go get -u github.com/caffix/amass
#
#subfinder - https://github.com/Ice3man543/subfinder.git
go get github.com/Ice3man543/subfinder
#
#http screenshot - https://github.com/breenmachine/httpscreenshot.git
cd /opt
git clone https://github.com/breenmachine/httpscreenshot.git > /dev/null && chmod +x /opt/httpscreenshot/install-dependencies.sh && /opt/httpscreenshot/install-dependencies.sh
#
#banner
clear
printf "
 ____        _     __  __           _    
/ ___| _   _| |__ |  \/  | ___ _ __| | __
\___ \| | | | '_ \| |\/| |/ _ | '__| |/ /
 ___) | |_| | |_) | |  | |  __| |  |   < 
|____/ \__,_|_.__/|_|  |_|\___|_|  |_|\_\\

			Created By: Sheimo
			    Version:1.0\n\n"

read -p 'Enter the Domain: ' DOMAINNAME
mkdir /tmp/$DOMAINNAME
mkdir /tmp/$DOMAINNAME/screenshots
echo "[+] $DOMAINNAME Folder Created in /tmp/"
echo "[+] Please way while SubFinder is running..."
#status bar
$HOME/go/bin/subfinder -d $DOMAINNAME -o /tmp/$DOMAINNAME/subfinder-$DOMAINNAME.txt > /dev/null
echo "[+] SubFinder Complete..."
echo "[+] Now running Amass..."
#status bar
$HOME/go/bin/amass -d $DOMAINNAME -o /tmp/$DOMAINNAME/amass-$DOMAINNAME.txt > /dev/null
echo "[+] Amass Complete..."\n
echo "[+] Now Combining and Sorting"
cat /tmp/$DOMAINNAME/amass-$DOMAINNAME.txt /tmp/$DOMAINNAME/subfinder-$DOMAINNAME.txt > /tmp/$DOMAINNAME/$DOMAINNAME-unsorted.txt 
sort -u /tmp/$DOMAINNAME/$DOMAINNAME-unsorted.txt > /tmp/$DOMAINNAME/$DOMAINNAME-final.txt
rm /tmp/$DOMAINNAME/$DOMAINNAME-unsorted.txt
cat /tmp/$DOMAINNAME/$DOMAINNAME-final.txt | awk {'print "https://" $0'} > /tmp/$DOMAINNAME/$DOMAINNAME-final2.txt
cd /tmp/$DOMAINNAME/screenshots
echo "[+] Creating screenshots"
python /opt/httpscreenshot/httpscreenshot.py -l /tmp/$DOMAINNAME/$DOMAINNAME-final2.txt -p -w 10 -a -vH > /dev/null
#open final cluster webpage
python /opt/httpscreenshot/screenshotClustering/cluster.py -d /tmp/$DOMAINNAME/screenshots/ -o /tmp/$DOMAINNAME/final.html
firefox /tmp/$DOMAINNAME/final.html > /dev/null &
echo "[+] Browser is opening screenshot cluster"
echo "[+] Done"