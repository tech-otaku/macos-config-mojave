# $1 = YYYY-MM-DD-HHMMSS i.e. 2019-04-24-001714

shopt -s dotglob	# Ensure .hidden files are included
for f in /Volumes/Time\ Machine\ \[A\]/Backups.backupdb/Steve’s\ iMac\ 27\"\ 5K/"${1}"/Macintosh\ HD/Users/steve/*; do
	if [[ $(basename "$f") != "Box Sync"  ]] && [[ $(basename "$f") != "TM Restore"* ]]; then
		echo "$f"
	fi
done