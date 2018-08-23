#!/usr/bin/env bash
echo "Just gonna install dependencies cause it's quick"
echo "Proper installation relies on a correctly configured go environment..."
sleep 3
#Test for or get root.
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@" || exit 1
if ! command -v go &>/dev/null; then echo "Go could not be found. Install and configure that first."; exit 1; fi
if [ -z $GOPATH ]; then echo "GOPATH not set. Fix it before continuing."; exit 2; fi
echo '"Getting" amass...'
go get -u github.com/caffix/amass
echo '"Getting" subfinder...'
go get github.com/Ice3man543/subfinder
echo '"Getting" httpscreenshot...'
#http screenshot - https://github.com/breenmachine/httpscreenshot.git
echo "Installing httpscreenshot to /opt..."
cd /opt
git clone https://github.com/breenmachine/httpscreenshot.git > /dev/null && sh /opt/httpscreenshot/install-dependencies.sh
