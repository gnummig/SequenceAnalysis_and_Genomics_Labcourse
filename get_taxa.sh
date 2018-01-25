# ------------------------------------------------------------------------------------------------------------------------- #
# USAGE instructions and indications:                                                                                       #
# This script makes a loop to call (from a https link) all info from a specific ACEESION number and get all the info        #
# related to. However, here the script get specific lines related to the taxonomic classification.                          #
# Filling required all gene IDs: Introduce all gene names of from a source (e.g. tree from ncbi) to get the taxonomy info   #
# of the genes in the tree or any source you require. Gene IDs most be separated by "one space".                            #
# This script is only a test and require more detailed parsing code.                                                        #
#                                                                                                                           #
#                                                                                                                           #
# EXECUTABLE FILE:                                                                                                          #
#   Change the file persmission typing in the commnad line (in your working directory "phylogenetics"):                     #
#           chmod 0700 get_taxa.sh                                                                                          #
#                                                                                                                           #
# Run script: ./get_taxa.sh                                                                                                 #
#                                                                                                                           #
#                                                                                                                           #
#  WARNINGS:                                                                                                                #
# Why this program is not working?                                                                                          #
#   - There is something wrong with the fasta headers (see below).                                                          #
#   - There is one or more fasta annotation not detected in NCBI.                                                           #
#   - There is something wrong in the code...                                                                               #
#   - something was deleted unpurpose...                                                                                    #
#                                                                                                                           #
#  May be you will find these conflicting "fasta headers" annotation (see explanation below).                               #
#  pdb|1VI6|A   change to:  1VI6                                                                                            #
#  pdb|1VI5|A   change to:  1VI5                                                                                            #
#  pir||F64422  change to:  1VI5                                                                                            #
# ------------------------------------------------------------------------------------------------------------------------- #

echo -n -e "ACCESSION\tGI_number\tOrganism\tTaxonomy\n"

# PASTE your ACCESSION number list (point 6) from your pipe-line output:
while IFS= read -r ACC
do
    echo -n -e "$ACC\t"
    curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&id=${ACC}&rettype=gp&retmode=xml" |\

    # Get specific information:
    grep -E 'GBSeqid>gi|GBSeq_organism|GBSeq_taxonomy' |\

    # parsing lines:
    sed -E 's/\<GBSeqid\>//g' |\
    sed -E 's/\<\/GBSeqid\>//g' |\
    sed -E 's/\<GBSeq_organism\>//g' |\
    sed -E 's/\<\/GBSeq_organism\>//g' |\
    sed -E 's/\<GBSeq_taxonomy\>//g' |\
    sed -E 's/\<\/GBSeq_taxonomy\>//g' |\
    sed -E 's/\gi\|//g' |\
    sed -E 's/\gi\|//g' |\

    tr '\n' '\t'
    # additional parsing lines (if you want...)
    # ...
    # ...
   echo
done < $1



# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = #
# Additional NOTES:
#
# WARNING SECTION:
#   * ABOUT conflicting "fasta headers": gene annotations sometimes are complex, in some cases they are based on other
#           other databases, e.g. Protein Data Bank (pdf) or Protein Informaiton Resource (pir). These three noise
#           annotations have this problem. HINT: If you are curious, go to NCBI (https://www.ncbi.nlm.nih.gov/protein/)
#           and paste any of these three examples as they are and see the (ACCESSION) annotation.
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = #


