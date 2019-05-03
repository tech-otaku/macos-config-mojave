#!/bin/bash
# Steve Ward: 2018-03-31

# USAGE: . /Users/steve/Dropbox/Scripts/macOS\ Configuration/test.sh [APP]
# The `. + space` before the script name is important as it runs the script in the current shell making script variables persistent. Source: https://unix.stackexchange.com/questions/30189/how-can-i-make-environment-variables-exported-in-a-shell-script-stick-around

main () {	# See https://stackoverflow.com/questions/13588457/forward-function-declarations-in-a-bash-or-a-shell-script for explanation of main()

	if [ -z "$1" ]; then
		clear
		echo 'ERROR: No application was specified.'
		return	# As this script is executed in the current shell, do not use `exit` as this will close the current shell. Source: https://stackoverflow.com/questions/9640660/any-way-to-exit-bash-script-but-not-quitting-the-terminal
	fi

	# Ask for the administrator password upfront
	sudo -v

	APP=$1

	clear

	# get source path e.g. `/Users/steve/TM\ Restore\ 2018-04-01` or `/Users/steve/TM\ Restore\ 2018-04-01/steve`
	if [ -z "$SOURCE" ]; then
		read -p "Enter source folder: " SOURCE
	else
		read -p "The current source folder is '$SOURCE'. Do you want to change this (Y/n)? " CHANGE
		if [[ $CHANGE =~ [A-Z] && $CHANGE == "Y" ]]; then
			read -p "Enter source folder?: " SOURCE
		fi
	fi

	if [ ! -d "$SOURCE" ]; then
		echo "ERROR: The directory '$SOURCE' does not exist"
		unset SOURCE
		return
	fi

	if [ "${SOURCE: -1}" == "/" ]; then
		SOURCE=`echo ${SOURCE%/*}`	# Remove trailing `/` from source path
	fi

	LOG=-macos-setup-`scutil --get HostName | awk '{print tolower($1)}'`.log
	
	#if [ $APP != "pictures" && $APP != "mail" ]; then

	d="$SOURCE"/Library
	echo "Checking the folder $d exists"
	if [ -d "$d" ]; then
		echo "$d ---> OK."
		else
		echo "ERROR: $d not found. Please re-run this script entering the correct source path."
		return
	fi

	SRC="$SOURCE"/Dropbox
	TRG=/Users/steve/Dropbox
	echo "Checking the folder $TRG exists"
	if [ -d "$TRG" ]; then
		echo "$TRG ---> OK."
	else
		if [ -d "$SRC" ]; then
			read -p "ERROR: $TRG not found. Do you want to move $SRC to /Users/steve (Y/n)? " COPY
			if [[ $COPY =~ [A-Z] && $COPY == "Y" ]]; then
				move_directory_entry "D" "$SRC" "$TRG"
			else
				echo "ERROR: $TRG is required. Exiting..."
				return
			fi
		else
			echo "ERROR: Neither $SRC nor $TRG exist. Exiting..."
			return
		fi
	fi

	unset SRC
	unset TRG


	SRC="$SOURCE"/Sundry
	TRG=/Users/steve/Sundry
	echo "Checking the folder $TRG exists"
	if [ -d "$TRG" ]; then
		echo "$TRG ---> OK."
	else
		if [ -d "$SRC" ]; then
			read -p "ERROR: $TRG not found. Do you want to move $SRC to /Users/steve (Y/n)? " COPY
			if [[ $COPY =~ [A-Z] && $COPY == "Y" ]]; then
				move_directory_entry "D" "$SRC" "$TRG"
			else
				echo "ERROR: $TRG is required. Exiting..."
				return
			fi
		else
			echo "ERROR: Neither $SRC nor $TRG exist. Exiting..."
			return
		fi
	fi

	unset SRC
	unset TRG
	
	#fi

	#echo "$SOURCE"

	shopt -s dotglob	# Ensure .hidden files are included

	VALID=true		# Later set to `false` if $APP is not a valid name

	case $APP in
		# * * * * USER FOLDERS * * * *
		desktop)		# ~/Desktop
			#populate "Desktop"	# FOR TESTING PURPOSES ONLY!
			read -p "WARNING: The Desktop folder is now synced with iCloud and will not be restored from $SOURCE/. Press enter to continue."
			#move_directory_entry "D" "$SOURCE/Desktop" "/Users/steve/Desktop"
			;;
		documents)		# ~/Documents
			#populate "Documents"	# FOR TESTING PURPOSES ONLY!
			read -p "WARNING: The Documents folder is now synced with iCloud and will not be restored from $SOURCE/. Press enter to continue."
			#move_directory_entry "D" "$SOURCE/Documents" "/Users/steve/Documents"
			;;
		downloads)		# ~/Downloads
			#populate "Downloads"	# FOR TESTING PURPOSES ONLY!
			move_directory_entry "D" "$SOURCE/Downloads" "/Users/steve/Downloads"
			;;
		movies)			# ~/Movies
			#populate "Movies"	# FOR TESTING PURPOSES ONLY!
			move_directory_entry "D" "$SOURCE/Movies" "/Users/steve/Movies"
			;;
		music)			# ~/Music
			#populate "Music"	# FOR TESTING PURPOSES ONLY!
			move_directory_entry "D" "$SOURCE/Music" "/Users/steve/Music"
			;;
		pictures)		# ~/Pictures
			#populate "Pictures"	# FOR TESTING PURPOSES ONLY!
			move_directory_entry "D" "$SOURCE/Pictures" "/Users/steve/Pictures"
			;;
		public)			# ~/Public/Drop Box
			#populate "Public"	# FOR TESTING PURPOSES ONLY!
			move_directory_entry "D" "$SOURCE/Public" "/Users/steve/Public"
			#sudo rm -rf "$SOURCE/Public"
			#if [ $? == 0 ]; then echo `date '+%Y-%m-%d %H:%M:%S'` "[D103:$APP] Deleted source folder \"$SOURCE/Public\"" >> ~/$LOG; fi
			;;
		# * * * * APPLICATIONS * * * *
		finderatt)		# A Better Finder Attributes 6.app
			move_directory_entry "F" "$SOURCE/Library/Preferences/net.publicspace.abfa6.plist" "/Users/steve/Library/Preferences/net.publicspace.abfa6.plist"
			;;
		finderren) 		# A Better Finder Rename 10.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/A Better Finder Rename 10" "/Users/steve/Library/Application Support/A Better Finder Rename 10"
			move_directory_entry "F" "$SOURCE/Library/Preferences/net.publicspace.abfr10.plist" "/Users/steve/Library/Preferences/net.publicspace.abfr10.plist"
			;;
		adobe)			# Adobe Acrobat Reader DC.app
			move_directory_entry "D" "$SOURCE/Library/Preferences/Adobe" "/Users/steve/Library/Preferences/Adobe"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.adobe.AdobeRdrCEFHelper.plist" "/Users/steve/Library/Preferences/com.adobe.AdobeRdrCEFHelper.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.adobe.crashreporter.plist" "/Users/steve/Library/Preferences/com.adobe.crashreporter.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.adobe.Reader.plist" "/Users/steve/Library/Preferences/com.adobe.Reader.plist"
			# /Library/Preferences/com.adobe.reader.DC.WebResource.plist
			;;
		airmail)		# Airmail 3.app
			move_directory_entry "D" "$SOURCE/Library/Containers/it.bloop.airmail2" "/Users/steve/Library/Containers/it.bloop.airmail2"
			move_directory_entry "D" "$SOURCE/Library/Group Containers/2E337YPCZY.airmail" "/Users/steve/Library/Group Containers/2E337YPCZY.airmail"
			move_directory_entry "F" "$SOURCE/Library/Preferences/it.bloop.airmail2.plist" "/Users/steve/Library/Preferences/it.bloop.airmail2.plist"
			;;
		alfred)			# Alfred 3.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/Alfred 3" "/Users/steve/Library/Application Support/Alfred 3"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.runningwithcrayons.Alfred-3.plist" "/Users/steve/Library/Preferences/com.runningwithcrayons.Alfred-3.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.runningwithcrayons.Alfred-Preferences-3.plist" "/Users/steve/Library/Preferences/com.runningwithcrayons.Alfred-Preferences-3.plist"
			#F="$SOURCE"/steve/Library/Caches/com.runningwithcrayons.Alfred-3; if [ -f "$F" ];then mv "$F" /Users/steve/Library/Caches/;fi
			;;
		appshelf)		# AppShelf.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/AppShelf" "/Users/steve/Library/Application Support/AppShelf"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.kedisoft.AppShelf.plist" "/Users/steve/Library/Preferences/com.kedisoft.AppShelf.plist"
			;;
		appstore)
			;;
		appzapper)		# AppZapper.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/AppZapper" "/Users/steve/Library/Application Support/AppZapper"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.appzapper.appzapper2.plist" "/Users/steve/Library/Preferences/com.appzapper.appzapper2.plist"
			#move_directory_entry "F" "$SOURCE/Library/Caches/com.appzapper.appzapper2" "/Users/steve/Library/Caches/com.appzapper.appzapper2"
			;;
		atom)			# Atom.app
			move_directory_entry "D" "$SOURCE/.atom" "/Users/steve/.atom"
			move_directory_entry "D" "$SOURCE/Library/Application Support/Atom" "/Users/steve/Library/Application Support/Atom"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.github.atom.helper.plist" "/Users/steve/Library/Preferences/com.github.atom.helper.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.github.atom.plist" "/Users/steve/Library/Preferences/com.github.atom.plist"
			#move_directory_entry "D" "$SOURCE/Library/Caches/com.github.atom" "/Users/steve/Library/Caches/com.github.atom"
			#move_directory_entry "D" "$SOURCE/Library/Caches/com.github.atom.ShipIt" "/Users/steve/Library/Caches/com.github.atom.ShipIt"
			;;
		atomic) 		# ATOMIC.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/ATOMIC" "/Users/steve/Library/Application Support/ATOMIC"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.micromat.ATOMIC.plist" "/Users/steve/Library/Preferences/com.micromat.ATOMIC.plist"
			# move_directory_entry "D" "$SOURCE/Library/Caches/com.micromat.ATOMIC" "/Users/steve/Library/Caches/com.micromat.ATOMIC"
			;;
		backuploupe)	# BackupLoupe.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/BackupLoupe" "/Users/steve/Library/Application Support/BackupLoupe"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.soma-zone.BackupLoupe.plist" "/Users/steve/Library/Preferences/com.soma-zone.BackupLoupe.plist"
			# move_directory_entry "D" "$SOURCE/Library/Caches/com.soma-zone.BackupLoupe" "/Users/steve/Library/Caches/com.soma-zone.BackupLoupe"
			;;
		bbedit)			# BBEdit.app
			#create_symbolic_link "/Users/steve/Dropbox/BBEdit" "/Users/steve/Library/Application Support/BBEdit"
			move_directory_entry "D" "$SOURCE/Library/BBEdit" "/Users/steve/Library/BBEdit"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.barebones.bbedit.plist" "/Users/steve/Library/Preferences/com.barebones.bbedit.plist"
			move_directory_entry "D" "$SOURCE/Library/Preferences/com.barebones.bbedit.PreferenceData" "/Users/steve/Library/Preferences/com.barebones.bbedit.PreferenceData"
			# move_directory_entry "D" "$SOURCE/Library/Caches/com.barebones.bbedit" "/Users/steve/Library/Caches/com.barebones.bbedit"
			;;
		boxsync) 		# Box Sync.app
			# * * * * DO NOT USE - SIMPLY INSTALL BOX SYNC * * * *
			# move_directory_entry "F" "$SOURCE/Library/Preferences/com.box.sync.plist" "/Users/steve/Library/Preferences/com.box.sync.plist"
			# move_directory_entry "D" "$SOURCE/Library/Caches/com.box.sync" "/Users/steve/Library/Caches/com.box.sync"
			;;
		chronosync)		# ChronoSync.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/ChronoSync" "/Users/steve/Library/Application Support/ChronoSync" # Includes the important `Tasks` folder where sync documents are stored
			#move_directory_entry "D" "$SOURCE/Library/Logs/ChronoSync" "/Users/steve/Library/Logs/ChronoSync"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.econtechnologies.backgrounder.chronosync.plist" "/Users/steve/Library/Preferences/com.econtechnologies.backgrounder.chronosync.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.econtechnologies.backgrounder.chronosync.plist.gKpRjPo" "/Users/steve/Library/Preferences/com.econtechnologies.backgrounder.chronosync.plist.gKpRjPo"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.econtechnologies.backgrounder.chronosync.plist.P32AQSx" "/Users/steve/Library/Preferences/com.econtechnologies.backgrounder.chronosync.plist.P32AQSx"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.econtechnologies.backgrounder.chronosync.plist.ypn8gpL" "/Users/steve/Library/Preferences/com.econtechnologies.backgrounder.chronosync.plist.ypn8gpL"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.econtechnologies.chronosync.plist" "/Users/steve/Library/Preferences/com.econtechnologies.chronosync.plist"
			;;
		crashplan)		# CrashPlan.app
			# move_directory_entry "D" "$SOURCE/Library/Application Support/CrashPlan" "/Users/steve/Library/Application Support/CrashPlan"
			# /Library/Application Support/CrashPlan
			# move_directory_entry "F" "$SOURCE/Library/Preferences/com.backup42.desktop.plist" "/Users/steve/Library/Preferences/com.backup42.desktop.plist"
			# /Library/Caches/CrashPlan
			# move_directory_entry "D" "$SOURCE/Library/Logs/CrashPlan" "/Users/steve/Library/Logs/CrashPlan"
			;;
		dropbox)		# Dropbox.app
			# * * * * DO NOT USE - SIMPLY INSTALL DROPBOX * * * *
			# move_directory_entry "D" "$SOURCE/Library/Application Support/Dropbox" "/Users/steve/Library/Application Support/Dropbox"
			# move_directory_entry "D" "$SOURCE/Library/Containers/com.getdropbox.dropbox.garcon" "/Users/steve/Library/Containers/com.getdropbox.dropbox.garcon"
			# move_directory_entry "D" "$SOURCE/Library/Dropbox" "/Users/steve/Library/Dropbox"			# Contains DropboxMacUpdate.app and created during installation?
			# move_directory_entry "D" "$SOURCE/Library/Group Containers/com.getdropbox.dropbox.garcon" "/Users/steve/Library/Group Containers/com.getdropbox.dropbox.garcon"
			# move_directory_entry "F" "$SOURCE/Library/Preferences/com.dropbox.DropboxMacUpdate.plist" "/Users/steve/Library/Preferences/com.dropbox.DropboxMacUpdate.plist"
			# move_directory_entry "F" "$SOURCE/Library/Preferences/com.dropbox.DropboxMonitor.plist" "/Users/steve/Library/Preferences/com.dropbox.DropboxMonitor.plist"
			# move_directory_entry "F" "$SOURCE/Library/Preferences/com.dropbox.tungsten.helper.plist" "/Users/steve/Library/Preferences/com.dropbox.tungsten.helper.plist"
			# move_directory_entry "F" "$SOURCE/Library/Preferences/com.getdropbox.dropbox.plist" "/Users/steve/Library/Preferences/com.getdropbox.dropbox.plist"
			;;
		evernote)		# Evernote.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/com.evernote.Evernote" "/Users/steve/Library/Application Support/com.evernote.Evernote"
			move_directory_entry "D" "$SOURCE/Library/Application Support/com.evernote.EvernoteHelper" "/Users/steve/Library/Application Support/com.evernote.EvernoteHelper"
			move_directory_entry "D" "$SOURCE/Library/Containers/com.evernote.Evernote" "/Users/steve/Library/Containers/com.evernote.Evernote"
			move_directory_entry "D" "$SOURCE/Library/Containers/com.evernote.EvernoteHelper" "/Users/steve/Library/Containers/com.evernote.EvernoteHelper"
			move_directory_entry "D" "$SOURCE/Library/Group Containers/Q79WDW8YH9.com.evernote.Evernote" "/Users/steve/Library/Group Containers/Q79WDW8YH9.com.evernote.Evernote"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.evernote.Evernote.plist" "/Users/steve/Library/Preferences/com.evernote.Evernote.plist"
			;;
		firefox)		# Firefox.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/Firefox" "/Users/steve/Library/Application Support/Firefox"
			move_directory_entry "D" "$SOURCE/Library/Mozilla" "/Users/steve/Library/Mozilla"
			move_directory_entry "F" "$SOURCE/Library/Preferences/org.mozilla.firefox.plist" "/Users/steve/Library/Preferences/org.mozilla.firefox.plist"
			;;
		forklift)		# ForkLift.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/ForkLift" "/Users/steve/Library/Application Support/ForkLift"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.binarynights.ForkLift-3.plist" "/Users/steve/Library/Preferences/com.binarynights.ForkLift-3.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.binarynights.ForkLiftMini.plist" "/Users/steve/Library/Preferences/com.binarynights.ForkLiftMini.plist"
			#move_directory_entry "D" "$SOURCE/Library/Caches/com.binarynights.ForkLift-3" "/Users/steve/Library/Caches/com.binarynights.ForkLift-3"
			#move_directory_entry "D" "$SOURCE/Dropbox/Apps/ForkLift" "/Users/steve/Dropbox/Apps/ForkLift																# Contains Favorites.json"
			#move_directory_entry "D" "$SOURCE/Dropbox/ForkLift" "/Users/steve/Dropbox/ForkLift																		# Not sure this is still used"
			;;
		geekbench)		# Geekbench 4.app
			# NONE
			;;
		github)			# GitHub Desktop.app
			move_directory_entry "F" "$SOURCE/.gitconfig" "/Users/steve/.gitconfig"
			move_directory_entry "D" "$SOURCE/Library/Application Support/GitHub Desktop" "/Users/steve/Library/Application Support/GitHub Desktop"
			move_directory_entry "D" "$SOURCE/Developer" "/Users/steve/Developer"
			;;
		gns3)			# GNS3.app
			#move_directory_entry "D" "$SOURCE/Sundry/GNS3" "/Users/steve/Sundry/GNS3"
			move_directory_entry "F" "$SOURCE/Library/Preferences/net.gns3.plist" "/Users/steve/Library/Preferences/net.gns3.plist"
			;;
		chrome)			# Google Chrome.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/Google" "/Users/steve/Library/Application Support/Google"
			move_directory_entry "D" "$SOURCE/Library/Google" "/Users/steve/Library/Google"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.google.Chrome.plist" "/Users/steve/Library/Preferences/com.google.Chrome.plist"
			;;
		hewlett)		# Hewlett-Packard
			;;
		hex)			# Hex Fiend.app
			;;
		hp)				# HP
			;;
		hpscan)			# HP Easy Scan.app
			;;
		hpstart)		# HP Easy Start.app
			;;
		ibooks)			# iBooks.app
			;;
		imagecapture)	# Image Capture.app
			;;
		iterm)			# iTerm.app
			move_directory_entry "D" "$SOURCE/.iterm2" "/Users/steve/.iterm2"
			move_directory_entry "F" "$SOURCE/.iterm2_shell_integration.bash" "/Users/steve/.iterm2_shell_integration.bash"
			move_directory_entry "D" "$SOURCE/Library/Application Support/iTerm" "/Users/steve/Library/Application Support/iTerm"
			move_directory_entry "D" "$SOURCE/Library/Application Support/iTerm2" "/Users/steve/Library/Application Support/iTerm2"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.googlecode.iterm2.plist" "/Users/steve/Library/Preferences/com.googlecode.iterm2.plist"
			;;
		itunes)			# iTunes.app
			move_directory_entry "D" "$SOURCE/Library/iTunes" "/Users/steve/Library/iTunes"	
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.iPod.plist" "/Users/steve/Library/Preferences/com.apple.iPod.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.iTunes.eq.plist" "/Users/steve/Library/Preferences/com.apple.iTunes.eq.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.iTunes.Gracenote.plist" "/Users/steve/Library/Preferences/com.apple.iTunes.Gracenote.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.iTunes.plist" "/Users/steve/Library/Preferences/com.apple.iTunes.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.iTunes.plugins" "/Users/steve/Library/Preferences/com.apple.iTunes.plugins"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.iTunes.utls.plist" "/Users/steve/Library/Preferences/com.apple.iTunes.utls.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.iTunesHelper.plist" "/Users/steve/Library/Preferences/com.apple.iTunesHelper.plist"
			;;
		ivacy)			# Ivacy.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/gaditek.Ivacy.com" "/Users/steve/Library/Application Support/gaditek.Ivacy.com"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.ivacy.mac.plist" "/Users/steve/Library/Preferences/com.ivacy.mac.plist"
			if [ ! -d "/Users/steve/Library/userData" ]; then
				mkdir "/Users/steve/Library/userData"
				if [ $? == 0 ]; then echo `date '+%Y-%m-%d %H:%M:%S'` "[D205:$APP] Created folder \"/Users/steve/Library/userData\"" >> ~/$LOG; fi
			fi
			move_directory_entry "D" "$SOURCE/Library/userData/ivacy" "/Users/steve/Library/userData/ivacy"
			;;
		launchcontrol)	# LaunchControl.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/LaunchControl" "/Users/steve/Library/Application Support/LaunchControl"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.soma-zone.LaunchControl.plist" "/Users/steve/Library/Preferences/com.soma-zone.LaunchControl.plist"
			;;
		littlesnitch)	# Little Snitch Configuration.app
			;;
		logioptions)	# Logi Options.app
			;;
		mail)			# Mail.app
			move_directory_entry "D" "$SOURCE/Library/Accounts" "/Users/steve/Library/Accounts"
			move_directory_entry "D" "$SOURCE/Library/Mail" "/Users/steve/Library/Mail"
			#move_directory_entry "D" "$SOURCE/Library/Containers/com.apple.mail" "/Users/steve/Library/Containers/com.apple.mail"
			#move_directory_entry "D" "$SOURCE/Library/Containers/com.apple.MailCacheDelete" "/Users/steve/Library/Containers/com.apple.MailCacheDelete"
			#move_directory_entry "D" "$SOURCE/Library/Containers/com.apple.MailServiceAgent" "/Users/steve/Library/Containers/com.apple.MailServiceAgent"
			#move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.accounts.plist" "/Users/steve/Library/Preferences/com.apple.accounts.plist"
			#move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.accountsd.plist" "/Users/steve/Library/Preferences/com.apple.accounts.plist"
			#move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.mail-shared.plist" "/Users/steve/Library/Preferences/com.apple.mail-shared.plist"
			#move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.mail.plist" "/Users/steve/Library/Preferences/com.apple.mail.plist"
			;;
		maintenance)	# Maintenance.app
			;;
		malwarebytes)	# Malwarebytes.app
			;;
		mamp)			# MAMP
			#move_directory_entry "D" "$SOURCE/Applications/MAMP" "/Applications/MAMP"
			move_directory_entry "F" "$SOURCE/Library/Preferences/de.appsolute.MAMP.plist" "/Users/steve/Library/Preferences/de.appsolute.MAMP.plist"
			;;
		maps)			# Maps.app
			;;
		marsedit)		# MarsEdit.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/MarsEdit" "/Users/steve/Library/Application Support/MarsEdit"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.red-sweater.marsedit.plist" "/Users/steve/Library/Preferences/com.red-sweater.marsedit.plist"
			;;
		memoryclean)	# Memory Clean.app
			;;
		messages)		# Messages.app
			move_directory_entry "D" "$SOURCE/Library/Messages" "/Users/steve/Library/Messages"
			;;
		missioncontrol)	# Mission Control.app
			;;
		netbeans)		# NetBeans
			move_directory_entry "D" "$SOURCE/Library/Application Support/NetBeans" "/Users/steve/Library/Application Support/NetBeans"
			#move_directory_entry "D" "$SOURCE/Sundry/NetBeansProjects" "/Users/steve/Sundry/NetBeansProjects"
			;;
		netspot)		# NetSpot.app
			;;
		noip)			# No-IP DUC.app
			;;
		notes)			# Notes.app
			;;
		office)			# MS Office 365
			# Excel.app
			move_directory_entry "D" "$SOURCE/Library/Containers/com.microsoft.Excel" "/Users/steve/Library/Containers/com.microsoft.Excel"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.microsoft.Excel.plist" "/Users/steve/Library/Preferences/com.microsoft.Excel.plist"
			# OneNote.app
			move_directory_entry "D" "$SOURCE/Library/Containers/com.microsoft.onenote.mac" "/Users/steve/Library/Containers/com.microsoft.onenote.mac"
			# Outlook.app
			move_directory_entry "D" "$SOURCE/Library/Containers/com.microsoft.Outlook" "/Users/steve/Library/Containers/com.microsoft.Outlook"
			# Powerpoint.app
			move_directory_entry "D" "$SOURCE/Library/Containers/com.microsoft.Powerpoint" "/Users/steve/Library/Containers/com.microsoft.Powerpoint"
			# Word.app
			move_directory_entry "D" "$SOURCE/Library/Containers/com.microsoft.Word" "/Users/steve/Library/Containers/com.microsoft.Word"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.microsoft.Word.plist" "/Users/steve/Library/Preferences/com.microsoft.Word.plist"
			# Miscellaneous
			move_directory_entry "D" "$SOURCE/Library/Containers/com.microsoft.errorreporting" "/Users/steve/Library/Containers/com.microsoft.errorreporting"
			move_directory_entry "D" "$SOURCE/Library/Containers/com.microsoft.netlib.shipassertprocess" "/Users/steve/Library/Containers/com.microsoft.netlib.shipassertprocess"
			move_directory_entry "D" "$SOURCE/Library/Containers/com.microsoft.Office365ServiceV2" "/Users/steve/Library/Containers/com.microsoft.Office365ServiceV2"
			move_directory_entry "D" "$SOURCE/Library/Containers/com.microsoft.RMS-XPCService" "/Users/steve/Library/Containers/com.microsoft.RMS-XPCService"
			move_directory_entry "D" "$SOURCE/Library/Group Containers/UBF8T346G9.ms" "/Users/steve/Library/Group Containers/UBF8T346G9.ms"
			move_directory_entry "D" "$SOURCE/Library/Group Containers/UBF8T346G9.Office" "/Users/steve/Library/Group Containers/UBF8T346G9.Office"
			move_directory_entry "D" "$SOURCE/Library/Group Containers/UBF8T346G9.OfficeOsfWebHost" "/Users/steve/Library/Group Containers/UBF8T346G9.OfficeOsfWebHost"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.microsoft.office.plist" "/Users/steve/Library/Preferences/com.microsoft.office.plist"
			;;
		onedrive)		# OneDrive.app
			;;
		onyx)			# OnyX.app
			;;
		patterns)		# Patterns.app
			;;
		photobooth)		# Photo Booth.app
			;;
		photos)			# Photos.app
			move_directory_entry "D" "$SOURCE/Library/Containers/com.apple.PhotoIngestService" "/Users/steve/Library/Containers/com.apple.PhotoIngestService"
			move_directory_entry "D" "$SOURCE/Library/Containers/com.apple.photolibraryd" "/Users/steve/Library/Containers/com.apple.photolibraryd"
			move_directory_entry "D" "$SOURCE/Library/Containers/com.apple.PhotoLibraryMigrationUtility" "/Users/steve/Library/Containers/com.apple.PhotoLibraryMigrationUtility"
			move_directory_entry "D" "$SOURCE/Library/Containers/com.apple.photomodel" "/Users/steve/Library/Containers/com.apple.photomodel"
			move_directory_entry "D" "$SOURCE/Library/Containers/com.apple.photomoments" "/Users/steve/Library/Containers/com.apple.photomoments"
			move_directory_entry "D" "$SOURCE/Library/Containers/com.apple.Photos" "/Users/steve/Library/Containers/com.apple.Photos"
			move_directory_entry "D" "$SOURCE/Library/Containers/com.apple.photos.ImageConversionService" "/Users/steve/Library/Containers/com.apple.photos.ImageConversionService"
			move_directory_entry "D" "$SOURCE/Library/Containers/com.apple.Photos.StorageManagementExtension" "/Users/steve/Library/Containers/com.apple.Photos.StorageManagementExtension"
			move_directory_entry "D" "$SOURCE/Library/Containers/com.apple.photos.VideoConversionService" "/Users/steve/Library/Containers/com.apple.photos.VideoConversionService"
			move_directory_entry "D" "$SOURCE/Library/Containers/com.apple.PhotoThemeService" "/Users/steve/Library/Containers/com.apple.PhotoThemeService"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.Photos.plist" "/Users/steve/Library/Preferences/com.apple.Photos.plist"

			;;
		preview)		# Preview.app
			;;
		quicktime)		# QuickTime Player.app
			;;
		regexrx)		# RegExRX.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/RegExRx" "/Users/steve/Library/Application Support/RegExRx"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.mactechnologies.regexrx.plist" "/Users/steve/Library/Preferences/com.mactechnologies.regexrx.plist"
			;;
		remindinders)	# Reminders.app
			;;
		safari)			# Safari.app
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.Safari.Extensions.plist" "/Users/steve/Library/Preferences/com.apple.Safari.Extensions.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.Safari.plist" "/Users/steve/Library/Preferences/com.apple.Safari.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.Safari.SafeBrowsing.plist" "/Users/steve/Library/Preferences/com.apple.Safari.SafeBrowsing.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.Safari.Support.plist" "/Users/steve/Library/Preferences/com.apple.Safari.Support.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.SafariBookmarksSyncAgent.plist" "/Users/steve/Library/Preferences/com.apple.SafariBookmarksSyncAgent.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.apple.SafariCloudHistoryPushAgent.plist" "/Users/steve/Library/Preferences/com.apple.SafariCloudHistoryPushAgent.plist"
			move_directory_entry "D" "$SOURCE/Library/Safari" "/Users/steve/Library/Safari"
			;;
		screenflow)		# ScreenFlow.app
			;;
		screenium)		# Screenium 3 Demo.app
			;;
		sequelpro)		# Sequel Pro.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/Sequel Pro" "/Users/steve/Library/Application Support/Sequel Pro"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.sequelpro.SequelPro.plist" "/Users/steve/Library/Preferences/com.sequelpro.SequelPro.plist"
			;;
		siri)			# Siri.app
			;;
		skitch)			# Skitch.app
			move_directory_entry "D" "$SOURCE/Library/Containers/J8RPQ294UB.com.skitch.SkitchHelper" "/Users/steve/Library/Containers/J8RPQ294UB.com.skitch.SkitchHelper"
			move_directory_entry "D" "$SOURCE/Library/Group Containers/J8RPQ294UB.com.skitch" "/Users/steve/Library/Group Containers/J8RPQ294UB.com.skitch"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.skitch.skitch.plist" "/Users/steve/Library/Preferences/com.skitch.skitch.plist"
			;;
		skype)			# Skype.app
			;;
		speedtest)		# Speedtest.app
			;;
		stickies)		# Stickies.app
			;;
		sysprefs)		# System Preferences.app
			;;
		textedit)		# TextEdit.app
			;;
		textwrangler)	# TextWrangler.app
			move_directory_entry "D" "$SOURCE/Library/Application Support/TextWrangler" "/Users/steve/Library/Application Support/TextWrangler"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.barebones.textwrangler.plist" "/Users/steve/Library/Preferences/com.barebones.textwrangler.plist"
			move_directory_entry "F" "$SOURCE/Library/Preferences/com.barebones.textwrangler.PreferenceData" "/Users/steve/Library/Preferences/com.barebones.textwrangler.PreferenceData"
			;;
		timemachine)	# Time Machine.app
			;;
		vmware)			# VMware Fusion.app
			#move_directory_entry "D" "$SOURCE/VMWare" "/Users/steve/VMWare"
			SRC="/Volumes/ChronoSync Users Data/Users/steve/VMware/"
			TRG="/Users/steve/VMware"
			if [ -d "$TRG" ]; then
				echo "ERROR: The target folder \"$TRG\" already exists."
				return
			elif [ -d "$SRC" ]; then
				echo "Copying \"$SRC\" to \"$TRG\"..."
				mkdir "$TRG"
				cp -pR "$SRC" "$TRG"
				if [ $? == 0 ]; then
					echo `date '+%Y-%m-%d %H:%M:%S'` "[D505:$APP] Copied source folder \"$SRC\" to target folder \"$TRG\"" >> ~/$LOG
					move_directory_entry "D" "$SOURCE/Library/Application Support/VMware Fusion" "/Users/steve/Library/Application Support/VMware Fusion"
					move_directory_entry "D" "$SOURCE/Library/Preferences/VMware Fusion" "/Users/steve/Library/Preferences/VMware Fusion"
				fi
			else
				echo `date '+%Y-%m-%d %H:%M:%S'` "[DXXX:$APP] ERROR: Source folder \"$SRC\" does not exist" >> ~/$LOG;
			fi
			;;
		whitenoise)		# WhiteNoiseFree.app
			;;
		xampp)			# XAMPP
			;;
		xcode)			# Xcode.app”
			;;
		# * * * * REMAINING SOURCE FILES AND FOLDERS * * * *
		remaining)

			shopt -s nullglob
			shopt -u dotglob

			# Remaining files/folders on source
			for f in "$SOURCE"/{..?,.[!.],}*; do		# See https://unix.stackexchange.com/questions/162586/proper-way-to-iterate-through-contents-in-a-directory
				#echo "$f"
				NAME=$(basename -- "$f")
				if [ ! "$NAME" == "Library" ]; then			# Exclude the Library folder
					if [ ! -e "/Users/steve/$NAME" ]; then		# file doesn't exist on target
						read -p "Move the file $f to /Users/steve/$NAME (Y/n)? " MOVE
						if [[ $MOVE =~ [A-Z] && $MOVE == "Y" ]]; then
							#echo "Testing $f to /Users/steve/$NAME"
							if [ -f "$f" ]; then
								move_directory_entry "F" "$f" "/Users/steve/$NAME"
							elif [ -d "$f" ]; then
								move_directory_entry "D" "$f" "/Users/steve/$NAME"
							fi
						fi
						unset MOVE
					fi
				fi
			done

			shopt -u nullglob
			shopt -s dotglob
			;;
		# * * * * MISCELLANEOUS * * * *
		bash)
			create_symbolic_link "/Users/steve/Dropbox/.bash_history_shared" "/Users/steve/.bash_history"
			create_symbolic_link "/Users/steve/Dropbox/.bash_profile_shared" "/Users/steve/.bash_profile"
			move_directory_entry "F" "$SOURCE/.hushlogin" "/Users/steve/.hushlogin"
			;;
		fonts)
			move_directory_entry "D" "$SOURCE/Library/Fonts" "/Users/steve/Library/Fonts"
			;;
		launchagents-1)	# Housekeep
			move_directory_entry "F" "$SOURCE/Library/LaunchAgents/com.steve.housekeep.box-sync.plist" "/Users/steve/Library/LaunchAgents/com.steve.housekeep.box-sync.plist"
			#launchctl load /Users/steve/Library/LaunchAgents/com.steve.housekeep.box-sync.plist	# Currently disabled

			move_directory_entry "F" "$SOURCE/Library/LaunchAgents/com.steve.housekeep.desktop-filing.plist" "/Users/steve/Library/LaunchAgents/com.steve.housekeep.desktop-filing.plist"
			launchctl load /Users/steve/Library/LaunchAgents/com.steve.housekeep.desktop-filing.plist

			move_directory_entry "F" "$SOURCE/Library/LaunchAgents/com.steve.housekeep.downloads.plist" "/Users/steve/Library/LaunchAgents/com.steve.housekeep.downloads.plist"
			launchctl load /Users/steve/Library/LaunchAgents/com.steve.housekeep.downloads.plist
			;;
		launchagents-2)	# Airmail, Mail and Outlook
			# Airmail
			move_directory_entry "F" "$SOURCE/Library/LaunchAgents/com.steve.Airmail.open.plist" "/Users/steve/Library/LaunchAgents/com.steve.Airmail.open.plist"
			#launchctl load /Users/steve/Library/LaunchAgents/com.steve.Airmail.open.plist			# Currently disabled

			move_directory_entry "F" "$SOURCE/Library/LaunchAgents/com.steve.Airmail.close.plist" "/Users/steve/Library/LaunchAgents/com.steve.Airmail.close.plist"
			#launchctl load /Users/steve/Library/LaunchAgents/com.steve.Airmail.close.plist			# Currently disabled

			# Mail
			move_directory_entry "F" "$SOURCE/Library/LaunchAgents/com.steve.Mail.open.plist" "/Users/steve/Library/LaunchAgents/com.steve.Mail.open.plist"
			launchctl load /Users/steve/Library/LaunchAgents/com.steve.Mail.open.plist

			move_directory_entry "F" "$SOURCE/Library/LaunchAgents/com.steve.Mail.close.plist" "/Users/steve/Library/LaunchAgents/com.steve.Mail.close.plist"
			launchctl load /Users/steve/Library/LaunchAgents/com.steve.Mail.close.plist

			# Outlook
			move_directory_entry "F" "$SOURCE/Library/LaunchAgents/com.steve.Outlook.open.plist" "/Users/steve/Library/LaunchAgents/com.steve.Outlook.open.plist"
			launchctl load /Users/steve/Library/LaunchAgents/com.steve.Outlook.open.plist

			move_directory_entry "F" "$SOURCE/Library/LaunchAgents/com.steve.Outlook.close.plist" "/Users/steve/Library/LaunchAgents/com.steve.Outlook.close.plist"
			launchctl load /Users/steve/Library/LaunchAgents/com.steve.Outlook.close.plist
			;;
		scripts)
			create_symbolic_link "/Users/steve/Library/Mobile Documents/com~apple~CloudDocs/Scripts" "/Users/steve/Library/Scripts"
			;;
		services)
			move_directory_entry "D" "$SOURCE/Library/Services" "/Users/steve/Library/Services"
			;;
		ssh)
			move_directory_entry "D" "$SOURCE/.ssh" "/Users/steve/.ssh"
			;;
		macos)
			chmod +x "/Users/steve/Sundry/GitHub/macOS Configuration/macos-setup.sh"
			create_symbolic_link "/Users/steve/Sundry/GitHub/macOS Configuration" "/Users/steve/macos-configuration-master"
			;;
		# * * * * DEFAULT FOR NON-MATCHING $APP * * * *
		*)
			echo "ERROR: The application '$APP' is not recognised"
			VALID=false
			;;


	esac

	shopt -s dotglob

	if [ $VALID == true ]; then
		echo "FINISHED: '$APP'"
	fi

	if [ $APP == "mail" ]; then
		echo "< < < < < < < RESTART YOUR COMPUTER FOR CHANGES TO TAKE EFFECT > > > > > > >"
	fi

	# As this script is executed in the current shell, variables that are set by this script are persistent. Variables that are set by this script that should NOT be persistent have to be `unset`
	unset APP

}



