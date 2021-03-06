#!/bin/bash

function showOptions() {
    echo "-d,  Directory to install all apps within."
    echo "-h,  Show this help message."
    echo "Usage: $(basename $0) [Options] [App(s) to install]"
    echo "Example: $(basename $0) ~/Downloads/VLC.app"
}

function installApp() {
    appName=$(basename $1)
    echo Installing $appName to /Applications
    sudo rm -Rf /Applications/$appName
    cp -Rf $1 /Applications
}

while getopts d:h option; do
    case $option in
        d)
            directory=$OPTARG
        ;;
        h)
            showOptions
            exit 0
        ;;
    esac
done

shift $((OPTIND-1))

if [[ $directory ]]; then
    apps=$(find $directory -name *.app)
elif [[ $@ ]]; then
    apps=$@
else
    showOptions
    exit 1
fi

for app in $apps; do
    if [[ ! -e $app ]]; then
        echo "Could not find $app. Make sure the path is correct."
        continue
    fi
    installApp $app
done
