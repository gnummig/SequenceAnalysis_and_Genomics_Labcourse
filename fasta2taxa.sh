#!/bin/sh -x

# replace the fasta header with gene ID only

if [ ! -e $1".taxa.fasta" ]
then
        while IFS= read -r HEADER
        do
                if [[ $HEADER =~ ">" ]]
                then
			ACC=$(echo $HEADER | cut -d " " -f1 | sed -E 's/>//' )
			TAXA=$( grep $ACC $1".TAXA_TABLE_clean.txt" )  

                       # echo $ACC | cut -f3 -d " " | sed -E 's/\[db_xref=GeneID:/>/g' | sed -E 's/\[db_xref=InterPro:/>/g' | sed -E 's/\]//g' >> $1".short"
		       LINE=">"$(echo $TAXA | cut -d " " -f4  | sed "s/[^[:alnum:].-]/_/g")"_"  
		       LINE=$LINE$(echo $TAXA | cut -d " " -f3 | sed "s/[^[:alnum:].-]/_/g")"_"  
		       LINE=$LINE$(echo $TAXA | cut -d " " -f2 | sed "s/[^[:alnum:].-]/_/g")"_"$2  
                        echo $LINE >> $1".taxa.fasta"

                else
                        echo $HEADER >> $1".taxa.fasta"
                fi
        done < $1
fi


