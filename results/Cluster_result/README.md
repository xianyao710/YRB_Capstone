#Cluster`_`result contains all processed result for motif clustering
cluster`_`consensus contains consensus motif for each cluster

cluster`_`seqLogo contains figures of motif for each cluster consensus motif

all`_`train.meme is the MEME motif file produced from 10 training motif (using command cat train`*` `>` all`_`train.meme)

tomtom`_`out contains Tomtom output by using command
```
$tomtom -thresh 0.0001 -evalue all_train.meme all_train.meme
```
