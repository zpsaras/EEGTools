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
echo It is important to note that the -n argument 
echo will not show the whole process\; it\'s purpose
echo is to give you a reasonable idea if your
echo diretories are set up correctly
echo

echo -e '\E[35m'"It is strongly recommended that you make backups!"
echo -e '\E[m'

#tput sgr0

echo This script should be run from the top-most
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

echo Copying generic XML and running merge...
#Just looking for folders with a file we have changed. The silent option here will say strange things
if [ $change = false ]; then
	echo This output will look incorrect. It\'s for my testing purposes.
	find -name '*.dat' |
	while read fn; do name=$(basename "$fn") ; dir=$(dirname "$fn") ; echo Copied merge1.xml to "$dir/$(basename "$dir").xml" ; echo ndm_mergedat "$dir/$(basename "$dir").xml" ; echo Renamed "$fn" as "$dir/$(basename "$dir").dat" ;done
else
#Holy run-on line, Batman
	find -name '*.analogin' |
	while read fn; do name=$(basename "$fn") ; dir=$(dirname "$fn") ; echo ; cp "../xml/merge1.xml" "$dir/$(basename "$dir").xml" ; echo Copied merge1.xml to "$dir/$(basename "$dir").xml" ; ndm_mergedat "$dir/$(basename "$dir").xml"; mv "$fn" "$dir/$(basename "$dir")-filtered.dat"; echo Renamed "$fn" as "$dir/$(basename "$dir")-filtered.dat"; mv "$dir/$(basename "$dir").dat" "$dir/$(basename "$dir")-wideband.dat" ;done
fi
echo

echo Copying generic XML and running merge again....
if [ $change = false ]; then
	echo Magic.
	# hue
else
	find -name '*.digitalout' |
	while read fn; do name=$(basename "$fn") ; dir=$(dirname "$fn") ; echo ; cp "../xml/merge2.xml" "$dir/$(basename "$dir").xml" ; echo Copied merge1.xml to "$dir/$(basename "$dir").xml" ; ndm_mergedat "$dir/$(basename "$dir").xml" ;done
fi

echo Whew! We made it!

#echo Changing channels in Acquisition System from 20 to 23...
#xml_suffix=".xml"
#if [ $change = false ]; then
#	find -name '*.xml'
#else
#	find -name '*.xml' |
#	while read fn; do dir=$(dirname "$fn") ; ./xml-edit "$dir/$dir$xml_suffix" /parameters/acquisitionSystem/nChannels "23" "$dir/$dir$xml_suffix" ;done
#fi
#echo



