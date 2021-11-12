#!/usr/bin/env bash

# NSGlobalDomain is synonymous with the .GlobalPreferences
# '-g' and '-globalDomain' can be used as synonyms for NSGlobalDomain or .GlobalPreferences

# macOS 10.14 Mojave




# # # # # # # # # # # # # # # # # # # # # # # # # #
# # ENVIRONMENT SETUP
# #

# Do not run this script as root
    if [[ $EUID -eq 0 ]]; then
        clear
        echo -ne '\007'
        echo "ERROR: This script must NOT be run as root" 1>&2
        sudo -k
        exit 1
    fi


# This Bash script executes several AppleScripts which target other applications like the Finder, Script Editor, System Events and System Preferences. Beginning with macOS Mojave, applications that control other applications need to be given explicit authority the first time they request to do so. As it is the Terminal application that ultimately wants to control the other applications by running AppleScripts, macOS Mojave will prompt the user to grant the Terminal application authority to do so for each individual application to which the response should be `OK`. The Terminal application will then appear in System Preferences > Security & Privacy > Privacy > Automation with a list of applications it has authority to control. Authority to control an application can later be revoked on a per application basis by unchecking the appropriate application in the list.

# To avoid having the user respond to prompts at different times throughout the execution of this Bash script, the following AppleScripts – when run – will ensure that authority is given up-front.
    osascript -e 'tell app "Finder" to display notification "Pardon my appearance" with title "Finder says"' > /dev/null 2>&1
    osascript -e 'tell app "Script Editor" to display notification "Pardon my appearance" with title "Script Editor says"' > /dev/null 2>&1
    osascript -e 'tell app "System Events" to display notification "Pardon my appearance" with title "System Events says"' > /dev/null 2>&1
    osascript -e 'tell app "System Preferences" to display notification "Pardon my appearance" with title "System Preferences says"' > /dev/null 2>&1


# AppleScript to check if GUI Scripting is enabled. Will rightly fail for new macOS installations.
# If called by `Script Editor` then `Script Editor` must be checked in System Preferences > Security & Privacy > Privacy > Accessibility
# If called by `Terminal` (this case) then `Terminal` must be checked in System Preferences > Security & Privacy > Privacy > Accessibility
# If called by `iTerm` then `iTerm` must be checked in System Preferences > Security & Privacy > Privacy > Accessibility
osascript > /dev/null 2>&1 <<EOD
    # check to see if assistive devices is enabled
    tell application "System Events"
        set UI_enabled to UI elements enabled
    end tell
    if UI_enabled is false then
        tell application "System Preferences"
            activate
            set current pane to pane id "com.apple.preference.security"
            reveal anchor "Privacy_Assistive" of pane id "com.apple.preference.security"
            display dialog "This script utilizes the built-in Graphical User Interface Scripting architecture of macOS which is currently disabled." & return & return & "You can enable GUI Scripting by checking  \"Script Editor\", \"Terminal\" and/or \"iTerm\" in System Preferences > Security & Privacy > Privacy > Accessibility." with icon 1 buttons {"Cancel"} default button 1 giving up after 200
        end tell
    end if
    #tell application "Terminal" to activate
EOD

    ExitCode=$?

# If GUI Scripting is not enabled, the AppleScript above exits with a code of 1 and we do not want to continue
    if [[ $ExitCode -eq 1 ]]; then
        echo -ne '\007'
        clear
        echo "ERROR: AppleScript has cancelled this bash script"
        exit 1
    fi


# We've got this far. Let's continue....

# Ask for the administrator password upfront
    sudo -v


# Keep-alive: update existing `sudo` time stamp until `.macos` has finished or `sudo -k`
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
    osascript -e 'tell application "System Preferences" to quit'  > /dev/null 2>&1


# Absolute path to this script, i.e. /home/user/bin
    export ScriptPath=$(dirname "$0")


# Is macOS installed as a guest OS in a VMware VM?
    if [[ $(system_profiler SPHardwareDataType | awk '/Model Identifier/ {print tolower($3)}') == *"vmware"* ]]; then
        VM=true
    fi


# Some settings are dependant on the computer model. ModelName is used to decide which settings are appropriate.
    ModelName=$(system_profiler SPHardwareDataType | awk '/Model Name/ {print tolower($3)}')

    if [ ! -z $VM ]; then   # Guest OS in a VMware VM
        ModelName="imac"
        DesktopPicture="mojave"
    else
        DesktopPicture="mojave"
    fi


# # # # # # # # # # # # # # # # # # # # # # # # # #
# # 1. SYSTEM PREFERENCES > GENERAL
# #

# System Preferences > General > Appearance
    # Light
        defaults delete -g AppleInterfaceStyle 2> /dev/null     # Defaults throws an error if the key does not exist, so write STDERR to /dev/null to surpress error messages

    # Dark
        #defaults write -g AppleInterfaceStyle -string Dark


# System Preferences > General > Accent Colour
    # Graphite
        #defaults write -g AppleAccentColor -int -1

    # Red
        #defaults write -g AppleAccentColor -int 0

    # Orange
        #defaults write -g AppleAccentColor -int 1

    # Yellow
        #defaults write -g AppleAccentColor -int 2

    # Green
        #defaults write -g AppleAccentColor -int 3

    # Purple
    #defaults write -g AppleAccentColor -int 5

    # Pink
        #defaults write -g AppleAccentColor -int 6

    # Blue
        defaults delete -g AppleAccentColor 2> /dev/null     # Defaults throws an error if the key does not exist, so write STDERR to /dev/null to surpress error messages


# System Preferences > General > Highlight colour
    # Purple
        #defaults write -g AppleHighlightColor -string "0.968627 0.831373 1.000000 Purple"
        #defaults write -g AppleAquaColorVariant -int 1

    # Pink
        #defaults write -g AppleHighlightColor -string "1.000000 0.749020 0.823529 Pink"
        #defaults write -g AppleAquaColorVariant -int 1

    # Red
        #defaults write -g AppleHighlightColor -string "1.000000 0.733333 0.721569 Red"
        #defaults write -g AppleAquaColorVariant -int 1

    # Orange
        #defaults write -g AppleHighlightColor -string "1.000000 0.874510 0.701961 Orange"
        #defaults write -g AppleAquaColorVariant -int 1

    # Yellow
        #defaults write -g AppleHighlightColor -string "1.000000 0.937255 0.690196 Yellow"
        #defaults write -g AppleAquaColorVariant -int 1

    # Green
        #defaults write -g AppleHighlightColor -string "0.752941 0.964706 0.678431 Green"
        #defaults write -g AppleAquaColorVariant -int 1

    # Graphite
        #defaults write -g AppleHighlightColor -string "0.847059 0.847059 0.862745 Graphite"
        #defaults write -g AppleAquaColorVariant -int 1      # Set to 6 if Accent Colour is also Graphite or 1 if not

    # Blue
        defaults delete -g AppleHighlightColor 2> /dev/null      # Defaults throws an error if the key does not exist, so write STDERR to /dev/null to surpress error messages
        defaults write -g AppleAquaColorVariant -int 1


# System Preferences > General > Sidebar icon size
    # Small
        defaults write -g NSTableViewDefaultSizeMode -int 1

    # Medium
        #defaults write -g NSTableViewDefaultSizeMode -int 2

    # Large
        #defaults write -g NSTableViewDefaultSizeMode -int 3


# System Preferences > General > Automatically hide and show the menu bar
    # checked
        #defaults write -g _HIHideMenuBar -bool true

    # unchecked
        defaults write -g _HIHideMenuBar -bool false


