#!/bin/bash
declare -i truncPos
declare -i i

#thanks to patrik @ StackOverflow
#0 for yes, 1 for no
containsElement () {
	local e
	for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
	return 1
}

containsBasename () {
	local e
	for e in "${@:2}"; do [[ $(basename "$e") == $(basename "$1") ]] && return 0; done
	return 1
}

originalWD=$(pwd)
echo Original working directory: "$originalWD"
echo
# STRIKE THE EARTH
FNAMEARR=()
find "$originalWD" -name '*.dat' > temp.txt
while read fn; do
	containsBasename "$fn" "${FNAMEARR[@]}" 
	if [ $? == 1 ]; then
		# Does not exist in array
		FNAMEARR=("${FNAMEARR[@]}" "$fn")
	fi
done < temp.txt

echo Non-duplicate list of filenames.
echo These will be used as search parameters.
echo ==========================================================================
printf '%s\n' "${FNAMEARR[@]}"
echo
echo Beginning Concatenation\(s\)...
echo

# STEPS
# Copy similar DAT files to new folder, e.g., WSC005PRT-concat
	# Find all identically-named DAT files
	# Copy folders to new folder
# Copy concat xml to new folder
# Run "ndm_start concatenate.xml ./" from new folder
# Finally, make sure to copy XML containing Colors by Julia(tm)

datSuffix=".dat"

for path in "${FNAMEARR[@]}"
do
	i=1
# Create folder for completed files
	cd "$(dirname "$path")/.."
	mkdir "$(pwd)"/$(basename "$path" .dat)-concat
	mkdir "$(pwd)"/$(basename "$path" .dat)-concat/dat
	# Copy concat xml
	cp "$originalWD"/xml/concatenate.xml "$(pwd)"/$(basename "$path" .dat)-concat
	echo
	echo Working on "$path"
	echo ========================================================================
	find "$originalWD" -name $(basename "$path") |
	while read fn; do
		if [[ "$fn" != "$path" ]]; then
			i=$i+1
			echo Found "$fn". Move...
			#mv $(dirname "$fn") "$(pwd)"/$(basename "$path" .dat)-concat
			mv "$fn" "$(pwd)"/$(basename "$path" .dat)-concat/dat/$(basename "$path" .dat)$i$datSuffix
		fi
	done
# Copy original path to new folder
	#mv $(dirname "$path") "$(pwd)"/$(basename "$path" .dat)-concat
	mv "$path" "$(pwd)"/$(basename "$path" .dat)-concat/dat/$(basename "$path" .dat)$i$datSuffix
	cd "$(pwd)"/$(basename "$path" .dat)-concat
	ndm_start concatenate.xml
	cd "$originalWD"
done

