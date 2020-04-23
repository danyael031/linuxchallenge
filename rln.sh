#!/bin/bash

# The function to generate each line of random characters its designed to 
# take 128 bytes form /dev/urandom and filter it to only get alhpanumeric
# ascii characters. If we don't get the 15 alphanumeric bytes in the first iteration,
# we will get more bytes in te next iteration to accomplish the number of
# characters per line. This solution can be more eficient than those that 
# use a delimiter character from a random output.

randomline(){
strln=""
while (( ${#strln} < 15 )); do
	strln=${strln}$(head -c 128 /dev/urandom | tr -dc 'a-zA-Z0-9' )
done
echo "${strln:0:15}\n"
}

# To control the file size we can write each line to the destination file 
# with output redirection:
# $ randomline >> output
# and verify the size of the file in bytes with the commands du:
# $ size=$(du -b ./output | cut -f1 )
# or ls:
# $ size=$(ls -l ./output | cut -d ' ' -f5 )
# But we dont need to verify the size of the file each line.
#
# If we have an static number of characters per line, 15, plus the Line Feed
# character, 16, we can simply calculate the number of lines we need to reach 
# 1MB of size.
#
# 1MB = 1,048,576 Bytes
# 1,048,576 Bytes / 16 Bytes = 65,536 iterations
#
# we only need to iterate the function 65,356 times.
# This method is more efficient because it only needs to
# store the file in ram before write it and doesn't take time to read
# from disk.

echo "File in progress.."
randfile=""
for (( i = 0 ; i < 65536 ; i++ )) ; do
	randfile=${randfile}$(randomline)
done

echo -ne $randfile > output

echo "File done"

echo "Sorting and filtering"

# In this case, I don't have specific preference of sorting type. Default
# sort is enough to get a good view of alphanumeric random elements cause
# can get numeric and alphabetical order.
# if we take another option, like dictionary, doesn't get different output
# because there is only alphanumerics, and general numeric sort seems
# messy.

sort ./output | grep -iv ^a > output_sort_grep 

# Compare lines
linesorigin=$( wc -l ./output | cut -d' ' -f1 )
linesfiltered=$( wc -l ./output_sort_grep | cut -d' ' -f1 )
difflines=$(( $linesorigin - $linesfiltered   ))

echo "Removed lines: $difflines"

