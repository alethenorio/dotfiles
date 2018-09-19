#!/bin/sh

set -e

# ini_parser takes 2 arguments, a .ini file and the name of the section
# to parse and sets environment variables called INI_<NAME> where <NAME> is
# the name of the property under that specific section
#
# Example:
# Calling `ini_parser myfile section2` in the following file:
#
# [section1]
# name=superman
# trait=fly
#
# [section2]
# name=aquaman
# trait=swim
#
# Will set the following environment variables
#
# INI_name=aquaman
# INI_trait=swim
#
ini_parser() {
 FILE=$1
 SECTION=$2
 eval "$(sed -e 's/[[:space:]]*=[[:space:]]*/=/g' \
 -e 's/[;#].*$//' \
 -e 's/[[:space:]]*$//' \
 -e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" < $FILE \
 | sed -n -e '/^\['"$SECTION"'\]/I,/^\[/{//!p}' \
 | awk NF \
 | awk '{ print "INI_" $0 }')"
}

usage() {  
	echo "Usage: $0 certificate_file"  
 	exit 1  
 } 

if ! test -x "$(command -v pk12util)"; then
	echo "pk12util not found"
	echo "Try apt-get install libnss3-tools"
	exit 1
fi

if ! test -x "$(command -v openssl)"; then
        echo "openssl not found"
        exit 1
fi

if ! test -f "${HOME}/.mozilla/firefox/profiles.ini"; then
        echo "Unable to find mozilla profile configuration at ~/.mozilla/firefox/profiles.ini"
        exit 1
fi

if [ -z "$1" ]; then
	usage
fi

PROFILE="$2"

if [ -z "$PROFILE" ]; then
	PROFILE="default"
fi

SECTIONS="$(grep -oP '\[\K\w+(?=\])' $HOME/.mozilla/firefox/profiles.ini| tr '\n' ' ')"

PROFILEPATH=""

for SEC in $SECTIONS; do
	ini_parser "$HOME/.mozilla/firefox/profiles.ini" $SEC

	if [ "$INI_Name" = "default" ]; then
		PROFILEPATH="$HOME/.mozilla/firefox/$INI_Path"
		break
	fi
done

if [ -z "$PROFILEPATH" ]; then
	echo "Unable to find Firefox profile certificate database"
	exit 1
fi

# Backup existing databases
find $PROFILEPATH -name *.db -exec cp {} {}.old.$(date +%s) \;

pk12util -i "$1" -d sql:$PROFILEPATH

echo "Import successful"