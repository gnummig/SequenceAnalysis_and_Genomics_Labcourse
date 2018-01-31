#!/bin/sh -x
# this probably doesnt work as raxml puts the files in the dir where it is executed

nw_labels $1".RAxML_result" > $1".RAxML_result_ids"
# rename the labels

./sort_raxml_tree.sh $1".RAxML_result_ids" $1".TAXA_TABLE_clean.txt" $1".RAxML.TAXA_TABLE_clean_sorted.txt"
#put the new labels to the tree
nw_rename $1".RAxML_result" $1".RAxML.TAXA_TABLE_clean_sorted.txt" > $1".RAxML_result.sorted.tree"
# process the 
if [ -e $1".bootstrap.RAxML_result" ]
then 
	nw_labels $1".bootstrap.RAxML_result" > $1".bootstrap.RAxML_result.ids"
	# rename the labels
	./sort_raxml_tree.sh $1".RAxML_result_ids" $1".TAXA_TABLE_clean.txt" $1".RAxML.TAXA_TABLE_clean_sorted.txt"
#put the new labels to the tree
nw_rename $1".RAxML_result" $1".RAxML.TAXA_TABLE_clean_sorted.txt" > $1".RAxML_result.sorted.tree"
fi
