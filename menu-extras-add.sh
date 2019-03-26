#!/usr/bin/env bash

# Default ~/Library/Preferences/com.apple.systemuiserver.plist created by macOS Mojave Beta 10.14 (18A384a)
#<?xml version="1.0" encoding="UTF-8"?>
#<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
#<plist version="1.0">
#<dict>
#	<key>NSStatusItem Visible Siri</key>
#	<false/>
#	<key>NSStatusItem Visible com.apple.menuextra.airport</key>
#	<true/>
#	<key>NSStatusItem Visible com.apple.menuextra.appleuser</key>
#	<true/>
#	<key>NSStatusItem Visible com.apple.menuextra.battery</key>
#	<true/>
#	<key>NSStatusItem Visible com.apple.menuextra.clock</key>
#	<true/>
#	<key>__NSEnableTSMDocumentWindowLevel</key>
#	<true/>
#	<key>last-messagetrace-stamp</key>
#	<real>558608575.04967403</real>
#	<key>menuExtras</key>
#	<array>
#		<string>/System/Library/CoreServices/Menu Extras/User.menu</string>
#		<string>/System/Library/CoreServices/Menu Extras/Clock.menu</string>
#		<string>/System/Library/CoreServices/Menu Extras/Battery.menu</string>
#		<string>/System/Library/CoreServices/Menu Extras/AirPort.menu</string>
#	</array>
#</dict>
#</plist>

MenuExtraItemExists () {
    # Get a list of current array elements in the menuExtras key and read them into the new temporary array `MenuExtraItems`
    declare -a MenuExtraItems=($(/usr/libexec/PlistBuddy -c "Print :menuExtras" $plist | sed -e 1d -e '$d'))

    for e in "${MenuExtraItems[@]}"; do
        echo "$e"
    done

    unset MenuExtraItems
}




# $1 is the part of the key's name that makes it unique from other keys i.e. airport, appleuser, battery, clock etc
# $2 is the part of an array element of the key `menuExtras` that makes it unique from other array elements i.e. AirPort, User, Battery, Clock etc

domain=com.apple.menuextra.$1
plist=~/Library/Preferences/com.apple.systemuiserver.plist

case "$1" in
    airport)
        menu=AirPort
        ;;
    appleuser)
        menu=User
        ;;
    battery)
        menu=Battery
        ;;
    bluetooth)
        menu=Bluetooth
        ;;
    clock)
        menu=Clock
        ;;
    scriptmenu)
        domain=com.apple.$1
        menu=Script\ Menu
        ;;
	textinput)
        menu=TextInput
        ;;
    TimeMachine)
        menu=TimeMachine
        ;;
    volume)
        menu=Volume
        ;;
    vpn)
        menu=VPN
        ;;
    *)
        echo "ERROR: '$1' is not valid. Please try again."
        exit 1
esac

# Check if key already exists in com.apple.systemuiserver.plist, if not create it
if [[ ! $(/usr/libexec/PlistBuddy -c "Print :NSStatusItem\ Visible\ $domain" $plist 2>/dev/null) ]]; then
    # The key doesn'y exist so create it
    /usr/libexec/PlistBuddy -c "Add :NSStatusItem\ Visible\ $domain bool true" $plist

    # The menuExtras key should already exist as it's included in the default com.apple.systemuiserver.plist for a new user, but let's check anyway and create it if it doesn't
    if [[ ! $(/usr/libexec/PlistBuddy -c "Print :menuExtras" $plist 2>/dev/null) ]]; then
        /usr/libexec/PlistBuddy -c "Add :menuExtras array" $plist
    fi

    # To check if $2 already exists as an array element of the menuExtras key we use `PlistBuddy` to get a list of the current array elements which is then piped to `grep`.
    # The line number of $2 within the list of array elements is returned by `grep` and stored in the `$line` variable. If there's no match `$line` will be empty.
    line=$(/usr/libexec/PlistBuddy -c "Print :menuExtras" $plist | sed -e 1d -e '$d' | grep -n "$menu" | cut -d : -f 1)

    # We can then decrease the value of `$line` by 1 to obtain the index (arrays are zero based) of $2 within the menuExtras array.
    # If the result is -1 then $2 doesn't exist in the menuExtras array and we can add it.
    if [[ $((line - 1)) -eq -1 ]]; then
        /usr/libexec/PlistBuddy -c "Add :menuExtras: string /System/Library/CoreServices/Menu\ Extras/$menu.menu" $plist
        #echo "Array '/System/Library/CoreServices/Menu\ Extras/$2.menu' added."
    fi
fi

#killall SystemUIServer
