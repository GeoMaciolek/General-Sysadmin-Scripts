#!/bin/bash
## MySQL Backup script
## G.Maciolek 2015-04-11
##
## Performs locking-style (mysqldump) backups, compresses files, retains backups for the
## number of days specified, and deletes all older backups, retaining the first of the
## month indefinitely.
##
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


##### End configuration options

# Guess binary names
mysqlbin="$(which mysql)"
mysqldumpbin="$(which mysqldump)"


compressbin="$(which ${compressiontool})"

timestamp() {
      date +"%F %T - " | tr -d '\n' #remove newline!
}

timestamp; echo "############### Beginning backup job ##################"

umask 007 #Make sure the files are written 660
# get all db names
dbs=$($mysqlbin -u$muser -h$mhost -p$mpass -Bse 'show databases')
for db in $dbs
do
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
done


#find /var/backups/mysql/ -ctime +$KEEPDAYS -not -name "*-??-01-??\:??.sql.*" -exec \

# Remove backups older than "$keepdays" old. Always retain first of the month backups
# excluding files w/".txt" extensions, & only includes files w/ names containing  ".backup."
find $backuplocation/ -mtime +$keepdays -type f -name "*.backup.*" -not -name "*.txt" -exec bash -c '

     #{} is passed to this subshell, and shows up here as $0
     dom=$(stat -c %y $0 | cut -c "9,10")  #find the date of the file
     if [ "$dom" != "01" ]; then   #is day of the month 01?
       rm $0   #remove the file
     fi' {} \;  #actually passes in the filename

timestamp; echo "############### Backup job finished! ##################"