# System Preferences > General > Show scroll bars:
    # Automatically based on mouse or trackpad
        defaults write -g AppleShowScrollBars -string Automatic

    # When scrolling
        #defaults write -g AppleShowScrollBars -string WhenScrolling

    # Always
        #defaults write -g AppleShowScrollBars -string Always


# System Preferences > General > Click in the scroll bar to
    # Jump to the spot that's clicked
        #defaults write -g AppleScrollerPagingBehavior -bool true

    # Jump to the next page
        defaults write -g AppleScrollerPagingBehavior -bool false


# System Preferences > General > Default web browser
    # GUI Scripting: ./Scripts/Config\ All.scpt <delay-interval>


# System Preferences > General > Ask to keep changes when closing documents
    # checked
        #defaults write -g NSCloseAlwaysConfirmsChanges -bool true

    # unchecked
        defaults write -g NSCloseAlwaysConfirmsChanges -bool false


# System Preferences > General > Close windows when quitting an app
    # unchecked
        #defaults write -g NSQuitAlwaysKeepsWindows -bool true

    # checked
        defaults write -g NSQuitAlwaysKeepsWindows -bool false


# System Preferences > General > Recent items
    # GUI Scripting: ./Scripts/Config\ All.scpt <delay-interval>


# System Preferences > General > Allow Handoff between this Mac and your iCloud devices
# NOTE: -currentHost refers to the domain in the 'ByHost' sub-directory
    # checked 
        defaults -currentHost write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool true
        defaults -currentHost write com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool true

    # unchecked 
        #defaults -currentHost write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool false
        #defaults -currentHost write com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool false


# System Preferences > General > Use font smoothing when available
    # GUI Scripting: ./Scripts/Config\ All.scpt <delay-interval>




# # # # # # # # # # # # # # # # # # # # # # # # # #
# # 2. SYSTEM PREFERENCES > DESKTOP & SCREEN SAVER
# #

# System Preferences > Desktop & Screen Saver > Desktop

    # The Desktop picture is set using 'set-desktop.sh'. See https://github.com/tech-otaku/macos-desktop/blob/main/README.md
    
    pushd $ScriptPath
    
    if [ ! -f set-desktop.sh ]; then
        curl -o "set-desktop.sh" -L https://raw.githubusercontent.com/tech-otaku/macos-desktop/master/set-desktop.sh
        curl -o "options.json" -L https://raw.githubusercontent.com/tech-otaku/macos-desktop/master/options.json
    fi
    
    chmod +x set-desktop.sh
    ./set-desktop.sh $DesktopPicture
    popd


# System Preferences > Desktop & Screen Saver > Screen Saver > Start after
    # Never
        defaults -currentHost write com.apple.screensaver idleTime -int 0

    # 1 Minute
        #defaults -currentHost write com.apple.screensaver idleTime -int 60

    # 2 Minutes
        #defaults -currentHost write com.apple.screensaver idleTime -int 120

    # 5 Minutes
        #defaults -currentHost write com.apple.screensaver idleTime -int 300

    # 10 Minutes
        #defaults -currentHost write com.apple.screensaver idleTime -int 600

    # 20 Minutes
        #defaults -currentHost write com.apple.screensaver idleTime -int 1200

    # 30 Minutes
        #defaults -currentHost write com.apple.screensaver idleTime -int 1800

    # 1 Hour
        #defaults -currentHost write com.apple.screensaver idleTime -int 3600




# # # # # # # # # # # # # # # # # # # # # # # # # #
# # 3. SYSTEM PREFERENCES > DOCK
# #

# System Preferences > Dock > Size
    # 16 [Small] --> [128] Large
        defaults write com.apple.dock tilesize -int 16


# System Preferences > Dock > Magnification
    # checked
        defaults write com.apple.dock magnification -bool true

    # unchecked
        #defaults write com.apple.dock magnification -bool false


# System Preferences > Dock > Magnification
    # 16 [Small] --> 128 [Large]
        defaults write com.apple.dock largesize -int 128


# System Preferences > Dock > Position on screen
    # Left
        defaults write com.apple.dock orientation -string "left"

    # Bottom
        defaults write com.apple.dock orientation -string "bottom"

    # Right
        #defaults write com.apple.dock orientation -string "right"


# System Preferences > Dock > Minimize windows using
    # Genie effect
        defaults write com.apple.dock mineffect -string "genie"

    # Scale effect
        #defaults write com.apple.dock mineffect -string "scale"


# System Preferences > Dock > Prefer tabs when opening documents
    # Always
        #defaults write -g AppleWindowTabbingMode -string "always"

    # In Full Screen Only
        defaults write -g AppleWindowTabbingMode -string "fullscreen"

    # Manually
        #defaults write -g AppleWindowTabbingMode -string "manual"


# System Preferences > Dock > Double click a window's title bar to
    # unchecked
        #defaults write -g AppleActionOnDoubleClick -string "None"

    # minimize
        #defaults write -g AppleActionOnDoubleClick -string "Minimize"

    # zoom
        defaults write -g AppleActionOnDoubleClick -string "Maximize"


# System Preferences > Dock > Minimize windows into application item
    # checked
     #defaults write com.apple.dock minimize-to-application -bool true

    # unchecked
        defaults write com.apple.dock minimize-to-application -bool false


# System Preferences > Dock > Animate opening applications
    # checked
        defaults write com.apple.dock launchanim -bool true

    # unchecked
        #defaults write com.apple.dock launchanim -bool false


# System Preferences > Dock > Autmatically hide and show the Dock
    # checked
        defaults write com.apple.dock autohide -bool true

    # unchecked
        #defaults write com.apple.dock autohide -bool false


# System Preferences > Dock > Show indicators for open applications
    # checked
        defaults write com.apple.dock show-process-indicators -bool true

    # unchecked
        #defaults write com.apple.dock show-process-indicators -bool false


# System Preferences > Dock > Show recent applications in Dock
    # checked
        defaults write com.apple.dock show-recents -bool true

    # unchecked
        #defaults write com.apple.dock show-recents -bool false




# # # # # # # # # # # # # # # # # # # # # # # # # #
# # 10. ENERGY SAVER
# #

if [ "$ModelName" == "imac" ]; then

    # System Preferences > Energy Saver > Turn display off after:
        # 1 min [1] --> 3 hrs [180]
            sudo pmset -c displaysleep 1

        # Never [0]
            #sudo pmset -c displaysleep 0


    # System Preferences > Energy Saver > Prevent computer from sleeping automatically when the display is off
        # checked (Yes. When this option is checked `sleep` = 0)
            sudo pmset -c sleep 0

        # unchecked
            #sudo pmset -c sleep 1


    # System Preferences > Energy Saver > Put hard disks to sleep when possible
        # checked
            #sudo pmset -c disksleep 1

        # unchecked
            sudo pmset -c disksleep 0


    # System Preferences > Energy Saver > Wake for network access
        # checked
            #sudo pmset -c womp 1

        # unchecked
            sudo pmset -c womp 0


    # System Preferences > Energy Saver > Start up automatically after power failure
        # checked
            #sudo pmset -c autorestart 1

        # unchecked
            sudo pmset -c autorestart 0


    # System Preferences > Energy Saver > Enable Power Nap
        # checked
            #sudo pmset -c powernap 1

        # unchecked
            sudo pmset -c powernap 0


