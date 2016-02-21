#Identify consensus motifs from Tomtom results
Here we present our workflow to generate consensus motifs from motif pairwise comparison results done by Tomtom.

##Work flow
Tomtom results(extractpair-wise comparison of motifs) <br/>
                ||<br/>
                || graphic analysis and cluster motifs by degree <br/>
                ||<br/>
        groups of clustered motifs in MEME format <br/>
                || <br/>
                || Run MotifSetReduce.pl <br/>
                || <br/>
        consensus motif for each group <br/>

##Tomtom results
Tomtom is the software package included in MEME suite to do comparsion of motifs against known motif databases or motifs provided by users.You can find a sample output under /data directory.<br/>
<pre><code/>$cut -f 1,2 tomtom.txt > raw_adjlist
</code></pre>
##Using python package networkx to cluster motifs
Here we ultilize the well developed python package [networkx](http://networkx.github.io) to analyze our motifs.After running the commands below, we generated a new graph containing 8 connected components that represent 8 motif clusters<br/>. 
<pre><code>
	$python<br/>
	>>>import networkx as nx<br/>
	>>>G=nx.read_adjlist("raw_adjlist",nodetype=str)
	>>>len(G.nodes())<br/>
	>>>228<br/>
	>>>len(G.edges())<br/>
	>>>647 #number of initial edges <br/>
	>>>for node in G.nodes():<br/>
	...		if nx.degree(G,node)<=9:<br/>
	...  				G.remove_node(node)<br/>
	>>>for node in G.nodes():<br/>
	...			G.remove_edge(node,node)<br/>
	>>>len(G.nodes())<br/>
	>>>44<br/>
	>>>len(G.edges())<br/>
	>>>176<br/>
	>>>nx.write_adjlist(G,"motif_cluster")
</code></pre>
	   

##Run MotifSetReduce.pl to generate consensus motifs 
For this step, we extract the motifs for each group in MEME format and then run MotifSetReduce.pl to produce consensus motifs.
Codes can be found under directory [MotifSetReduce](https://github.com/BrendelGroup/bghandbook/tree/master/demo/MotifSetReduce).<br/>
<pre><code>
$for file in ls Motif_group*.txt;do ./MotifSetReduce.pl -m $file > $file.consensus ;done
</code></pre>

##Results and discussion
The initial Tomtom file contains 228 motifs. By taking each steps in this workflow, we generate 8 clusters of motifs and extract the convert them in MEME format.(under /data directory motif_group[index].txt ).By comparing the inital Tomtom graph and processed graph, we confirmed that these clusters are the connected components that every node in each group has degree more than 8. After having 8 groups of motifs,we generate consensus motif for each group shown in PFM format.The predicted consensus motifs are presented in the order of IC(information content) value. And the motifs with max IC are plotted in R using package seqLogo. The consensus motif files are named VB_[group_index].txt and the seqLogo files are located in /results directory.


