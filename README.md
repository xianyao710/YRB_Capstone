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
Tomtom is the software package included in MEME suite to do comparsion of motifs against known motif databases or motifs provided by users.You can find a sample output under /data directory.<br/>
<pre><code/>$cut -f 1,2 tomtom.txt > raw_adjlist
</code></pre>
##Using python package networkx to cluster motifs
Here we ultilize the well developed python package [networkx](http://networkx.github.io) to analyze our motifs<br/>
<pre><code>
	$python<br/>
	>>>import networkx as nx<br/>
	>>>G=nx.read_adjlist("raw_adjlist",nodetype=str)
	>>>len(G.nodes())<br/>
	>>>228 #number of initial nodes<br/>
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
</code></pre>
	   

##Run MotifSetReduce.pl to generate consensus motifs

Codes can be found under directory [MotifSetReduce](https://github.com/BrendelGroup/bghandbook/tree/master/demo/MotifSetReduce).<br/>
<pre><code>
$for file in ls Motif_group*.txt;do ./MotifSetReduce.pl -m $file > $file.consensus ;done
</code></pre>

##Results and discussion


