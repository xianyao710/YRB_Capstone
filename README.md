#Identify Consensus Motifs from Tomtom Results
Here we present our workflow to generate consensus motifs from motif pairwise comparison results done by Tomtom.

Work Flow
Tomtom results(pair-wise comparison of motifs)
		| \s\s
 		| graph analysis and cluster by degree \s\s
		| \s\s
	cluster groups of motifs \s\s
		| \s\s
		| Run MotifSetReduce.pl \s\s
		| \s\s
	generate consensus motif for each group \s\s

##Tomtom results
Tomtom is the software package included in MEME suite to do comparsion of motifsagainst known motif databases or motifs provided by users


##Using python package networkx to cluster motifs

##Run MotifSetReduce.pl to generate consensus motifs
