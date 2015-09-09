#!/bin/bash

currentdir=${PWD##*/}

echo
echo ==========
echo EEG STEP 1
echo ==========
echo Written by Zach Psaras for the Suzuki lab @ NYU
echo
echo Checking for required tools...

if [ ! -x ./xml-edit ]; then
	echo -e '\E[31m'"Missing xml-edit! Aborting"
	tput sgr0
	exit
fi

echo -e '\E[35m'"It is strongly recommended that you have a backup of the original files."

tput sgr0

echo This script requires that you have opened amplifier.dat at least once

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

echo Checking for lies...

if [ ! -f ./amplifier.xml -a ! -f ./amplifier.nrs ]; then
	echo -e '\E[31m'"Missing settings files. Are you sure you opened amplifier.dat?. Aborting"
	tput sgr0
	exit
fi


if [ -f ./supply.dat ]; then
	echo Found supply.dat
	mv ./supply.dat ./supply.supply
	echo Renamed supply.dat to supply.supply
else
	echo Could not find supply.dat.
fi

if [ -f ./time.dat ]; then
	echo Found time.dat
	mv time.dat time.time
	echo Renamed time.dat to time.time
else
	echo Could not find time.dat
fi

if [ -f ./amplifier.dat ]; then
	echo Found amplifier.dat
	mv ./amplifier.dat $currentdir-wideband.dat
	echo Renamed amplifier.dat to $currentdir-wideband.dat
else
	echo Could not find amplifier.dat
fi

if [ -f ./auxiliary.dat ]; then
	echo Found auxiliary.dat
	mv auxiliary.dat $currentdir-filtered.dat
	echo Renamed auxiliary.dat to $currentdir-filtered.dat
else
	echo Could not find auxiliary.dat
fi

if [ -f ./digitalout.dat ]; then
	echo Found digitalout.dat
	digitalout_suffix=".digitalout"
	mv digitalout.dat $currentdir$digitalout_suffix
	echo Renamed digitalout.dat to $currentdir$digitalout_suffix
else
	echo Could not find digitalout.dat
fi

if [ -f ./analogin.dat ]; then
	echo Found analogin.dat
	analogin_suffix=".analogin"
	mv analogin.dat $currentdir$analogin_suffix
	echo Renamed analogin.dat to $currentdir$analogin_suffix
else
	echo Could not find analogin.dat
fi

if [ -f ./amplifier.nrs ]; then
	echo Found amplifier.nrs
	nrs_suffix=".nrs"
	mv amplifier.nrs $currentdir$nrs_suffix
	echo Renamed amplifier.nrs to $currentdir$nrs_suffix
else
	echo Could not find amplifier.nrs
	echo Somethingsomethingsomething
fi

if [ -f ./amplifier.xml ]; then
	echo Found amplifier.xml
	xml_suffix=".xml"
	mv amplifier.xml $currentdir$xml_suffix
	echo Renamed amplifier.xml to $currentdir$xml_suffix
else
	echo Could not find amplifier.xml
fi

echo Changing channels in Acquisition System from 20 to 23...
./xml-edit $currentdir$xml_suffix /parameters/acquisitionSystem/nChannels "23" $currentdir$xml_suffix
