#!/usr/bin/env bash

case "$1" in
	adguard)
		[ -f ~/Downloads/AdGuardInstaller.dmg ] && rm ~/Downloads/AdGuardInstaller.dmg
		curl -o ~/Downloads/AdGuardInstaller.dmg https://download.adguard.com/d/2/AdGuardInstaller.dmg
		hdiutil attach ~/Downloads/AdGuardInstaller.dmg
		#open /Volumes/AdGuard\ Installer
		open /Volumes/AdGuard\ Installer/AdGuard.app
		;;
	atom)
		[ -f ~/Downloads/atom-mac.zip ] && rm ~/Downloads/atom-mac.zip
		curl -o ~/Downloads/atom-mac.zip -L https://atom.io/download/mac 
		cd ~/Downloads
		unzip -o ~/Downloads/atom-mac.zip
		[ -d /Applications/Atom.app ] && rm -rf /Applications/Atom.app
		mv ~/Downloads/Atom.app /Applications
		;;
	bbedit)
		[ -f ~/Downloads/BBEdit_12.6.3.dmg ] && rm ~/Downloads/BBEdit_12.6.3.dmg
		curl -o ~/Downloads/BBEdit_12.6.3.dmg -L https://s3.amazonaws.com/BBSW-download/BBEdit_12.6.3.dmg
		hdiutil attach ~/Downloads/BBEdit_12.6.3.dmg
		open /Volumes/BBEdit\ 12.6.3
		[ -d /Applications/BBEdit.app ] && rm -rf /Applications/BBEdit.app
		cp -r /Volumes/BBEdit\ 12.6.3/BBEdit.app /Applications/BBEdit.app
		hdiutil detach /Volumes/BBEdit\ 12.6.3
		;;
	chronosync)
		[ -f ~/Downloads/CS4_Download.dmg ] && rm ~/Downloads/CS4_Download.dmg
		curl -o ~/Downloads/CS4_Download.dmg -L https://downloads.econtechnologies.com/CS4_Download.dmg
		hdiutil attach ~/Downloads/CS4_Download.dmg
		#open /Volumes/ChronoSync
		open /Volumes/ChronoSync/Install.pkg
		;;
	dropbox)
		[ -f ~/Downloads/DropboxInstaller.dmg ] && rm ~/Downloads/DropboxInstaller.dmg
		curl -o ~/Downloads/DropboxInstaller.dmg -L https://www.dropbox.com/download?plat=mac
		hdiutil attach ~/Downloads/DropboxInstaller.dmg
		#open /Volumes/Dropbox\ Installer
		open /Volumes/Dropbox\ Installer/Dropbox.app
		;;
	evernote)
		[ -f ~/Downloads/Evernote_RELEASE_7.10_457732.dmg ] && rm ~/Downloads/Evernote_RELEASE_7.10_457732.dmg
		curl -o ~/Downloads/Evernote_RELEASE_7.10_457732.dmg -L https://cdn1.evernote.com/mac-smd/public/Evernote_RELEASE_7.10_457732.dmg
		yes | hdiutil attach /Users/steve/Downloads/Evernote_RELEASE_7.10_457732.dmg > /dev/null
		open /Volumes/Evernote
		[ -d /Applications/Evernote.app ] && rm -rf /Applications/Evernote.app
		cp -r /Volumes/Evernote/Evernote.app /Applications/Evernote.app
		hdiutil detach /Volumes/Evernote
		;;
	forklift)
		[ -f ~/Downloads/ForkLift3.3.3.zip ] && rm ~/Downloads/ForkLift3.3.3.zip
		curl -o ~/Downloads/ForkLift3.3.3.zip -L https://download.binarynights.com/ForkLift3.3.3.zip
		cd ~/Downloads
		unzip -o ~/Downloads/ForkLift3.3.3.zip
		[ -d /Applications/ForkLift.app ] && rm -rf /Applications/ForkLift.app
		mv ~/Downloads/ForkLift.app /Applications
		[ -d ~/Downloads/__MACOSX ] &&  rm -rf ~/Downloads/__MACOSX
		;;
	github)
		[ -f ~/Downloads/GitHubDesktop.zip ] && rm ~/Downloads/GitHubDesktop.zip
		curl -o ~/Downloads/GitHubDesktop.zip -L https://central.github.com/deployments/desktop/desktop/latest/darwin
		cd ~/Downloads
		unzip -o ~/Downloads/GitHubDesktop.zip
		[ -d /Applications/Github\ Desktop.app ] && rm -rf /Applications/Github\ Desktop.app
		mv ~/Downloads/GitHub\ Desktop.app /Applications
		;;
	googledrive)
		[ -f ~/Downloads/InstallBackupAndSync.dmg ] && rm ~/Downloads/InstallBackupAndSync.dmg
		curl -o ~/Downloads/InstallBackupAndSync.dmg https://dl.google.com/drive/InstallBackupAndSync.dmg
		hdiutil attach ~/Downloads/InstallBackupAndSync.dmg
		open /Volumes/Install\ Backup\ and\ Sync\ from\ Google
		[ -d /Applications/Backup\ and\ Sync.app ] && rm -rf /Applications/Backup\ and\ Sync.app
		cp -r /Volumes/Install\ Backup\ and\ Sync\ from\ Google/Backup\ and\ Sync.app /Applications/Backup\ and\ Sync.app
		hdiutil detach /Volumes/Install\ Backup\ and\ Sync\ from\ Google
		;;
	iterm)
		[ -f ~/Downloads/iterm.zip ] && rm ~/Downloads/iterm.zip
		curl -o ~/Downloads/iterm.zip -L https://iterm2.com/downloads/stable/latest
		cd ~/Downloads
		unzip -o ~/Downloads/iterm.zip
		[ -d /Applications/iTerm.app ] && rm -rf /Applications/iTerm.app
		mv ~/Downloads/iTerm.app /Applications
		;;
	littlesnitch)
		[ -f ~/Downloads/LittleSnitch-4.3.2.dmg ] && rm ~/Downloads/LittleSnitch-4.3.2.dmg
		curl -o ~/Downloads/LittleSnitch-4.3.2.dmg -L https://www.obdev.at/downloads/littlesnitch/LittleSnitch-4.3.2.dmg
		hdiutil attach ~/Downloads/LittleSnitch-4.3.2.dmg
		#open /Volumes/Little\ Snitch\ 4.3.2
		open /Volumes/Little\ Snitch\ 4.3.2/Little\ Snitch\ Installer.app
		;;
	navicat-mysql)
		[ -f ~/Downloads/navicat121_mysql_en.dmg ] && rm ~/Downloads/navicat121_mysql_en.dmg
		curl -o ~/Downloads/navicat121_mysql_en.dmg -L http://download3.navicat.com/download/navicat121_mysql_en.dmg
		yes | hdiutil attach ~/Downloads/navicat121_mysql_en.dmg > /dev/null
		open /Volumes/Navicat\ for\ MySQL
		#[ -d /Applications/Evernote.app ] && rm -rf /Applications/Evernote.app
		cp -r /Volumes/Navicat\ for\ MySQL/Navicat\ for\ MySQL.app /Applications/Navicat\ for\ MySQL.app
		hdiutil detach /Volumes/Navicat\ for\ MySQL
		;;
	*)
		echo "ERROR: Application '$1' invalid."
		exit 1
		;;
esac
