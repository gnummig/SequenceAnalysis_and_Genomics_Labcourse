#!/bin/sh -x
./Gblocks $1".GI_headers.nr90.aln.fasta" -b4=2 -b5=a -e=.gbl 
# remove the phylip file so that the treebuild script redoes conversion 
rm $1".GI_headers.nr90.aln.phy"
# thanks Gblock for inserting all the whitespaces, but we dont need them
sed  -E 's/ //g' $1".GI_headers.nr90.aln.fasta.gbl" > $1".GI_headers.nr90.aln.fasta"