elif [ "$ModelName" == "macbook" ]; then

    # Battery Settings [-b]

    # System Preferences > Energy Saver > Battery > Turn display off after:
        # 1 min [1] --> 3 hrs [180]
            sudo pmset -b displaysleep 1

        # Never [0]
            #sudo pmset -b displaysleep 0


    # System Preferences > Energy Saver > Battery > Put hard disks to sleep when possible
        # checked
            #sudo pmset -b disksleep 1

        # unchecked
            sudo pmset -b disksleep 0


    # System Preferences > Energy Saver > Battery > Slightly dim the display while on battery power
        # checked
            sudo pmset -b lessbright 1

        # unchecked
            #sudo pmset -b lessbright 0


    # System Preferences > Energy Saver > Battery > Enable Power Nap while on battery power
        # checked
            #sudo pmset -b powernap 1

        # unchecked
            sudo pmset -b powernap 0


    # Power Adapter Settings [-c]

    # System Preferences > Energy Saver > Power Adapter > Turn display off after:
        # 1 min [1] --> 3 hrs [180]
            sudo pmset -c displaysleep 1

        # Never [0]
            #sudo pmset -c displaysleep 0


    # System Preferences > Energy Saver > Power Adapter > Prevent computer from sleeping automatically when the display is off
        # checked (Yes. When this option is checked `sleep` = 0)
            sudo pmset -c sleep 0

        # unchecked
            #sudo pmset -c sleep 1


    # System Preferences > Energy Saver > Power Adapter > Put hard disks to sleep when possible
        # checked
            #sudo pmset -c disksleep 1

        # unchecked
            sudo pmset -c disksleep 0


    # System Preferences > Energy Saver > Power Adapter > Wake for Wi-Fi network access
        # checked
            #sudo pmset -c womp 1

        # unchecked
            sudo pmset -c womp 0


    # System Preferences > Energy Saver > Power Adapter > Enable Power Nap while plugged into a power adapter
        # checked
            #sudo pmset -c powernap 1

        # unchecked
            sudo pmset -c powernap 0

fi




# # # # # # # # # # # # # # # # # # # # # # # # # #
# # 11. KEYBOARD
# #

# System Preferences > Keyboard > Text > Use smart quotes and dashes
    # checked
        #defaults write -g NSAutomaticDashSubstitutionEnabled -bool true
        #defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool true

    # unchecked
        defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
        defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false




# # # # # # # # # # # # # # # # # # # # # # # # # #
# # 11. MOUSE
# #

# System Preferences > Mouse > Scroll direction: Natural
# System Preferences > Mouse > Point & Click > Scroll direction: Natural (Magic Mouse 2 only)
    # This is the same domain/key used for trackpad configuration

    # checked
        #defaults write -g com.apple.swipescrolldirection -bool true

    # unchecked
        defaults write -g com.apple.swipescrolldirection -bool false




# # # # # # # # # # # # # # # # # # # # # # # # # #
# # 12. TRACKPAD
# #

# System Preferences > Trackpad > Scroll & Zoom > Scroll direction: Natural
    # This is the same domain/key used for mouse configuration

    # checked
        #defaults write -g com.apple.swipescrolldirection -bool true

    # unchecked
        defaults write -g com.apple.swipescrolldirection -bool false




# # # # # # # # # # # # # # # # # # # # # # # # # #
# # 22. SHARING
# #

# System Preferences > Sharing > Computer Name:
    if [ "$ModelName" == "imac" ]; then

        if [ -z $VM ]; then   # NOT a guest OS in a VMware VM

            # Computer Name
                sudo scutil --set ComputerName "Steve’s iMac 27\" 5K"   # 0x5374657665277320694d61632032372220354b in Hex

            # Shell prompt
                sudo scutil --set HostName "Steves-iMac-27-5K"          # 0x5374657665732d694d61632d32372d354b in Hex

            # Bonjour Name
                sudo scutil --set LocalHostName "Steves-iMac-27-5K"     # 0x5374657665732d694d61632d32372d354b in Hex

            # `NetBIOSName` is currently set automatically to `IMAC-1C061E`. Do not overwrite it.
                #sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"
            # 'ServerDescription' is currently set automatically to `Steve's iMac 27" 5K`. Do not overwrite it.
                #sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server ServerDescription -string "0x6D746873"

        fi

    elif [ "$ModelName" == "macbook" ]; then
        # Computer Name
            sudo scutil --set ComputerName "Steve’s MacBook Pro"    # 0x53746576652773204d6163426f6f6b2050726f in Hex

        # Shell prompt
            sudo scutil --set HostName "Steves-MacBook-Pro"         # 0x5374657665732d4d6163426f6f6b2d50726f in Hex

        # Bonjour Name
            sudo scutil --set LocalHostName "Steves-MacBook-Pro"    # 0x5374657665732d4d6163426f6f6b2d50726f in Hex

        # NetBIOSName is currently set automatically to `Steves MBP`.Do not overwrite it.
            #sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"
        # 'ServerDescription' is currently set automatically to `Steve’s MacBook Pro`. Do not overwrite it.
            #sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server ServerDescription -string "0x6D746873"
    fi




# # # # # # # # # # # # # # # # # # # # # # # # # #
# # 27. DATE & TIME
# #

# System Preferences > Date & Time > Time options
    # Analog
        #defaults write com.apple.menuextra.clock IsAnalog -bool true

    # Digital
        defaults write com.apple.menuextra.clock IsAnalog -bool false


# System Preferences > Date & Time > Flash the time separators
    # checked
        #defaults write com.apple.menuextra.clock FlashDateSeparators -bool true

    # unchecked
        defaults write com.apple.menuextra.clock FlashDateSeparators -bool false


# Thu 18 Aug 23:46:18
# System Preferences > Date & Time > Display time with seconds - Checked [:ss]
# System Preferences > Date & Time > Use a 24-hour clock - Checked [HH:mm]
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Checked [EEE]
# System Preferences > Date & Time > Show date - Checked [d MMM]
    # defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm:ss"


# Thu 23:46:18
# System Preferences > Date & Time > Display time with seconds - Checked [:ss]
# System Preferences > Date & Time > Use a 24-hour clock - Checked [HH:mm]
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Checked [EEE]
# System Preferences > Date & Time > Show date - Unchecked
    # defaults write com.apple.menuextra.clock DateFormat -string "EEE HH:mm:ss"


# 18 Aug 23:46:18
# System Preferences > Date & Time > Display time with seconds - Checked [:ss]
# System Preferences > Date & Time > Use a 24-hour clock - Checked [HH:mm]
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Unchecked
# System Preferences > Date & Time > Show date - Checked [d MMM]
    # defaults write com.apple.menuextra.clock DateFormat -string "d MMM HH:mm:ss"


# 23:46:18
# System Preferences > Date & Time > Display time with seconds - Checked [:ss]
# System Preferences > Date & Time > Use a 24-hour clock - Checked [HH:mm]
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Unchecked
# System Preferences > Date & Time > Show date - Unchecked
    # defaults write com.apple.menuextra.clock DateFormat -string "HH:mm:ss"


# Thu 18 Aug 11:46:18 pm
# System Preferences > Date & Time > Display time with seconds - Checked [:ss]
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Checked [a]
# System Preferences > Date & Time > Show the day of the week - Checked [EEE]
# System Preferences > Date & Time > Show date - Checked [d MMM]
    # defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM h:mm:ss a"


# Thu 11:46:18 pm
# System Preferences > Date & Time > Display time with seconds - Checked [:ss]
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Checked [a]
# System Preferences > Date & Time > Show the day of the week - Checked [EEE]
# System Preferences > Date & Time > Show date - Unchecked
    # defaults write com.apple.menuextra.clock DateFormat -string "EEE h:mm:ss a"


