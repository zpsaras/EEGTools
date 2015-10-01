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

#Just testing stuff
<<"COMMENT"
find . -name '*.dat' |
while read fn; do
	name=$(basename "$fn")
	dir=$(dirname "$fn")
	echo
	echo "Searching for file named $name"
	find . -name $name |
	while read fn2; do
		echo
		dir2=$(dirname "$fn2")
		if [ $dir2 == $dir ]; then
			echo "Skipping repeat find..."
		else
			echo "Found new instance of $name"
			echo "This is where concat steps should be taken"
		fi
	done
done
COMMENT

echo
# STRIKE THE EARTH
FNAMEARR=()
find . -name '*.dat' > temp.txt
while read fn; do
	#name=$(basename "$fn")
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

for path in "${FNAMEARR[@]}"
do
	echo
	echo Working on "$path"
	echo ========================================================================
	find . -name $(basename "$path") |
	while read fn; do
		if [[ "$fn" != "$path" ]]; then
			echo Found "$fn"
		fi
	done
done
