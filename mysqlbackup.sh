#!/bin/bash
## MySQL Backup script
## G.Maciolek 2015-04-11
##
## https://github.com/GeoffMaciolek/General-Sysadmin-Scripts
##
## Performs locking-style (mysqldump) backups, compresses files, retains backups for the
## number of days specified, and deletes all older backups, retaining the first of the
## month indefinitely.
## To create the dumper user, execute the following SQL (probably via "mysql -u root -p")
##
## GRANT SELECT, LOCK TABLES, SHOW VIEW ON *.* TO 'dumper'@'localhost' IDENTIFIED BY 'SetYourPass';


##### Configuration options below

# Set mysql login info
muser="dumper"          # Username
mpass="PLEASESetYourPass"    # Password
mhost="127.0.0.1"       # Server Name

#How many days to keep daily backups
keepdays=14

#Backup location
backuplocation="/var/backups/mysql" # Target directory. NO TRAILING SLASH!

#Temp directory
tempdir="/tmp" # Temp dir for .sql - NO TRAILING SLASH
                     # Using temp rather than inline compress to limit the time spent locked

#Compression info
compressiontool="xz" #compression tool: xz, gz, bzip2, etc - must work w/stdio (may require param)
compressionext=".xz" #Compression extension: .xz, .gz .bz2 etc
compressionparams="" # some compressors may require parameters

#Databases to ignore - by default, this will not back up SQL users, only data
declare -a dbignore=('information_schema' 'mysql')


##### End configuration options

# Guess binary names
mysqlbin="$(which mysql)"
mysqldumpbin="$(which mysqldump)"


compressbin="$(which ${compressiontool})"

# Timestamp logging, exported to subshells
timestamp() {
    echo -n "$(date +"%F %T - ")"
}

containsElement () { # for array testing
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

export -f timestamp

timestamp; echo "############### Beginning backup job ##################"

umask 007 #Make sure the files are written 660
# get all db names
dbs=$($mysqlbin -u$muser -h$mhost -p$mpass -Bse 'show databases')
for db in $dbs
do
  if [ $(containsElement "$db" "${dbignore[@]}") ]; then
    echo "Skipping $db"
  else
    now=$(date +"%Y-%m-%d-%H:%M") #params relevant to cleanup script below, SEE BELOW!
    fileout=$db.backup.$now.sql # Don't remove ".backup." as it is part of the cleanup sanity check
    timestamp; echo -n "Dumping $db... "
    mkdir -p $backuplocation/$db/
       #dump the selected database into stdout
    $mysqldumpbin -u ${muser} -h${mhost} -p${mpass} ${db} > $tempdir/$fileout
    echo "done!"
    timestamp; echo -n "Compressing $tempdir/${fileout}... "
    $compressbin $compressionparams $tempdir/$fileout
    echo "Done!"
    timestamp; echo -n "Moving archive to $backuplocation/$db/... "
    mv "$tempdir/$fileout$compressionext" "$backuplocation/$db/"
       # ^ feed through compression tool selected above
    echo "Done!"
  fi
done

# Remove backups older than "$keepdays" old. Always retain first of the month backups,
# only including files w/names inc. ".backup.", and excluding files w/".txt" extensions,
# as well as first of the month files ("*.backup.????-??-01")
find $backuplocation/ -mtime +$keepdays -type f -name "*.backup.*" -not \( -name "*.txt" -o -name "*.backup.????-??-01*" \) -exec bash -c '

     # The filename is passed here as $0 - we log & delete
   timestamp; echo "Removing old file: $0"
   rm $0

' {} \; # End Exec, Pass {} as subshell param, to show up as $0

timestamp; echo "############### Backup job finished! ##################"