# 18 Aug 11:46:18 pm
# System Preferences > Date & Time > Display time with seconds - Checked [:ss]
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Checked [a]
# System Preferences > Date & Time > Show the day of the week - Unchecked
# System Preferences > Date & Time > Show date - Checked [d MMM]
    # defaults write com.apple.menuextra.clock DateFormat -string "d MMM h:mm:ss a"


# 11:46:18 pm
# System Preferences > Date & Time > Display time with seconds - Checked [:ss]
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Checked [a]
# System Preferences > Date & Time > Show the day of the week - Unchecked
# System Preferences > Date & Time > Show date - Unchecked
    # defaults write com.apple.menuextra.clock DateFormat -string "h:mm:ss a"


# Thu 18 Aug 11:46:18
# System Preferences > Date & Time > Display time with seconds - Checked [:ss]
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Checked [EEE]
# System Preferences > Date & Time > Show date - Checked [d MMM]
    # defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM h:mm:ss"


# Thu 11:46:18
# System Preferences > Date & Time > Display time with seconds - Checked [:ss]
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Checked [EEE]
# System Preferences > Date & Time > Show date - Unchecked
    # defaults write com.apple.menuextra.clock DateFormat -string "EEE h:mm:ss"


# 18 Aug 11:46:18
# System Preferences > Date & Time > Display time with seconds - Checked [:ss]
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Unchecked
# System Preferences > Date & Time > Show date - Checked [d MMM]
    # defaults write com.apple.menuextra.clock DateFormat -string "d MMM h:mm:ss"


# 11:46:18
# System Preferences > Date & Time > Display time with seconds - Checked [:ss]
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Unchecked
# System Preferences > Date & Time > Show date - Unchecked
    # defaults write com.apple.menuextra.clock DateFormat -string "h:mm:ss"


# Thu 18 Aug 23:46
# System Preferences > Date & Time > Display time with seconds - Unchecked
# System Preferences > Date & Time > Use a 24-hour clock - Checked [HH:mm]
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Checked [EEE]
# System Preferences > Date & Time > Show date - Checked [d MMM]
    defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm"


# Thu 23:46
# System Preferences > Date & Time > Display time with seconds - Unchecked
# System Preferences > Date & Time > Use a 24-hour clock - Checked [HH:mm]
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Checked [EEE]
# System Preferences > Date & Time > Show date - Unchecked
    # defaults write com.apple.menuextra.clock DateFormat -string "EEE HH:mm"


# 18 Aug 23:46
# System Preferences > Date & Time > Display time with seconds - Unchecked
# System Preferences > Date & Time > Use a 24-hour clock - Checked [HH:mm]
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Unchecked
# System Preferences > Date & Time > Show date - Checked [d MMM]
    # defaults write com.apple.menuextra.clock DateFormat -string "d MMM HH:mm"


# 23:46
# System Preferences > Date & Time > Display time with seconds - Unchecked
# System Preferences > Date & Time > Use a 24-hour clock - Checked [HH:mm]
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Unchecked
# System Preferences > Date & Time > Show date - Unchecked
    # defaults write com.apple.menuextra.clock DateFormat -string "HH:mm"


# Thu 18 Aug 11:46 pm
# System Preferences > Date & Time > Display time with seconds - Unchecked
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Checked [a]
# System Preferences > Date & Time > Show the day of the week - Checked [EEE]
# System Preferences > Date & Time > Show date - Checked [d MMM]
    # defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM h:mm a"


# Thu 11:46 pm
# System Preferences > Date & Time > Display time with seconds - Unchecked
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Checked [a]
# System Preferences > Date & Time > Show the day of the week - Checked [EEE]
# System Preferences > Date & Time > Show date - Unchecked
    # defaults write com.apple.menuextra.clock DateFormat -string "EEE h:mm a"


# 18 Aug 11:46 pm
# System Preferences > Date & Time > Display time with seconds - Unchecked
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Checked [a]
# System Preferences > Date & Time > Show the day of the week - Unchecked
# System Preferences > Date & Time > Show date - Checked [d MMM]
    # defaults write com.apple.menuextra.clock DateFormat -string "d MMM h:mm a"


# 11:46 pm
# System Preferences > Date & Time > Display time with seconds - Unchecked
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Checked [a]
# System Preferences > Date & Time > Show the day of the week - Unchecked
# System Preferences > Date & Time > Show date - Unchecked
    # defaults write com.apple.menuextra.clock DateFormat -string "h:mm a"


# Thu 18 Aug 11:46
# System Preferences > Date & Time > Display time with seconds - Unchecked
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Checked [EEE]
# System Preferences > Date & Time > Show date - Checked [d MMM]
    # defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM h:mm"


# Thu 11:46
# System Preferences > Date & Time > Display time with seconds - Unchecked
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Checked [EEE]
# System Preferences > Date & Time > Show date - Unchecked
    # defaults write com.apple.menuextra.clock DateFormat -string "EEE h:mm"


# 18 Aug 11:46
# System Preferences > Date & Time > Display time with seconds - Unchecked
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Unchecked
# System Preferences > Date & Time > Show date - Checked [d MMM]
    # defaults write com.apple.menuextra.clock DateFormat -string "d MMM h:mm"


# 11:46
# System Preferences > Date & Time > Display time with seconds - Unchecked
# System Preferences > Date & Time > Use a 24-hour clock - Unchecked
# System Preferences > Date & Time > Show AM/PM - Unchecked
# System Preferences > Date & Time > Show the day of the week - Unchecked
# System Preferences > Date & Time > Show date - Unchecked
    # defaults write com.apple.menuextra.clock DateFormat -string "h:mm"




# # # # # # # # # # # # # # # # # # # # # # # # # #
# # FINDER
# #

# Finder > Preferences... > General > Show these items on the desktop: Hard disks
    # checked
        defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true

    # unchecked
        #defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false


# Finder > Preferences... > General > Show these items on the desktop: External disks
    # checked
        defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

    # unchecked
        #defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false


# Finder > Preferences... > General > Show these items on the desktop: CDs, DVDs and iPods
    # checked
        defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

    # unchecked
        #defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false


# Finder > Preferences... > General > Show these items on the desktop: Connected servers
    # checked
        defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

    # unchecked
        #defaults write com.apple.finder ShowMountedServersOnDesktop -bool false


# Finder > Preferences... > General > New Finder windows show:
    # Both `NewWindowTarget` and the correct corresponding `NewWindowTargetPath` have to be set.

    # <computer name>
        #defaults write com.apple.finder NewWindowTarget -string "PfCm"
        #defaults delete com.apple.finder NewWindowTargetPath        # has no corresponding `NewWindowTargetPath`

    # Macintosh HD
        #defaults write com.apple.finder NewWindowTarget -string "Pfvo"
        #defaults write com.apple.finder NewWindowTargetPath -string "file:///"

    # User's home directory
        defaults write com.apple.finder NewWindowTarget -string "PfHm"
        defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

    # Desktop
        #defaults write com.apple.finder NewWindowTarget -string "PfDe"
        #defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

    # Documents
        #defaults write com.apple.finder NewWindowTarget -string "PfDo"
        #defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Documents/"

    # iCloud Drive
        #defaults write com.apple.finder NewWindowTarget -string "PfID"
        #defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Library/Mobile%20Documents/com~apple~CloudDocs/"

    # Recents
        #defaults write com.apple.finder NewWindowTarget -string "PfAF"
        #defaults write com.apple.finder NewWindowTargetPath -string "file:///System/Library/CoreServices/Finder.app/Contents/Resources/MyLibraries/myDocuments.cannedSearch"

    # Other
        #defaults write com.apple.finder NewWindowTarget -string "PfLo"
        #defaults write com.apple.finder NewWindowTargetPath -string "file:///<path>/"


