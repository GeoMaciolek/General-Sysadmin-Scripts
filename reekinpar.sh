#!/bin/bash

###############
##
## Recursive Inclusion Parser (reekinpar)
##     Yeah, it's reek-cursive!
##
##  Geoff Maciolek, 2015-06-02
##  https://github.com/GeoffMaciolek/General-Sysadmin-Scripts

# How do you delinate the beginning of an "include" statement?
# (this can be passed as a parameter as well)

include='@'
verbose=false

myname="Recursive Inclusion Parser (reekinpar)"
myver="0.1"
myurl="https://github.com/GeoffMaciolek/General-Sysadmin-Scripts"


### Functions ###

readit () {
local curfile="${1}"
local linenum=0
  while read line; do
     let linenum+=1
     if [[ ${line} == "${include}"* ]]; then     #Does this line start with the include statement?
       newfile="${line#$include}"                # OK, strip the include tag off
       newfile=$(echo -e "${newfile}" | sed -e 's/^[[:space:]]*//') #strip leading space off too
         if [[ -f "${newfile}" ]]; then  # does the attempted file exist?
           readit "${newfile}"
          else
            if [[ "$verbose" = true ]]; then  #Verbose or standard desc. of error, for consistency
              printf "%-22s[%03u] ##### ERROR, File Not Found: %s\n" "${curfile}" "$linenum" "${newfile}"
             else
              echo "##### ERROR, File Not Found: \"${newfile}\"  (in ${curfile}, line $linenum)"
            fi
            errorlevel=1
         fi
     else
      if [[ "$verbose" == true ]]; then  #22 chars space for filename, 3 digits for line count
         printf "%-22s[%03u] %s\n" "${curfile}" "$linenum" "$line"
      else
         echo "${line}" #plain formatting
      fi
    fi
   done < "${curfile}"
}

usage () {
  echo "${myname} usage"
  echo "$0 [-h/--help] [-v/--verbose] [-V/--version] [-i includetext/--include=includetext] filename"
  echo
  echo "Examples:"
  echo "    reekinpar.sh bacula-dir.conf"
  echo "        Recursively stitch your 'bacula-dir.conf' file and its @/included/sub.configs together into one stream."
  echo
  echo "    reekinpar.sh -v -iINCLUDE= something.ini"
  echo "        Recursively stitch your something.ini file, parsing lines beginning with INCLUDE= as filenames to include,"
  echo "        and display verbosely, with filenames and line numbers"
  echo
}

version() {
  echo "${myname} ${myver} by Geoff Maciolek"
  echo "Part of the General Sysadmin Scripts collection at"
  echo "${myurl}"
  echo
}

### Begin ###

errorlevel=0

if [[ $# -eq 0 ]]; then # If no parameters specified, display help.
    usage; exit 1
fi

case "$@" in # Check to see if the user wants version info / help.
  *"--version"*|*"-V"*) version; exit 0;;
  *"-h"*|*"-H"*|*"--help"*) usage; exit 0;;
esac

filefound=0

# Check for options, assign to appropriate variables
while test $# -gt 0
do
    case "${1}" in
        "-v"|"--verbose") verbose=true;;
        "-i"|"--include")
	   shift
	   include="$1"
            ;;
        "--include="*)
	    include="${1#--include=}" ;;
	"-i"*)
	    include="${1#-i}" ;;
         *)
	   if [[ -f "${1}" ]]; then # This parameter looks like a file, or should be
             if [[ filefound -eq 0 ]]; then
               filetoread="${1}"
              else
		echo "### ERROR: Sorry, you can only specify a single file name."
                usage; exit 1
             fi
             let filefound=1
            else
              echo "### ERROR: Parameter not understood: ${1}"
              usage; exit 1
           fi
	;;
    esac
    shift #iterate to the next parameter via shifting all to the "left"
done

if [[ filefound -eq 0 ]]; then
   echo "ERROR: You must specify a filename."
   usage; exit 1
fi

if [[ "$verbose" == true ]]; then # Print verbose header
  echo "  Input Filename      Line#   Output line"
  echo "----------------------------------------------------------"
fi

readit "${filetoread}"

exit $errorlevel
