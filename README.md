#Identify consensus motifs from Tomtom results
Here we present our workflow to generate consensus motifs from motif pairwise comparison results done by Tomtom.

##Work flow
Tomtom results(pair-wise comparison of motifs) <br/>
                ||<br/>
                || graphic analysis and cluster motifs by degree <br/>
                ||<br/>
        groups of clustered motifs <br/>
                || <br/>
                || Run MotifSetReduce.pl <br/>
                || <br/>
        consensus motif for each group <br/>

##Tomtom results
Tomtom is the software package included in MEME suite to do comparsion of motifs against known motif databases or motifs provided by users


##Using python package networkx to cluster motifs
Here we ultilize the well developed python package [networkx](http://networkx.github.io) to analyze our motifs<br/>
   Code
   

##Run MotifSetReduce.pl to generate consensus motifs

Codes can be found under directory [MotifSetReduce](https://github.com/BrendelGroup/bghandbook/tree/master/demo/MotifSetReduce).



