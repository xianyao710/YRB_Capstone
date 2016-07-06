bin folder contains the basic tools that are needed to conduct our workflow
-----------------------------------------------------------------------------
This workflow aims to retrieve non-redundant motifs from HOMER motif input.
-----------------------------------------------------------------------------
MEME suite is required to be installed, and the enviromental path for program `tomtom` should be added to ~/.bash_profile.

motif2meme.R is the R script to convert motif from HOMER to meme format.

GetCluster.py takes 1,2 column of tomtom.txt to extract highly connected subgraphs

extract_cluster.py produces motifs in meme format if motif names file provided.

MotifReduce.pl generates consensus motifs based on calculating distance between motifs and recursively merge of motifs.
