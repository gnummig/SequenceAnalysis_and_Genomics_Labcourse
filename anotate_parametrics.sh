#!/bin/bash



while IFS= read -r ACC
do
	if grep -q -E "Laccaria" $ACC 
        	echo -e "HGT\t$ACC" >> $2
	else 
        	echo -e "HOST\t$ACC" >> $2
	fi
done < $1
# now it is left to rename the headerline too CLASS
