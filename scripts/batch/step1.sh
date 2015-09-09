#!/bin/bash

#TODO: Check for existence of generics

echo
echo ===========================
echo EEG Data Rename\&Merge Tool
echo ===========================
echo Author: Zach Psaras
echo For the Suzuki Lab @ NYU
echo
echo Run with arg -n for NO CHANGE
echo Use this to double check for possible mistakes.
echo Note that when using this option, the rename
echo operations will claim to have renamed files
echo when no rename has actually occurred.
echo
echo Checking for required tools...

if [ ! -x ./xml-edit ]; then
	echo -e '\E[31m'"Missing xml-edit! Aborting"
	tput sgr0
	exit
fi

echo
echo -e '\E[35m'"It is strongly recommended that you make backups!"
echo

tput sgr0

echo This file script should be run from the top-most
echo level of your EEG Data folder hierarchy.
echo
read -r -p "Are you ready to continue? [y/N] " response

case $response in
	[yY][eE][sS]|[yY])
		# Continue
		;;
	*)
		echo Aborting
		exit
		;;
esac

if [ "$1" == "-n" ]; then
	echo You have set NO CHANGE. We will not perform operations.
	change=false
else
	change=true
fi

echo Renaming supply.dat files...
if [ $change = false ]; then
	find -name 'supply.dat' | rename -n 's/\.dat/.supply/'
else
	find -name 'supply.dat' | rename -v 's/\.dat/.supply/'
fi
echo

echo Renaming time.dat files...
if [ $change = false ]; then
	find -name 'time.dat' | rename -n 's/\.dat/.time/'
else
	find -name 'time.dat' | rename -v 's/\.dat/.time/'
fi
echo

echo Renaming amplifier.dat files...
if [ $change = false ]; then
	find . -iname 'amplifier.dat' | 
	while read fn; do name=$(basename "$fn") ; dir=$(dirname "$fn") ; echo "$fn" renamed as "$dir/$(basename "$dir")-wideband.dat" ;done
else
	find . -iname 'amplifier.dat' |
	while read fn; do name=$(basename "$fn") ; dir=$(dirname "$fn") ; mv "$fn" "$dir/$(basename "$dir")-wideband.dat" ; echo "$fn" renamed as "$dir/$(basename "$dir")-wideband.dat" ;done
fi
echo

echo Renaming auxiliary.dat files...
if [ $change = false ]; then
	find . -iname 'auxiliary.dat' |
	while read fn; do name=$(basename "$fn") ; dir=$(dirname "$fn") ; echo "$fn" renamed as "$dir/$(basename "$dir")-filtered.dat" ;done
else
	find . -iname 'auxiliary.dat' |
	while read fn; do name=$(basename "$fn") ; dir=$(dirname "$fn") ; mv "$fn" "$dir/$(basename "$dir")-filtered.dat" ; echo "$fn" renamed as "$dir/$(basename "$dir")-filtered.dat" ;done
fi
echo

echo Renaming digitalout.dat files
if [ $change = false ]; then
	find . -iname 'digitalout.dat' |
	while read fn; do name=$(basename "$fn") ; dir=$(dirname "$fn") ; echo "$fn" renamed as "$dir/$(basename "$dir").digitalout" ;done
else
	find . -iname 'digitalout.dat' |
	while read fn; do name=$(basename "$fn") ; dir=$(dirname "$fn") ; mv "$fn" "$dir/$(basename "$dir").digitalout" ; echo "$fn" renamed as "$dir/$(basename "$dir").digitalout" ;done
fi
echo

echo Renaming analogin.dat files...
if [ $change = false ]; then
	find . -iname 'analogin.dat' |
	while read fn; do name=$(basename "$fn") ; dir=$(dirname "$fn") ; echo "$fn" renamed as "$dir/$(basename "$dir").analogin" ;done
else
	find . -iname 'analogin.dat' |
	while read fn; do name=$(basename "$fn") ; dir=$(dirname "$fn") ; mv "$fn" "$dir/$(basename "$dir").analogin" ; echo "$fn" renamed as "$dir/$(basename "$dir").analogin" ;done
fi
echo

echo Renaming amplifier.nrs NOTE: This file may not exist.
if [ $change = false ]; then
	find . -iname 'amplifier.nrs' |
	while read fn; do name=$(basename "$fn") ; dir=$(dirname "$fn") ; echo "$fn" renamed as "$dir/$(basename "$dir").nrs" ;done
else
	find . -iname 'amplifier.nrs' |
	while read fn; do name=$(basename "$fn") ; dir=$(dirname "$fn") ; mv "$fn" "$dir/$(basename "$dir").nrs" ; echo "$fn" renamed as "$dir/$(basename "$dir").nrs" ;done
fi
echo

echo Copying generic XML...
#Just looking for folders with a file we have changed
if [ $change = false ]; then
	find -name '*.analogin' |
	while read fn; do dir=$(dirname "$fn") ; echo Copied amplifier.xml to "$dir/$(basename "$dir").xml" ;done
else
	find -name '*.analogin' |
	while read fn; do dir=$(dirname "$fn") ; cp "../xml/amplifier.xml" "$dir/$(basename "$dir").xml" ; echo Copied amplifier.xml to "$dir/$(basename "$dir").xml" ;done
fi
echo

echo Changing channels in Acquisition System from 20 to 23...
xml_suffix=".xml"
if [ $change = false ]; then
	find -name '*.xml'
else
	find -name '*.xml' |
	while read fn; do dir=$(dirname "$fn") ; ./xml-edit "$dir/$dir$xml_suffix" /parameters/acquisitionSystem/nChannels "23" "$dir/$dir$xml_suffix" ;done
fi
echo

echo Done!
