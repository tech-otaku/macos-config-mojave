#!/usr/bin/env bash

/Users/steve/Developer/GitHub/macos-config-mojave/Utilities/sqldiff \
/Users/steve/Developer/GitHub/macos-config-mojave/db/desktoppicture.db \
#/Users/steve/Developer/GitHub/macos-config-mojave/db/mojave-dynamic.db > /tmp/changes.tmp
/Users/steve/Developer/GitHub/macos-config-mojave/db/mojave-dynamic.db

while read p; do
  #echo "sqlite3 /Users/steve/Desktop/desktoppicture.db \"$p\""
  #sqlite3 /Users/steve/Desktop/desktoppicture.db "$p"
done < /tmp/changes.tmp

#row=$(sqlite3 /Users/steve/Desktop/desktoppicture.db "SELECT rowid FROM data WHERE value LIKE '%/Library/Desktop Pictures%';")
#sqlite3 /Users/steve/Desktop/desktoppicture.db "UPDATE data SET value = '/Library/Desktop Pictures/El Capitan.jpg' WHERE rowid = $row;"
