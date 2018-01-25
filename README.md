# Horizontal gene transfer

these scripts are used to build a phylogenetic tree based on on a Blast search of a given protein.

the blast search still has to be done manually on the website, but the rest should work mostly automatic.

there is some heavy renaming of the fasta headers happening here, because someone thought that the raxml program only takes strict 10 digit headers.this turned out to be not necessary, this script does it anyway.

## usage
place the sequence dump from the blast in a subfolder of this one.

call 
```
treebuild.sh subfolder/sequencedump
```

use Gblock too filter out noise from the alignment:

``` 
gblockWrapper.sh subfolder/sequencedump
```

