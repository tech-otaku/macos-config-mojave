#!/usr/bin/env bash

# USAGE: ./dock-folders.sh  tech-otaku.com "Desktop Apps" "Desktop Filing" Downloads Utilities Applications

    # arrangement               ARRANGEMENT                 [1=Name, 2=Date Added, 3=Date Modified, 4=Date Created, 5=Kind]
    # directory                 DIRECTORY                   [??]
    # displayas                 DISPLAYAS                   [0=Stack, 1=Folder]
    # _CFURLStringType          CFURLSTRINGTYPE             [0 if _CFURLString begins with '/', 15 if _CFURLString begins with file:// or http[s]://]
    # file-type                 FILETYPE                    [1 if recent-apps, 2 if persistent-others, 41 if persistent-apps]    
    # preferreditemsize         PREFERREDITEMSIZE           [-1=default size, 0=small, 3=same as default size]
    # showas                    SHOWAS                      [1=Fan, 2=List, 3=Grid, 0=Automatic]
    # tile-type                 TILETYPE                    [directory-tile, file-tile, url-tile, spacer-tile, small-spacer-tile, flex-spacer-tile]


#if [[ " $@ " =~ " Desktop Filing " ]]; then
#    echo "Applications"
#fi


# Delete `persistent-others` key from com.apple.dock.plist. For fresh installs this should only contain data on the Downloads folder and will be added back to the Dock below exactly the same except `showas` is changed from `1` [Fan] to `2` [Grid]
    /usr/libexec/PlistBuddy -c "Delete :persistent-others" ~/Library/Preferences/com.apple.dock.plist > /dev/null 2>&1

    for folder in "$@"; do
        case "$folder" in 
            tech-otaku.com)
                GUID=$(/usr/bin/uuidgen)
                CFURLSTRING="https://www.tech-otaku.com/wp-admin/admin.php?page=stats"
                CFURLSTRINGTYPE=15
                LABEL="tech-otaku.com"
                TILETYPE="url-tile"
                defaults write com.apple.dock persistent-others -array-add '<dict><key>GUID</key><string>'$GUID'</string><key>tile-data</key><dict><key>label</key><string>'$LABEL'</string><key>url</key><dict><key>_CFURLString</key><string>'"$CFURLSTRING"'</string><key>_CFURLStringType</key><integer>'$CFURLSTRINGTYPE'</integer></dict></dict><key>tile-type</key><string>'$TILETYPE'</string></dict>'
            ;;
            Applications)
                GUID=$(/usr/bin/uuidgen)
                ARRANGEMENT=1
                DIRECTORY=1
                DISPLAYAS=1
                CFURLSTRING="file:///Applications/"
                CFURLSTRINGTYPE=15
                FILELABEL="Applications"
                FILETYPE=2
                PREFERREDITEMSIZE=-1
                SHOWAS=2
                TILETYPE="directory-tile"
                defaults write com.apple.dock persistent-others -array-add '<dict><key>GUID</key><string>'$GUID'</string><key>tile-data</key><dict><key>arrangement</key><integer>'$ARRANGEMENT'</integer><key>directory</key><integer>'$DIRECTORY'</integer><key>displayas</key><integer>'$DISPLAYAS'</integer><key>file-data</key><dict><key>_CFURLString</key><string>'"$CFURLSTRING"'</string><key>_CFURLStringType</key><integer>'$CFURLSTRINGTYPE'</integer></dict><key>file-label</key><string>'"$FILELABEL"'</string><key>file-type</key><integer>'$FILETYPE'</integer><key>preferreditemsize</key><integer>'$PREFERREDITEMSIZE'</integer><key>showas</key><integer>'$SHOWAS'</integer></dict><key>tile-type</key><string>'$TILETYPE'</string></dict>'
            ;;
            "Desktop Apps")
                GUID=$(/usr/bin/uuidgen)
                ARRANGEMENT=1
                DIRECTORY=1
                DISPLAYAS=1
                CFURLSTRING="file:///Users/steve/Desktop Apps"
                CFURLSTRINGTYPE=15
                FILELABEL="Desktop Apps"
                FILETYPE=2
                PREFERREDITEMSIZE=-1
                SHOWAS=2
                TILETYPE="directory-tile"
                defaults write com.apple.dock persistent-others -array-add '<dict><key>GUID</key><string>'$GUID'</string><key>tile-data</key><dict><key>arrangement</key><integer>'$ARRANGEMENT'</integer><key>directory</key><integer>'$DIRECTORY'</integer><key>displayas</key><integer>'$DISPLAYAS'</integer><key>file-data</key><dict><key>_CFURLString</key><string>'"$CFURLSTRING"'</string><key>_CFURLStringType</key><integer>'$CFURLSTRINGTYPE'</integer></dict><key>file-label</key><string>'"$FILELABEL"'</string><key>file-type</key><integer>'$FILETYPE'</integer><key>preferreditemsize</key><integer>'$PREFERREDITEMSIZE'</integer><key>showas</key><integer>'$SHOWAS'</integer></dict><key>tile-type</key><string>'$TILETYPE'</string></dict>'
            ;;
            "Desktop Filing")
                GUID=$(/usr/bin/uuidgen)
                ARRANGEMENT=1
                DIRECTORY=1
                DISPLAYAS=1
                CFURLSTRING="file:///Users/steve/Desktop Filing"
                CFURLSTRINGTYPE=15
                FILELABEL="Desktop Filing"
                FILETYPE=2
                PREFERREDITEMSIZE=-1
                SHOWAS=2
                TILETYPE="directory-tile"
                defaults write com.apple.dock persistent-others -array-add '<dict><key>GUID</key><string>'$GUID'</string><key>tile-data</key><dict><key>arrangement</key><integer>'$ARRANGEMENT'</integer><key>directory</key><integer>'$DIRECTORY'</integer><key>displayas</key><integer>'$DISPLAYAS'</integer><key>file-data</key><dict><key>_CFURLString</key><string>'"$CFURLSTRING"'</string><key>_CFURLStringType</key><integer>'$CFURLSTRINGTYPE'</integer></dict><key>file-label</key><string>'"$FILELABEL"'</string><key>file-type</key><integer>'$FILETYPE'</integer><key>preferreditemsize</key><integer>'$PREFERREDITEMSIZE'</integer><key>showas</key><integer>'$SHOWAS'</integer></dict><key>tile-type</key><string>'$TILETYPE'</string></dict>'
            ;;
            Downloads)
                GUID=$(/usr/bin/uuidgen)
                ARRANGEMENT=1
                DIRECTORY=1
                DISPLAYAS=1
                CFURLSTRING="file://$HOME/Downloads/"
                CFURLSTRINGTYPE=15
                FILELABEL="Downloads"
                FILETYPE=2
                PREFERREDITEMSIZE=-1
                SHOWAS=2
                TILETYPE="directory-tile"
                defaults write com.apple.dock persistent-others -array-add '<dict><key>GUID</key><string>'$GUID'</string><key>tile-data</key><dict><key>arrangement</key><integer>'$ARRANGEMENT'</integer><key>directory</key><integer>'$DIRECTORY'</integer><key>displayas</key><integer>'$DISPLAYAS'</integer><key>file-data</key><dict><key>_CFURLString</key><string>'"$CFURLSTRING"'</string><key>_CFURLStringType</key><integer>'$CFURLSTRINGTYPE'</integer></dict><key>file-label</key><string>'"$FILELABEL"'</string><key>file-type</key><integer>'$FILETYPE'</integer><key>preferreditemsize</key><integer>'$PREFERREDITEMSIZE'</integer><key>showas</key><integer>'$SHOWAS'</integer></dict><key>tile-type</key><string>'$TILETYPE'</string></dict>'
            ;;
            Utilities)
                GUID=$(/usr/bin/uuidgen)
                ARRANGEMENT=1
                DIRECTORY=1
                DISPLAYAS=1
                CFURLSTRING="file:///Applications/Utilities/"
                CFURLSTRINGTYPE=15
                FILELABEL="Utilities"
                FILETYPE=2
                PREFERREDITEMSIZE=-1
                SHOWAS=2
                TILETYPE="directory-tile"
                defaults write com.apple.dock persistent-others -array-add '<dict><key>GUID</key><string>'$GUID'</string><key>tile-data</key><dict><key>arrangement</key><integer>'$ARRANGEMENT'</integer><key>directory</key><integer>'$DIRECTORY'</integer><key>displayas</key><integer>'$DISPLAYAS'</integer><key>file-data</key><dict><key>_CFURLString</key><string>'"$CFURLSTRING"'</string><key>_CFURLStringType</key><integer>'$CFURLSTRINGTYPE'</integer></dict><key>file-label</key><string>'"$FILELABEL"'</string><key>file-type</key><integer>'$FILETYPE'</integer><key>preferreditemsize</key><integer>'$PREFERREDITEMSIZE'</integer><key>showas</key><integer>'$SHOWAS'</integer></dict><key>tile-type</key><string>'$TILETYPE'</string></dict>'
                ;;
        esac

    done


# NOTE: Recent Folders no longer appear to work since Catalina

# Add Recent Applications to Dock and display in grid view
# Recent Applications = <key>list-type</key><integer>1</integer>
# Icon size = <key>preferreditemsize</key><integer>-1</integer>
# View content as Grid = <key>viewas</key><integer>2</integer>
    #defaults write com.apple.dock persistent-others -array-add '<dict><key>tile-data</key><dict><key>list-type</key><integer>1</integer><key>preferreditemsize</key><integer>-1</integer><key>viewas</key><integer>2</integer></dict><key>tile-type</key><string>recents-tile</string></dict>'


# Add Recent Documents to Dock and display in grid view
# Recent Documents = <key>list-type</key><integer>2</integer>
# Icon size = <key>preferreditemsize</key><integer>-1</integer>
# View content as Grid = <key>viewas</key><integer>2</integer>
    #defaults write com.apple.dock persistent-others -array-add '<dict><key>tile-data</key><dict><key>list-type</key><integer>2</integer><key>preferreditemsize</key><integer>-1</integer><key>viewas</key><integer>2</integer></dict><key>tile-type</key><string>recents-tile</string></dict>'
    
    killall Dock
    
echo "Configured Dock Folders"