#Identify Consensus Motifs from Tomtom Results
Here we present our workflow to generate consensus motifs from motif pairwise comparison results done by Tomtom.

Work Flow
Tomtom results(pair-wise comparison of motifs)
		|
 		| graph analysis and cluster by degree
	cluster groups of motifs
		|
		| Run MotifSetReduce.pl
	generate consensus motif for each group

##Tomtom results
Tomtom is the software package included in MEME suite to do comparsion of motifsagainst known motif databases or motifs provided by users


##Using python package networkx to cluster motifs

##Run MotifSetReduce.pl to generate consensus motifs
