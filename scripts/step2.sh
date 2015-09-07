#!/bin/bash

currentdir=${PWD##*/}

echo EEG STEP 2
echo ==========
echo
echo Checking for required tools...

if [ ! -x ./xml-edit ]; then
	echo -e '\E[31m'"Missing xml-edit! Aborting"
	tput sgr0
	exit
fi

echo This script assumes you have loaded both ndm_mergedat and ndm_start
echo and configured them both properly.

read -r -p "Have you done this? [y/N] " response

case $response in
	[yY][eE][sS]|[yY])
		# Continue
		;;
	*)
		echo Aborting
		exit
		;;
esac

echo Running ndm_mergedat
xml_suffix=".xml"
ndm_mergedat $currentdir$xml_suffix

echo Renaming .analogin file
analogin_suffix=".analogin"
mv $currentdir$analogin_suffix $currentdir-filtered.dat

echo Renaming .dat file
dat_suffix=".dat"
mv $currentdir$dat_suffix $currentdir-wideband.dat

echo Changing channels in Acquisition System from 20 to 29...
./xml-edit $currentdir$xml_suffix /parameters/acquisitionSystem/nChannels "23" $currentdir$xml_suffix

echo TODO: Change nChannels in ndm_merge from 20 3 to 23 6

echo Running ndm_mergedat
ndm_mergedat $currentdir$xml_suffix

echo Done!

echo If you experience any issues, please let me know ASAP.