# Finder > Preferences... > General > Open folders in tabs instead of new windows
    # checked
        #defaults write com.apple.finder FinderSpawnTab -bool true

    # unchecked
        defaults write com.apple.finder FinderSpawnTab -bool false


# Finder > Preferences... > Advanced > Show all file name extensions
    # checked
        defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # unchecked
        #defaults write NSGlobalDomain AppleShowAllExtensions -bool false


# Finder > Preferences... > Advanced > Show warning before changing an extension
    # checked
        defaults write com.apple.finder FXEnableExtensionChangeWarning -bool true

    # unchecked
        #defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false


# Finder > Preferences... > Advanced > Show warning before removing iCloud Drive
    # checked
        defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool true

    # unchecked
        #defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false


# Finder > Preferences... > Advanced > Show warning before emptying the Trash
    # checked
        defaults write com.apple.finder WarnOnEmptyTrash -bool true

    # unchecked
        #defaults write com.apple.finder WarnOnEmptyTrash -bool false


# Finder > Preferences... > Advanced > Remove items from the Trash after 30 days
    # checked
        #defaults write com.apple.finder FXRemoveOldTrashItems -bool true

    # unchecked
        defaults write com.apple.finder FXRemoveOldTrashItems -bool false


# Finder > Preferences... > Advanced > Keep folders on top when sorting by name
    # checked
        #defaults write com.apple.finder _FXSortFoldersFirst -bool true

    # unchecked
        defaults write com.apple.finder _FXSortFoldersFirst -bool false


# Finder > Preferences... > Advanced > When performing a search:
    # Search This Mac
        defaults write com.apple.finder FXDefaultSearchScope -string "SCev"

    # Search the Current Folder
        #defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Use the Previous Search Scope
        #defaults write com.apple.finder FXDefaultSearchScope -string "SCsp"


# Finder > View > Show|Hide Tab Bar
    # Show
        defaults write com.apple.finder ShowTabView -bool true
    
    # Hide
        #defaults write com.apple.finder ShowTabView -bool false


# Finder > View > Show|Hide Path Bar
    # Show
        defaults write com.apple.finder ShowPathbar -bool true

    # Hide
        #defaults write com.apple.finder ShowPathbar -bool false


# Finder > View > Show|Hide Status Bar
    # Show
        defaults write com.apple.finder ShowStatusBar -bool true

    # Hide
        #defaults write com.apple.finder ShowStatusBar -bool false


# Finder > View > Show|Hide Sidebar
    # Show
        defaults write com.apple.finder ShowSidebar -bool true

    # Hide
        #defaults write com.apple.finder ShowSidebar -bool false


# Finder > View > Show|Hide Preview
    # Show
        defaults write com.apple.finder ShowPreviewPane -bool true

    # Hide
        #defaults write com.apple.finder ShowPreviewPane -bool false



# # # # # # # # # # # # # # # # # # # # # # # # # #
# # ITUNES
# #

# iTunes > Preferences > Devices > Prevent iPods, iPhones and iPads from syncing automatically
    # yes
        defaults write com.apple.itunes dontAutomaticallySyncIPods -bool true
    
    # no
        #defaults write com.apple.itunes dontAutomaticallySyncIPods -bool false


# # # # # # # # # # # # # # # # # # # # # # # # # #
# # HIDDEN
# #

# Enable highlight hover effect for the grid view of a stack (Dock)
    # yes
        defaults write com.apple.dock mouse-over-hilite-stack -bool true

    # no
        #defaults write com.apple.dock mouse-over-hilite-stack -bool false


# Enable translucent Dock icons for hidden apps
    # yes
        defaults write com.apple.dock showhidden -bool true

    # no
        #defaults write com.apple.dock showhidden -bool false


# Show full POSIX path as Finder window title
    # yes
        defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

    # no
        #defaults write com.apple.finder _FXShowPosixPathInTitle -bool false


# Default view for all Finder windows
    # Icon view
        #defaults write com.apple.finder FXPreferredViewStyle -string "icnv"

    # List view
        #defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Column view
        defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

    # Gallery view
        #defaults write com.apple.finder FXPreferredViewStyle -string "glyv"


# Show the ~/Library folder IMPORTANT: No longer works with High Sierra
    chflags nohidden ~/Library


# Show the /Volumes folder
    sudo chflags nohidden /Volumes


# Show .hidden files
    # Show
        defaults write com.apple.finder AppleShowAllFiles -bool true

    # Hide
        #defaults write com.apple.finder AppleShowAllFiles -bool false


# Reopen windows when logging back in
    # Yes
        #defaults write com.apple.loginwindow TALLogoutSavesState -bool true

    # No
        defaults write com.apple.loginwindow TALLogoutSavesState -bool false


# SCREENSHOTS

    # Save screenshots to /Users/steve/iCloud Drive/Screen Captures. OK if this location doesn't exist yet.
        defaults write com.apple.screencapture location -string "${HOME}/Library/Mobile Documents/com~apple~CloudDocs/Screen Captures"


    # Save screenshots in PNG format
        # BMP
            #defaults write com.apple.screencapture type -string "bmp"

        # GIF
            #defaults write com.apple.screencapture type -string "gif"

        # JPG
            #defaults write com.apple.screencapture type -string "jpg"

        # PDF
            #defaults write com.apple.screencapture type -string "pdf"

        # PNG
            defaults write com.apple.screencapture type -string "png"

        # TIFF
            #defaults write com.apple.screencapture type -string "tiff"


    # Disable shadow in screenshots
        # Disable
            defaults write com.apple.screencapture disable-shadow -bool true

        # Enable
            #defaults write com.apple.screencapture disable-shadow -bool false




# # # # # # # # # # # # # # # # # # # # # # # # # #
# # FINDER ICON VIEW SETTINGS
# #

# Create the `FK_StandardViewSettings` dictionary in `com.apple.finder.plist` if it doesn't exist
    if [[ ! $(/usr/libexec/PlistBuddy -c "Print :FK_StandardViewSettings" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null) ]]; then
        /usr/libexec/PlistBuddy -c "Add :FK_StandardViewSettings dict" ~/Library/Preferences/com.apple.finder.plist
    fi


# Create the `FK_StandardViewSettings:IconViewSettings` dictionary in `com.apple.finder.plist` if it doesn't exist
    if [[ ! $(/usr/libexec/PlistBuddy -c "Print :FK_StandardViewSettings:IconViewSettings" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null) ]]; then
        /usr/libexec/PlistBuddy -c "Add :FK_StandardViewSettings:IconViewSettings dict" ~/Library/Preferences/com.apple.finder.plist
    fi


# Set icon size
    if [ "$ModelName" == "imac" ]; then
        # default 64
        /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist

        # default 64
        /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist

        key=iconSize
        if [[ ! $(/usr/libexec/PlistBuddy -c "Print :FK_StandardViewSettings:IconViewSettings:$key" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null) ]]; then
            action=Add; type=integer
        else
            action=Set; type=
        fi
        /usr/libexec/PlistBuddy -c "$action :FK_StandardViewSettings:IconViewSettings:$key $type 64" ~/Library/Preferences/com.apple.finder.plist

    elif [ "$ModelName" == "macbook" ]; then
        # default 64
        /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 52" ~/Library/Preferences/com.apple.finder.plist

        # default 64
        /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 52" ~/Library/Preferences/com.apple.finder.plist

        key=iconSize
        if [[ ! $(/usr/libexec/PlistBuddy -c "Print :FK_StandardViewSettings:IconViewSettings:$key" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null) ]]; then
            action=Add; type=integer
        else
            action=Set; type=
        fi
        /usr/libexec/PlistBuddy -c "$action :FK_StandardViewSettings:IconViewSettings:$key $type 52" ~/Library/Preferences/com.apple.finder.plist

    fi


