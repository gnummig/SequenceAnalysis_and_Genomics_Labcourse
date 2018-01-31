#!/bin/bash
#if [ "$#" -le "3" ] ; then 
#	echo 'usage sort_raxml_tree.sh idlist intree outree'
#fi


#  a valid id : 1308989187
# grep -E 1308989187 namesheaders_clean.txt| cut -f3 | sed "s/[^[:alnum:].-]//g"
# the files i used ./sort_raxml_tree.sh Raxml_ids.txt namesheaders_clean.txt namesheaders_clean_sorted.txt
while IFS= read -r ID
do
	#get the third row and only alphanumerical things
	grep -E $ID $2 | cut -f2 | sed "s/ //g">> $3
	IDNAME=$(grep -E $ID $2 | cut -f3 | sed "s/[^[:alnum:].-]/_/g")
	IDTAX=$(grep -E $ID $2 | cut -f4 | sed "s/[^[:alnum:].-]/_/g")
	# append the ID to the end of the line 
	echo -e "$(cat $3)\t$IDTAX" > $3
	echo -e "$(cat $3)$IDNAME" > $3
	echo "$(cat $3)-$ID" > $3
	#sed '${s/$/'"$IDNAME"'/}' $3
	#sed '${s/$/-'"$ID"'/}' $3
done < $1

