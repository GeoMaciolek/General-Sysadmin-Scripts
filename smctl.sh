#!/bin/bash
###########
##
##  Silly Smartctl Wrapper, Geoff Maciolek
##  https://github.com/GeoffMaciolek/General-Sysadmin-Scripts
##
##  This wrapper allows you to do things like "smctl /dev/sda /dev/sdb /dev/sde"
##  and have smartctl run for each device, one after another.
##
##  2015-05-31:  Initial release, 0.1
##

#### Config options ####

## Set this if you need to specify the path to smartctl for any reason
## (usually blank)
smartctlbin=


####   End config   ####
########################
### Internal Config  ###

myname="smartctl helper"
myver="0.1"
myurl="https://github.com/GeoffMaciolek/General-Sysadmin-Scripts"

## Functions ##

usage() {
  echo "Usage: as with smartctl, but you may specify multiple devices, eg"
  echo
  echo "Examples:
   $0 -x /dev/sda /dev/sdb
    Print all SMART and ATA info for /dev/sda and /dev/sdb

   $0 -a /dev/sd[a-g]| grep -E \"##|CRC\"
         Use shell globbing to get SMART info from all *existing* devices /dev/sda - /dev/sdg (if supported by your shell)
         and pipe through grep to find any CRC errors.  (## is included to show you which device is which)

   $0 -h,-H,--help
         This help screen.

   $0 -V,--version
         Version info."
  echo
}

version() {
  echo "${myname} ${myver} by Geoff Maciolek"
  echo "Part of the General Sysadmin Scripts collection at"
  echo "${myurl}"
  echo
}

##### Main script  #####

# Guess smartctl name & path, if it has not been specified above
if [[ -z $smartctlbin ]]; then smartctlbin=$(which smartctl); fi

# if "which" cannot locate smartctl, dump its output & inform the user to edit the script (at its location)
if [[ $? != "0" ]]; then
  echo "${smartctlbin}"
  echo "smartctl not found!  This script requires smartctl to be installed and accessible."
  echo "If smartctl is installed, please edit ${BASH_SOURCE[0]}"
  echo
  exit 1
fi

if [[ $# -eq 0 ]]; then # If no parameters specified, display help.
    usage; exit 1
fi

case "$@" in # Check to see if the user wants version info / help.
  *"--version"*|*"-V"*) version; exit 0;;
  *"-h"*|*"-H"*|*"--help"*) usage; exit 0;;
esac

# Check for options, assign to appropriate variables
while test $# -gt 0
do
    case "$1" in
	-*) options="$options $1"
	    ;;
	/*)  drives="$drives $1"
	    ;;
	 *)  echo "Invalid argument: $1     See $0 --help for usage info."
             echo
 	  exit 1;;
    esac
    shift #iterate to the next parameter via shifting all to the "left"
done

for drive in $drives; do
  echo -e "\n########### ${smartctlbin} ${options} ${drive}  ###########\n"
  ${smartctlbin} ${options} ${drive}
done