# Set grid spacing
    if [ "$ModelName" == "imac" ]; then
        # default 54
        /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 62" ~/Library/Preferences/com.apple.finder.plist
    elif [ "$ModelName" == "macbook" ]; then
        # default 54
        /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 67" ~/Library/Preferences/com.apple.finder.plist
    fi

    # default 54
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist

    key=gridSpacing
    if [[ ! $(/usr/libexec/PlistBuddy -c "Print :FK_StandardViewSettings:IconViewSettings:$key" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null) ]]; then
        action=Add; type=integer
    else
        action=Set; type=
    fi
    /usr/libexec/PlistBuddy -c "$action :FK_StandardViewSettings:IconViewSettings:$key $type 54" ~/Library/Preferences/com.apple.finder.plist


# Set text size
    if [ "$ModelName" == "imac" ]; then
        # default 12
        /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:textSize 12" ~/Library/Preferences/com.apple.finder.plist
    elif [ "$ModelName" == "macbook" ]; then
        # default 12
        /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:textSize 11" ~/Library/Preferences/com.apple.finder.plist
    fi

    # default 12
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:textSize 12" ~/Library/Preferences/com.apple.finder.plist

    key=textSize
    if [[ ! $(/usr/libexec/PlistBuddy -c "Print :FK_StandardViewSettings:IconViewSettings:$key" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null) ]]; then
        action=Add; type=integer
    else
        action=Set; type=
    fi
    /usr/libexec/PlistBuddy -c "$action :FK_StandardViewSettings:IconViewSettings:$key $type 12" ~/Library/Preferences/com.apple.finder.plist


# Set label position
    # default labelOnBottom true
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:labelOnBottom true" ~/Library/Preferences/com.apple.finder.plist

    # default labelOnBottom true
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:labelOnBottom true" ~/Library/Preferences/com.apple.finder.plist

    key=labelOnBottom
    if [[ ! $(/usr/libexec/PlistBuddy -c "Print :FK_StandardViewSettings:IconViewSettings:$key" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null) ]]; then
        action=Add; type=bool
    else
        action=Set; type=
    fi
    /usr/libexec/PlistBuddy -c "$action :FK_StandardViewSettings:IconViewSettings:$key $type true" ~/Library/Preferences/com.apple.finder.plist


# Set item info
    # default false
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist

    # default false
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist

    key=showItemInfo
    if [[ ! $(/usr/libexec/PlistBuddy -c "Print :FK_StandardViewSettings:IconViewSettings:$key" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null) ]]; then
        action=Add; type=bool
    else
        action=Set; type=
    fi
    /usr/libexec/PlistBuddy -c "$action :FK_StandardViewSettings:IconViewSettings:$key $type false" ~/Library/Preferences/com.apple.finder.plist


# Set icon preview
    # default true
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showIconPreview false" ~/Library/Preferences/com.apple.finder.plist

    # default true
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showIconPreview true" ~/Library/Preferences/com.apple.finder.plist

    key=showIconPreview
    if [[ ! $(/usr/libexec/PlistBuddy -c "Print :FK_StandardViewSettings:IconViewSettings:$key" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null) ]]; then
        action=Add; type=bool
    else
        action=Set; type=
    fi
    /usr/libexec/PlistBuddy -c "$action :FK_StandardViewSettings:IconViewSettings:$key $type true" ~/Library/Preferences/com.apple.finder.plist


# Set arrange by
    # default none
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

    # default none
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy none" ~/Library/Preferences/com.apple.finder.plist

    key=arrangeBy
    if [[ ! $(/usr/libexec/PlistBuddy -c "Print :FK_StandardViewSettings:IconViewSettings:$key" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null) ]]; then
        action=Add; type=string
    else
        action=Set; type=
    fi
    /usr/libexec/PlistBuddy -c "$action :FK_StandardViewSettings:IconViewSettings:$key $type none" ~/Library/Preferences/com.apple.finder.plist


# Use Stacks (Doesn't currently work)
    #key=GroupBy
    #if [[ ! $(/usr/libexec/PlistBuddy -c "Print :DesktopViewSettings:$key" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null) ]]; then
    #    action=Add; type=string
    #else
    #    action=Set; type=
    #fi
    #/usr/libexec/PlistBuddy -c "$action :DesktopViewSettings:$key $type kind" ~/Library/Preferences/com.apple.finder.plist

    #/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy dateAdded" ~/Library/Preferences/com.apple.finder.plist

    #key=FXPreferredGroupBy
    #if [[ ! $(/usr/libexec/PlistBuddy -c "Print :$key" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null) ]]; then
    #    action=Add; type=string
    #else
    #    action=Set; type=
    #fi
    #/usr/libexec/PlistBuddy -c "$action :$key $type Kind" ~/Library/Preferences/com.apple.finder.plist




# # # # # # # # # # # # # # # # # # # # # # # # # #
# # MENU BAR EXTRAS
# #

# These menu extras should appear in the menubar. Add them to the current items if they don't yet exist.
    if [ "$ModelName" == "imac" ]; then
        bash "$ScriptPath"/menu-extras-add.sh airport
        bash "$ScriptPath"/menu-extras-add.sh appleuser
        bash "$ScriptPath"/menu-extras-add.sh bluetooth
        bash "$ScriptPath"/menu-extras-add.sh clock
        bash "$ScriptPath"/menu-extras-add.sh scriptmenu
        bash "$ScriptPath"/menu-extras-add.sh textinput
        bash "$ScriptPath"/menu-extras-add.sh TimeMachine
        bash "$ScriptPath"/menu-extras-add.sh volume
        bash "$ScriptPath"/menu-extras-add.sh vpn
    elif [ "$ModelName" == "macbook" ]; then
        bash "$ScriptPath"/menu-extras-add.sh airport
        bash "$ScriptPath"/menu-extras-add.sh appleuser
        bash "$ScriptPath"/menu-extras-add.sh battery
        bash "$ScriptPath"/menu-extras-add.sh bluetooth
        bash "$ScriptPath"/menu-extras-add.sh clock
        bash "$ScriptPath"/menu-extras-add.sh textinput
        bash "$ScriptPath"/menu-extras-add.sh TimeMachine
        bash "$ScriptPath"/menu-extras-add.sh volume
    fi




# # # # # # # # # # # # # # # # # # # # # # # # # #
# # DOCK FOLDERS
# #

# See dock-folders.sh

# Delete `persistent-others` key from com.apple.dock.plist. For fresh installs this should only contain data on the Downloads folder and will be added back to the Dock below exactly the same except `showas` is changed from `1` [Fan] to `2` [Grid]
#    /usr/libexec/PlistBuddy -c "Delete :persistent-others" ~/Library/Preferences/com.apple.dock.plist


