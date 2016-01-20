#!/bin/bash

# Friendly Plesk 10/11 E-Mail password dumping utility
#
# Taking advanage of numerous places where passwords are stored in plaintext in Plesk!
#
# --Geoff Maciolek
#
# 2016-01-20 - v0.2: Set up to allow use of root & attendent .psa.shadow file

if [[ $# -ne 1 ]]; then
  echo "Usage:"
  echo "   $0 domainname.com : List all passwords at domainname.com"
  echo "   $0 -a : List all account passwords"
  echo
  echo "Note - running as root will not prompt for the plesk administrative password"
else
   if [[ $EUID -eq 0 ]]; then
      parg=$(cat /etc/psa/.psa.shadow) #this is a bit dangerous
    else
      echo -n "(Plesk Admin Account) " # Display this if we're not doing it automatically as root
      #$parg="" # It doesn't need to be anything
   fi
    if [[ $1 == "-a" ]]; then
    SearchCriteria="" #Display all domains
  else
    SearchCriteria="WHERE domains.name LIKE \"%$1%\""
  fi
  echo "SELECT accounts.id, mail.mail_name, accounts.password, domains.name FROM domains LEFT JOIN mail ON domains.id = mail.do
m_id LEFT JOIN accounts ON mail.account_id = accounts.id $SearchCriteria;"\
  |  mysql -u admin -p"$parg" psa | tail -n +2| awk '{printf $2"@"$4" - " $3 "\n"; }'

 parg=""
fi
