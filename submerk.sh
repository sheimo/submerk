#!/usr/bin/env bash
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
#banner
#clear
printf "
 ____        _     __  __           _    
/ ___| _   _| |__ |  \/  | ___ _ __| | __
\___ \| | | | '_ \| |\/| |/ _ | '__| |/ /
 ___) | |_| | |_) | |  | |  __| |  |   < 
|____/ \__,_|_.__/|_|  |_|\___|_|  |_|\_\\

			Created By: Sheimo...L3vi47h4N helped too.
			    Version:1.1\n\n"

outdir="/tmp/submerk"
subfinder="$GOPATH/subfinder"
amass="$GOPATH/amass"
httpscreenshot="/opt/httpscreenshot/httpscreenshot.py"
cluster="/opt/httpscreenshot/screenshotClustering/cluster.py"

# Check if we have everything.
if [[ ! -f "$subfinder" || ! -f "$amass" || ! -f "$httpscreenshot" || ! -f "$cluster" ]]; then echo "A dependency is missing or not in the path expected. Did you run setup.sh?"; exit 1; fi

# Parse the domain from first argument, otherwise, ask for it.
if [ -z "$1" ]; then read -p 'Enter the Domain: ' domainname; else domainname="$1"; fi
mkdir -p "$outdir/$domainname/screenshots"
if [ ! -d "$outdir/$domainname/screenshots" ]; then echo "Unable to create output directory."; exit 1; fi
echo "[+] $domainname Folder Created in $outdir"
echo "[+] Please wait while SubFinder is running..."
#status bar
$subfinder -d "$domainname" -o "$outdir/$domainname/subfinder-$domainname.txt" > /dev/null
echo "[+] SubFinder Complete..."
echo "[+] Now running Amass..."
#status bar
$amass -d "$domainname" -o "$outdir/$domainname/amass-$domainname.txt" > /dev/null
echo "[+] Amass Complete..."\n
echo "[+] Now combining, sorting, and removing dupes..."
cat "$outdir/$domainname/amass-$domainname.txt" "$outdir/$domainname/subfinder-$domainname.txt" > "$outdir/$domainname/$domainname-unsorted.txt"
sort -u "$outdir/$domainname/$domainname-unsorted.txt" > "$outdir/$domainname/$domainname-submerkdomains.txt"
rm "$outdir/$domainname/$domainname-unsorted.txt"
awk {'print "https://" $0'} "$outdir/$domainname/$domainname-submerkdomains.txt" > "$outdir/$domainname/$domainname-submerkhttps.txt"
cd "$outdir/$domainname/screenshots"
echo "[+] Creating screenshots..."
python $httpscreenshot -l "$outdir/$domainname/$domainname-submerkhttps.txt" -p -w 10 -a -vH > /dev/null
#open final cluster webpage
python $cluster -d "$outdir/$domainname/screenshots/" -o "$outdir/$domainname/screenshot-cluster.html"
xdg-open "$outdir/$domainname/screenshot-cluster.html" > /dev/null &
echo "[+] Browser is opening screenshot cluster"
echo "[+] Done"
