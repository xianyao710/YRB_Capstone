#this directory contains all the needed scripts for the workflow and a sample data set in Homer format.
## Note (from TR):
   - need to explain what /sample and /scripts folders contain
   - How to run a example job? Please provide an explanation here also
   - Need to to mention (somewhere in the repo) what the dependencies are. For example, I had an issue because the approrpriate version of pydot2 wasn't installed
#MEME suite is pre-required to be installed, and the enviromental path for program `tomtom` should be added.
#motif2meme.R is the R script to convert motif into meme format
#GetCluster.py takes 1,2 column of tomtomt output to extract connected components
#extract`_`cluster.py produce motif meme format file given the motif names
#MotifReduce.pl generates consensus motifs