# Add Downloads folder [back] to Dock and display in grid view
#    defaults write com.apple.dock persistent-others -array-add '<dict><key>GUID</key><integer>3485233380</integer><key>tile-data</key><dict><key>arrangement</key><integer>2</integer><key>book</key><data>Ym9vazADAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALAIAAAUAAAABAQAAVXNlcnMAAAAFAAAAAQEAAHN0ZXZlAAAACQAAAAEBAABEb3dubG9hZHMAAAAMAAAAAQYAAAQAAAAUAAAAJAAAAAgAAAAEAwAAqxsGAAAAAAAIAAAABAMAAAmPBgAAAAAACAAAAAQDAABCxw0AAAAAAAwAAAABBgAATAAAAFwAAABsAAAACAAAAAAEAABBvMrETAAAABgAAAABAgAAAgAAAAAAAAAPAAAAAAAAAAAAAAAAAAAACAAAAAQDAAABAAAAAAAAAAQAAAADAwAA9QEAAAgAAAABCQAAZmlsZTovLy8MAAAAAQEAAE1hY2ludG9zaCBIRAgAAAAEAwAAAAAcru0AAAAIAAAAAAQAAEG/iMbSAAAAJAAAAAEBAABCOUU2M0Y4MC0yNTUzLTNGMzctOTkzMy00MDJBNUUzMkZGNUQYAAAAAQIAAIEAAAABAAAA7xMAAAEAAAAAAAAAAAAAAAEAAAABAQAALwAAAAAAAAABBQAAoQAAAAECAAAyYjlmYzI4ZWM2NjU1NWVhN2YyNGRmMDQ4ODJkMDJmOGExYThhOWNiOzAwMDAwMDAwOzAwMDAwMDAwOzAwMDAwMDAwMDAwMDAwMjA7Y29tLmFwcGxlLmFwcC1zYW5kYm94LnJlYWQtd3JpdGU7MDE7MDEwMDAwMDg7MDAwMDAwMDAwMDBkYzc0MjsvdXNlcnMvc3RldmUvZG93bmxvYWRzAAAAAMwAAAD+////AQAAAAAAAAAQAAAABBAAADgAAAAAAAAABRAAAHwAAAAAAAAAEBAAAKAAAAAAAAAAQBAAAJAAAAAAAAAAAiAAAGwBAAAAAAAABSAAANwAAAAAAAAAECAAAOwAAAAAAAAAESAAACABAAAAAAAAEiAAAAABAAAAAAAAEyAAABABAAAAAAAAICAAAEwBAAAAAAAAMCAAAHgBAAAAAAAAAcAAAMAAAAAAAAAAEcAAABQAAAAAAAAAEsAAANAAAAAAAAAAgPAAAIABAAAAAAAA</data><key>displayas</key><integer>1</integer><key>file-data</key><dict><key>_CFURLString</key><string>file:///Users/steve/Downloads/</string><key>_CFURLStringType</key><integer>15</integer></dict><key>file-label</key><string>Downloads</string><key>file-mod-date</key><integer>3587709744</integer><key>file-type</key><integer>2</integer><key>parent-mod-date</key><integer>3587709747</integer><key>preferreditemsize</key><integer>-1</integer><key>showas</key><integer>2</integer></dict><key>tile-type</key><string>directory-tile</string></dict>'


# Add Utilities folder to Dock and display in grid view
#    defaults write com.apple.dock persistent-others -array-add '<dict><key>GUID</key><integer>1129841173</integer><key>tile-data</key><dict><key>arrangement</key><integer>1</integer><key>book</key><data>Ym9va9gCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA7AEAAAwAAAABAQAAQXBwbGljYXRpb25zCQAAAAEBAABVdGlsaXRpZXMAAAAIAAAAAQYAAAQAAAAYAAAACAAAAAQDAABNAQAAAAAAAAgAAAAEAwAA0JoAAAAAAAAIAAAAAQYAADwAAABMAAAACAAAAAAEAABBv4NcGwAAABgAAAABAgAAAgAAAAAAAAAPAAAAAAAAAAAAAAAAAAAAAAAAAAEFAAAIAAAAAQkAAGZpbGU6Ly8vDAAAAAEBAABNYWNpbnRvc2ggSEQIAAAABAMAAAAAHK7tAAAACAAAAAAEAABBv4jG0gAAACQAAAABAQAAQjlFNjNGODAtMjU1My0zRjM3LTk5MzMtNDAyQTVFMzJGRjVEGAAAAAECAACBAAAAAQAAAO8TAAABAAAAAAAAAAAAAAABAAAAAQEAAC8AAACiAAAAAQIAADEwZjU2ZThlYzgyZThkMWY1NTE4ZTM3NzZlYmFiMjQzYmUxZjM1ODA7MDAwMDAwMDA7MDAwMDAwMDA7MDAwMDAwMDAwMDAwMDAyMDtjb20uYXBwbGUuYXBwLXNhbmRib3gucmVhZC13cml0ZTswMTswMTAwMDAwODswMDAwMDAwMDAwMDA5YWQwOy9hcHBsaWNhdGlvbnMvdXRpbGl0aWVzAAAAtAAAAP7///8BAAAAAAAAAA4AAAAEEAAALAAAAAAAAAAFEAAAXAAAAAAAAAAQEAAAfAAAAAAAAABAEAAAbAAAAAAAAAACIAAANAEAAAAAAAAFIAAApAAAAAAAAAAQIAAAtAAAAAAAAAARIAAA6AAAAAAAAAASIAAAyAAAAAAAAAATIAAA2AAAAAAAAAAgIAAAFAEAAAAAAAAwIAAAnAAAAAAAAAAB0AAAnAAAAAAAAACA8AAAQAEAAAAAAAA=</data><key>displayas</key><integer>1</integer><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Utilities/</string><key>_CFURLStringType</key><integer>15</integer></dict><key>file-label</key><string>Utilities</string><key>file-mod-date</key><integer>3587710135</integer><key>file-type</key><integer>2</integer><key>parent-mod-date</key><integer>3587714112</integer><key>preferreditemsize</key><integer>-1</integer><key>showas</key><integer>2</integer></dict><key>tile-type</key><string>directory-tile</string></dict>'


# Add Applications folder to Dock and display in grid view
#    defaults write com.apple.dock persistent-others -array-add '<dict><key>GUID</key><integer>1631236773</integer><key>tile-data</key><dict><key>arrangement</key><integer>1</integer><key>book</key><data>Ym9va6ACAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAtAEAAAwAAAABAQAAQXBwbGljYXRpb25zBAAAAAEGAAAEAAAACAAAAAQDAABNAQAAAAAAAAQAAAABBgAAJAAAAAgAAAAABAAAQb+DXDEAAAAYAAAAAQIAAAIAAAAAAAAADwAAAAAAAAAAAAAAAAAAAAAAAAABBQAACAAAAAEJAABmaWxlOi8vLwwAAAABAQAATWFjaW50b3NoIEhECAAAAAQDAAAAAByu7QAAAAgAAAAABAAAQb+IxtIAAAAkAAAAAQEAAEI5RTYzRjgwLTI1NTMtM0YzNy05OTMzLTQwMkE1RTMyRkY1RBgAAAABAgAAgQAAAAEAAADvEwAAAQAAAAAAAAAAAAAAAQAAAAEBAAAvAAAAmAAAAAECAAA1YTA1MjIzYzA5YzEzNTg1ZWI5YTU2Y2QyZGM3NDI1YzVjYzkwN2ExOzAwMDAwMDAwOzAwMDAwMDAwOzAwMDAwMDAwMDAwMDAwMjA7Y29tLmFwcGxlLmFwcC1zYW5kYm94LnJlYWQtd3JpdGU7MDE7MDEwMDAwMDg7MDAwMDAwMDAwMDAwMDE0ZDsvYXBwbGljYXRpb25zALQAAAD+////AQAAAAAAAAAOAAAABBAAABgAAAAAAAAABRAAADQAAAAAAAAAEBAAAFAAAAAAAAAAQBAAAEAAAAAAAAAAAiAAAAgBAAAAAAAABSAAAHgAAAAAAAAAECAAAIgAAAAAAAAAESAAALwAAAAAAAAAEiAAAJwAAAAAAAAAEyAAAKwAAAAAAAAAICAAAOgAAAAAAAAAMCAAAHAAAAAAAAAAAdAAAHAAAAAAAAAAgPAAABQBAAAAAAAA</data><key>displayas</key><integer>1</integer><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/</string><key>_CFURLStringType</key><integer>15</integer></dict><key>file-label</key><string>Applications</string><key>file-mod-date</key><integer>3589443377</integer><key>file-type</key><integer>2</integer><key>parent-mod-date</key><integer>3589376025</integer><key>preferreditemsize</key><integer>-1</integer><key>showas</key><integer>0</integer></dict><key>tile-type</key><string>directory-tile</string></dict>'