create_symbolic_link() {

	S=$1
	T=$2

	#echo "${S}"
	#echo "${T}"

	if [ -e "${S}" ]; then
		if [ -L "${T}" ]; then
			# Removes the symbolic link with the same name as the Target if it exists first
			unlink "${T}"
			if [ $? == 0 ]; then echo `date '+%Y-%m-%d %H:%M:%S'` "[L301:$APP] Deleted symbolic link \"${T}\"" >> ~/$LOG; fi
		elif [ -d "${T}" ]; then
			# Removes the existing directory with the same name as the Target if it exists first
			rm -rf "${T}"
			if [ $? == 0 ]; then echo `date '+%Y-%m-%d %H:%M:%S'` "[L302:$APP] Deleted target directory with same name as symbolic link \"${T}\"" >> ~/$LOG; fi
		elif [ -f "${T}" ]; then
			# Removes the existing file with the same name as the Target if it exists first
			rm -f "${T}"
			if [ $? == 0 ]; then echo `date '+%Y-%m-%d %H:%M:%S'` "[L303:$APP] Deleted target file with same name as symbolic link \"${T}\"" >> ~/$LOG; fi
		fi
		# Creates the symbolic link
		ln -s "${S}" "${T}"
		if [ $? == 0 ]; then echo `date '+%Y-%m-%d %H:%M:%S'` "[L304:$APP] Created symbolic \"${T}\" (Points to \"${S}\")" >> ~/$LOG; fi
		#echo "Symbolic link '${T}' created."
	else
		#echo "ERROR: S '${S}' does not exist."
		echo `date '+%Y-%m-%d %H:%M:%S'` "[L305:$APP] ERROR: Source \"${S}\" does not exist" >> ~/$LOG
	fi
}

