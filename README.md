# Horizontal gene transfer

these scripts are used to build a phylogenetic tree based on on a Blast search of a given protein.

the blast search still has to be done manually on the website, but the rest should work mostly automatic.

there is some heavy renaming of the fasta headers happening here, because someone thought that the raxml program only takes strict 10 digit headers.this turned out to be not necessary, this script does it anyway.

## usage
### building a tree
place the sequence dump from the blast in a subfolder of this one.

call 
```
treebuild.sh subfolder/sequencedump
```

to use Gblock too filter out noise and badly aligned columns from the alignment, stop the treebuild when the RAxML is running, and execute the wrapper:

``` 
gblockWrapper.sh subfolder/sequencedump
```
then call the treebuild again to continue to build the tree with the shortened alignment.

### renaming the tree
 
 
```
treeRename.sh  subfolder/sequencedump
```
it might produce an unexpected end of file error, just call it again, and it will continue as intended.


