#!/bin/bash

randomline(){
strln=""
while (( ${#strln} < 15 )); do
	strln=${strln}$(head -c 128 /dev/urandom | tr -dc 'a-zA-Z0-9' )
done
echo ${strln:0:15}
}

for (( i = 0 ; i < 100 ; i++ )) ; do
	randomline
done

	