move_directory_entry () {

	E=$1		# E[ntry Type]	F=file, D=directory
	S=$2		# S[ource]		/Users/steve/TM Restore 2018-03-30/steve/Library/Application Support/MarsEdit
	T=$3		# T[arget]		/Users/steve/Library/Application Support/MarsEdit

	#echo $E
	#echo "$S"
	#echo "$T"

	if [ $E == "F" ]; then	# directory entry is a file
		if [ -f "$S" ]; then	# if the file exists on the source
			if [ -f "$T" ]; then 	# if the file exists on the target...
				rm "$T"					#	...delete it on the target
				if [ $? == 0 ]; then echo `date '+%Y-%m-%d %H:%M:%S'` "[F101:$APP] Deleted target file \"$T\"" >> ~/$LOG; fi
			fi
			mv "$S" "$T"			# move the source file to the target
			if [ $? == 0 ]; then echo `date '+%Y-%m-%d %H:%M:%S'` "[F102:$APP] Moved source file \"$S\" to target file \"$T\"" >> ~/$LOG; fi
		else
			echo `date '+%Y-%m-%d %H:%M:%S'` "[FXXX:$APP] ERROR: Source file \"$S\" does not exist" >> ~/$LOG;
		fi
	elif [ $E == "D" ]; then	# directory entry is a folder
		if [ -d "$S" ]; then		# if the folder exists on the source
			if [ -d "$T" ]; then 		# if the folder exists on the target...
				rm -rf "$T"/*					# ...delete its contents on the target
				if [ $? == 0 ]; then echo `date '+%Y-%m-%d %H:%M:%S'` "[D101:$APP] Deleted contents of target folder \"$T\"" >> ~/$LOG; fi
				mv "$S"/* "$T"					# ...move the contents of the source folder to the target folder
				if [ $? == 0 ]; then echo `date '+%Y-%m-%d %H:%M:%S'` "[D102:$APP] Moved contents of source folder \"$S\" to target folder \"$T\"" >> ~/$LOG; fi
				sudo rm -rf "$S"						# ...delete the source folder
				if [ $? == 0 ]; then echo `date '+%Y-%m-%d %H:%M:%S'` "[D103:$APP] Deleted source folder \"$S\"" >> ~/$LOG; fi
			else
				sudo mv "$S" "$T"				# ...move the source folder to the target folder
				if [ $? == 0 ]; then echo `date '+%Y-%m-%d %H:%M:%S'` "[D202:$APP] Moved source folder \"$S\" to target folder \"$T\"" >> ~/$LOG; fi
			fi
		else
			echo `date '+%Y-%m-%d %H:%M:%S'` "[DXXX:$APP] ERROR: Source folder \"$S\" does not exist" >> ~/$LOG;
		fi
	fi

}

populate () {

	i=$1
	s=$SOURCE

	if [ $i == "Public" ]; then
		mkdir "$s"/"$i"
		s="$s"/Public
		i="Drop Box"
	fi

	mkdir "$s"/"$i"
	touch "$s"/"$i"/."$i".1
	touch "$s"/"$i"/"$i".2
	touch "$s"/"$i"/"$i".3
	mkdir "$s"/"$i"/folder\ 1/
	touch "$s"/"$i"/folder\ 1/."$i".4
	touch "$s"/"$i"/folder\ 1/"$i".5
	touch "$s"/"$i"/folder\ 1/"$i".6

}

main "$@"
