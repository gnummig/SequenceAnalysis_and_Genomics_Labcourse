#!/bin/sh -x

echo "creating new fasta with short headers, ie keep the accesion nummbers"
cut -d " " -f1 $1 > $1".new_headers.fasta" 
echo "getting list of blank headers to search for the taxa"
grep ">" $1".new_headers.fasta" | sed -E 's/>//'  > $1".HEADERS"
# getting taxa from the internet
if [ ! -e $1".TAXA_TABLE.txt" ] 
then 
	date +%T
	echo 'getting taxa from NCBI'
	./get_taxa.sh $1".HEADERS" > $1".TAXA_TABLE.txt" &&
	date +%T

fi
sed -E 's/<>//g' $1".TAXA_TABLE.txt" | sed -E 's/\;//g' | sed -E 's/<\/>//g' | sed -E 's/ //g' > $1".TAXA_TABLE_clean.txt"
#./clean_taxa.sh $1".TAXA_TABLE.txt" > $1".TAXA_TABLE_clean.txt"
if false
#if [ ! -e $1".taxa_headers.fasta" ] 
then 
	echo 'swapping the fasta header'
	perl change_fasta_headers.pl  $1".new_headers.fasta"  $1".TAXA_TABLE_clean.txt" >  tmp &&
	mv tmp $1".taxa_headers.fasta"
fi
if [ ! -e $1".taxa.fasta" ]
then 
	echo please run 
       	echo fasta2taxa.sh $1 \<LABEL\>	
	exit
fi
#reduce redundency
if [ ! -e $1".taxa.n90.fasta" ] 
then 
	echo " reduce redundency at 90% of similarity"	
	cd-hit -i $1".taxa.fasta" -o  tmp -c 0.90 &&
	mv tmp  $1".taxa.n90.fasta"
fi
# make a multiple sequence alignment
if [ ! -e $1".taxa.nr90.aln.fasta" ] 
then
	echo make a multiple sequence alignment
	mafft $1".taxa.n90.fasta" > tmp &&
	mv tmp $1".taxa.nr90.aln.fasta" 
fi
# fasta to phylip 
if [ ! -e $1".taxa.nr90.aln.phy" ]
then
	perl Fasta2Phylip.pl  $1".taxa.nr90.aln.fasta"  $1".taxa.nr90.aln.phy"
fi 
if [ ! -e $1".taxa.nr90.aln.phy" ]
then
	echo please go to the internet and convert the fasta to a phylip, as the perl converter fails
	exit
fi
## RAxML
if [ ! -e  $1"RAxML_result" ] 
then 
	echo starting RAxML
	date +%T
	raxmlHPC-PTHREADS-SSE3 -T 3 -m PROTGAMMAWAG -s $1".taxa.nr90.aln.phy" -n tmp -p 12345 &&
	mv RAxML_info.tmp  $1".RAxML_info" &&
	mv RAxML_log.tmp $1".RAxML_log" &&
	mv RAxML_bestTree.tmp $1".RAxML_bestTree" &&
	mv RAxML_result.tmp $1".RAxML_result" &&
	mv RAxML_parsimonyTree.tmp $1".RAxML_parsimonyTree"
	echo finished RAxML
	date +%T
fi
# prottest3
echo prottest3
if false  
#if [ ! -e  $1".taxa.nr90.aln.prottest_output.txt" ] 
then 
	echo starting prottest3
	date +%T
	java -jar /home/a/documents/uni_module/genomik/Labcourse/phylogenetics/prottest-3.4.2/prottest-3.4.2.jar -i $1".taxa.nr90.aln.fasta" -all-distributions -F -AIC -tc 0.5 -threads 3 -o tmp > $1".taxa.nr90.aln.prottest_errors.txt"
	mv tmp $1".taxa.nr90.aln.prottest_output.txt"
	date +%T
fi
echo 
#if false
# Make a maximum likelihood search and bootstrap analysis at once:
# raxmlHPC-PTHREADS -f a -m PROTGAMMAWAG -p 12345 -x 12345 -# 20 -s myExample.aln.phy -n myExample.aln.20_bootstrapping.tree -T 4
if [ ! -e  $1"bootstrap.RAxML_result" ] 
then 
	echo starting bootstrap RAxML
	date +%T
	raxmlHPC-PTHREADS-SSE3 -T 3 -f a -# 100 -m PROTGAMMAWAG -s $1".taxa.nr90.aln.phy" -n tmp2 -x 12345 -p 12345 &&
	mv RAxML_info.tmp2  $1".bootstrap.RAxML_info" &&
	mv RAxML_log.tmp2 $1".bootstrap.RAxML_log" &&
	mv RAxML_bestTree.tmp2 $1".bootstrap.RAxML_bestTree" &&
	mv RAxML_result.tmp2 $1".bootstrap.RAxML_result" &&
	mv RAxML_parsimonyTree.tmp2 $1".bootstrap.RAxML_parsimonyTree"
	echo finished bootstrap RAxML
	date +%T
fi
