# $1 = YYYY-MM-DD-HHMMSS i.e. 2019-04-24-001714

shopt -s dotglob	# Ensure .hidden files are included
[ ! -d /Users/steve/TM\ Restore\ 2019-05-03/Pictures ] && mkdir /Users/steve/TM\ Restore\ 2019-05-03/Pictures
for f in /Volumes/Time\ Machine\ \[A\]/Backups.backupdb/Steve’s\ iMac\ 27\"\ 5K/"${1}"/Macintosh\ HD/Users/steve/Pictures/*; do
	if [[ $(basename "$f") != "Photos Library.photoslibrary" ]]; then
		#echo "$f"
		tmutil restore -v "${f}" /Users/steve/TM\ Restore\ 2019-05-03/Pictures
	fi
done