# Add Recent Applications to Dock and display in grid view
# Recent Applications = <key>list-type</key><integer>1</integer>
# Icon size = <key>preferreditemsize</key><integer>-1</integer>
# View content as Grid = <key>viewas</key><integer>2</integer>
#    defaults write com.apple.dock persistent-others -array-add '<dict><key>tile-data</key><dict><key>list-type</key><integer>1</integer><key>preferreditemsize</key><integer>-1</integer><key>viewas</key><integer>2</integer></dict><key>tile-type</key><string>recents-tile</string></dict>'


# Add Recent Documents to Dock and display in grid view
# Recent Documents = <key>list-type</key><integer>2</integer>
# Icon size = <key>preferreditemsize</key><integer>-1</integer>
# View content as Grid = <key>viewas</key><integer>2</integer>
#    defaults write com.apple.dock persistent-others -array-add '<dict><key>tile-data</key><dict><key>list-type</key><integer>2</integer><key>preferreditemsize</key><integer>-1</integer><key>viewas</key><integer>2</integer></dict><key>tile-type</key><string>recents-tile</string></dict>'




# Revoke sudo privileges
    sudo -k




# # # # # # # # # # # # # # # # # # # # # # # # # #
# # USER photo
# #

# Change the current user's ($USER) photo

    pushd $ScriptPath

    if [ ! -f set-user-image.sh ]; then
        curl -o set-user-image.sh -L https://raw.githubusercontent.com/tech-otaku/macos-user-image/master/set-user-image.sh
        curl -o Photos/cow.jpg -L https://github.com/tech-otaku/macos-user-image/raw/master/images/cow.jpg
        curl -o Photos/giraffe.jpg -L https://github.com/tech-otaku/macos-user-image/raw/master/images/giraffe.jpg
    fi

    chmod +x set-user-image.sh
    ./set-user-image.sh -u steve -i "$ScriptPath/Photos/steve-colour.jpg"
    popd

    # Source: https://www.jamf.com/jamf-nation/discussions/4332/how-to-change-local-user-account-#picture-through-command-terminal & https://discussions.apple.com/thread/7596877
    #TEMPFILE=$(mktemp)
    #IMAGEFILE="$ScriptPath/Photos/steve-colour.jpg"
    #echo "0x0A 0x5C 0x3A 0x2C dsRecTypeStandard:Users 5 dsAttrTypeStandard:RecordName dsAttrTypeStandard:UniqueID dsAttrTypeStandard:PrimaryGroupID dsAttrTypeStandard:GeneratedUID externalbinary:dsAttrTypeStandard:JPEGPhoto" > ${TEMPFILE}
    #echo ${USER}:${UID}:$(id -g):$(dscl . -read /Users/${USER} GeneratedUID | cut -d' ' -f2):${IMAGEFILE} >> ${TEMPFILE}
    #dscl . -delete /Users/$USER JPEGPhoto
    #dsimport ${TEMPFILE} /Local/Default M -u $USER
    #rm ${TEMPFILE}




# Kill affected applications
    for app in "cfprefsd" \
        "Dock" \
        "Finder" \
        "SystemUIServer"; do
        killall "${app}"  > /dev/null 2>&1
    done
    
    
# Desktop link to iMac Configuration (Evernote)  
#tee ~/Desktop/iMac.Evernote.webloc > /dev/null 2>&1 <<EOF 
#<?xml version="1.0" encoding="UTF-8"?>
#<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/#PropertyList-1.0.dtd">
#<plist version="1.0">
#<dict>
#    <key>URL</key>
#    <string>http://bit.ly/2vvBcpY</string>
#</dict>
#</plist>
#EOF

# Desktop link to MacBook Configuration (Evernote)  
#tee ~/Desktop/MacBook.Evernote.webloc > /dev/null 2>&1 <<EOF 
#<?xml version="1.0" encoding="UTF-8"?>
#<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/#PropertyList-1.0.dtd">
#<plist version="1.0">
#<dict>
#    <key>URL</key>
#    <string>http://bit.ly/2LixneJ</string>
#</dict>
#</plist>
#EOF

# Add Safari Bookmark for iMac Configuration (Evernote)
#/usr/libexec/PlistBuddy /Users/steve/Library/Safari/Bookmarks.plist -c "Add :Children:1:Children:0 dict" > /dev/null 2>&1
#/usr/libexec/PlistBuddy /Users/steve/Library/Safari/Bookmarks.plist -c "Add :Children:1:Children:0:URIDictionary dict"
#/usr/libexec/PlistBuddy /Users/steve/Library/Safari/Bookmarks.plist -c "Add :Children:1:Children:0:URIDictionary:title string iMac Evernote"
#/usr/libexec/PlistBuddy /Users/steve/Library/Safari/Bookmarks.plist -c "Add :Children:1:Children:0:URLString string http://bit.ly/2vvBcpY"
#/usr/libexec/PlistBuddy /Users/steve/Library/Safari/Bookmarks.plist -c "Add :Children:1:Children:0:WebBookmarkType string WebBookmarkTypeLeaf"

# Add Safari Bookmark for MacBook Configuration (Evernote)
#/usr/libexec/PlistBuddy /Users/steve/Library/Safari/Bookmarks.plist -c "Add :Children:1:Children:0 dict"
#/usr/libexec/PlistBuddy /Users/steve/Library/Safari/Bookmarks.plist -c "Add :Children:1:Children:0:URIDictionary dict"
#/usr/libexec/PlistBuddy /Users/steve/Library/Safari/Bookmarks.plist -c "Add :Children:1:Children:0:URIDictionary:title string MacBook Evernote"
#/usr/libexec/PlistBuddy /Users/steve/Library/Safari/Bookmarks.plist -c "Add :Children:1:Children:0:URLString string http://bit.ly/2LixneJ"
#/usr/libexec/PlistBuddy /Users/steve/Library/Safari/Bookmarks.plist -c "Add :Children:1:Children:0:WebBookmarkType string WebBookmarkTypeLeaf"

# Execute the AppleScript configuration script
#    osascript "$ScriptPath"/Scripts/Config\ All.scpt > /dev/null 2>&1


# Some settings are only effective after the machine is restarted, so restart. Displays normal macOS restart dialog.
#osascript > /dev/null 2>&1 <<EOD
#tell application "System Events"
#    tell process "Finder"
#        tell menu bar 1
#            click menu "Apple"
#            tell menu "Apple" to click menu item "Restart…"
#        end tell
#    end tell
#end tell
#EOD
