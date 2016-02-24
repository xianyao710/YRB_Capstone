#Identify consensus motifs from Tomtom results
Here we present our workflow to generate consensus motifs from motif pairwise comparison results done by Tomtom.

##Work flow
[raw Homer output](https://github.com/xianyao710/YRB_Capstone/blob/master/data/Train_motifs_all.txt)<br/>
||<br/> [R script](https://gist.github.com/rtraborn/e395776b965398c54c4d#file-motif2meme-r) convert to MEME format<br/>
||<br/>
||[10 training groups](https://github.com/xianyao710/YRB_Capstone/blob/master/data/Train_motifs_combined.meme)  of motifs in MEME format<br/>
				||<br/>
				||run [Tomtom](http://meme-suite.org/tools/tomtom),compare motifs against themselves<br/>
				||<br/>
[Tomtom results](https://github.com/xianyao710/YRB_Capstone/blob/master/data/tomtom.txt)(extract pair-wise comparison of motifs) <br/>
                ||<br/>
                || graphic analysis and cluster motifs by degree <br/>
                ||<br/>
        [extract clustered motifs](https://github.com/xianyao710/YRB_Capstone/tree/master/results) in MEME format (motif_group[1-8].txt)<br/>
                || <br/>
                || Run [MotifSetReduce.pl](https://github.com/BrendelGroup/bghandbook/blob/master/demo/MotifSetReduce/MotifSetReduce.pl) <br/>
                || <br/>
        generate [consensus motif](https://github.com/xianyao710/YRB_Capstone/tree/master/results) for each group (VB_group[1-8].txt,seqLogo for each group[1-8].png)<br/>
        
##Convert Homer result to MEME format

<pre><code>
some lines of Homer result
>VTATAAAARNNN	1-VTATAAAARNNN	8.274038	-655.070354	0	T:1116.0(7.30%),B:329.9(1.00%),P:1e-284	Tpos:25.7,Tstd:9.3,Bpos:51.7,Bstd:27.2,StrandBias:10.0,Multiplicity:1.00
0.333	0.302	0.311	0.054
0.001	0.001	0.001	0.997
0.965	0.001	0.001	0.033
0.003	0.001	0.001	0.995
0.995	0.001	0.001	0.003
0.624	0.001	0.001	0.374
0.997	0.001	0.001	0.001
0.590	0.001	0.186	0.223
0.371	0.122	0.347	0.160
0.240	0.290	0.290	0.181
0.268	0.279	0.277	0.175
0.281	0.260	0.277	0.182
>NNKCAGTYDN	1-NNKCAGTYDN	5.053783	-652.158774	0	T:5657.0(36.99%),B:6968.1(21.22%),P:1e-283	Tpos:51.8,Tstd:20.1,Bpos:50.6,Bstd:35.5,StrandBias:10.0,Multiplicity:1.18
0.245	0.261	0.226	0.268
0.288	0.199	0.281	0.232
0.192	0.162	0.284	0.361
0.001	0.997	0.001	0.001
0.976	0.001	0.001	0.022
0.001	0.001	0.826	0.172
0.398	0.001	0.001	0.600
0.267	0.434	0.001	0.298
0.257	0.155	0.332	0.255
0.266	0.227	0.259	0.248

Then in R
>source("https://github.com/xianyao710/YRB_Capstone/blob/master/scripts/motif2meme.R")
>motif2meme("I692/YRB_Capstone/data/Train_motifs_all.txt")
We generate the motif file in MEME format, and few head lines are shown here<br/>
MEME version 4

ALPHABET= ACGT

strands: + -

MOTIF motif_Train1_1 1-VTATAAAARNNN 
letter-probability matrix: alength= 4 w= 12 nsites= 20 E= 1e-284 
0.333	0.302	0.311	0.054
0.001	0.001	0.001	0.997
0.965	0.001	0.001	0.033
0.003	0.001	0.001	0.995
0.995	0.001	0.001	0.003
0.624	0.001	0.001	0.374
0.997	0.001	0.001	0.001
0.59	0.001	0.186	0.223
0.371	0.122	0.347	0.16
0.24	0.29	0.29	0.181
0.268	0.279	0.277	0.175
0.281	0.26	0.277	0.182

MOTIF motif_Train1_2 1-NNKCAGTYDN 
letter-probability matrix: alength= 4 w= 10 nsites= 20 E= 1e-283 
0.245	0.261	0.226	0.268
0.288	0.199	0.281	0.232
0.192	0.162	0.284	0.361
0.001	0.997	0.001	0.001
0.976	0.001	0.001	0.022
0.001	0.001	0.826	0.172
0.398	0.001	0.001	0.6
0.267	0.434	0.001	0.298
0.257	0.155	0.332	0.255
0.266	0.227	0.259	0.248



</code></pre>

##Tomtom results
Tomtom is the software package included in MEME suite to do comparsion of motifs against known motif databases or motifs provided by users. Here, we use [HomerResultinMEME format](https://github.com/xianyao710/YRB_Capstone/blob/master/data/Train_motifs_combined.meme) motifs as query and target to do comparison against themselves.You can use the webbased Tomtom tool or run the command line version of Tomtom.<br/>
<pre><code>
$tomtom Train_motifs_combined.meme (as query)Train_motifs_combined.meme(as target)
</code></pre>
And a directroy named tomtom_out will be produced with output in all format here.We will just use tomtom.txt,the plain text format. Some lines of the result file [tomtom.txt](https://github.com/xianyao710/YRB_Capstone/blob/master/data/tomtom.txt) are shown below.<br/>


<pre><code/>
#Query ID	Target ID	Optimal offset	p-value	E-value	q-value	Overlap	Query consensus	Target consensus	Orientation
motif_Train1_1	motif_Train1_1	0	5.84779e-25	1.3333e-22	2.62122e-22	12	ATATAAAAAGCA	ATATAAAAAGCA	+
motif_Train1_1	motif_Train9_1	0	2.07887e-23	4.73982e-21	4.65917e-21	12	ATATAAAAAGCA	ATATAAAAAGAG	+
motif_Train1_1	motif_Train6_1	0	7.56357e-18	1.72449e-15	8.47576e-16	12	ATATAAAAAGCA	GTATAAAAAGGG	+
motif_Train1_1	motif_Train7_1	0	7.56357e-18	1.72449e-15	8.47576e-16	12	ATATAAAAAGCA	GTATAAAAAGGG	+
motif_Train1_1	motif_10_1	0	1.94365e-17	4.43152e-15	1.74245e-15	12	ATATAAAAAGCA	GTATAAAAAGGG	+
motif_Train1_1	motif_Train3_1	0	4.64279e-17	1.05856e-14	2.97299e-15	12	ATATAAAAAGCA	GTATAAAAAGGG	+
motif_Train1_1	motif_Train5_1	0	4.64279e-17	1.05856e-14	2.97299e-15	12	ATATAAAAAGCA	GTATAAAAAGCG	+
motif_Train1_1	motif_Train4_1	0	2.20983e-16	5.03841e-14	1.23817e-14	12	ATATAAAAAGCA	GTATAAAAAGCG	+
motif_Train1_1	motif_Train8_2	0	3.84316e-14	8.76241e-12	1.91407e-12	12	ATATAAAAAGCA	GTATAAAAGGGG	+
motif_Train1_1	motif_Train2_1	0	2.77109e-08	6.31808e-06	1.24212e-06	10	ATATAAAAAGCA	GTATAAAAGG	+
motif_Train1_2	motif_Train1_2	0	2.60172e-24	5.93193e-22	1.13361e-21	10	TATCAGTCGA	TATCAGTCGA	+

$cut -f 1,2 tomtom.txt > raw_edgelist
</code></pre>
Since we want to construct graph for these motifs, we extracted the first two columns and append them to a new file [raw_edgelist](https://github.com/xianyao710/YRB_Capstone/blob/master/results/raw_edgelist).
##Using python package networkx to cluster motifs
Here we ultilize the well developed python package [networkx](http://networkx.github.io) to analyze our motifs.Input is the raw_adjlist file from last step.After running the commands below, we generated a new graph containing 8 connected components that represent 8 motif clusters<br/>. Using [raw_edgelist](https://github.com/xianyao710/YRB_Capstone/blob/master/results/raw_edgelist) as input, we produce a subgraph that contains [8_cluster](https://github.com/xianyao710/YRB_Capstone/blob/master/results/8_cluster).([8_clusters_adjlist](https://github.com/xianyao710/YRB_Capstone/blob/master/results/8_clusters_adjlist),picture for this subgraph [8_clusters.png](https://github.com/xianyao710/YRB_Capstone/blob/master/results/8_clusters.png)) 
<pre><code>
$python
>>>import networkx as nx
>>>import matplotlib.pyplot as plt#this package is needed for drawing
>>>G=nx.read_edgelist("raw_edgelist",nodetype=str)
>>>len(G.nodes())
228
>>>len(G.edges())
>>>647 #number of initial edges
>>> for node in G.nodes():#remove line that ends where it starts
...		if (node,node) in G.edges():
...     	G.remove_edge(node,node)
>>> len(G.nodes())
228
>>> len(G.edges())
419
>>> nx.number_connected_components(G)
82
>>> [len(c) for c in sorted(nx.connected_components(G),key =len)]
[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 7, 8, 9, 9, 10, 10, 10, 10, 10, 10]   
>>>graphs = list(nx.connected_component_subgraphs(G))
>>>cluster = []
>>>for each in graphs:
...		if len(each)>=9:
...			cluster.append(each)
>>>len(cluster)
8
>>>output=nx.Graph()#create a empty graph for output
>>>for each in cluster:
...		output = nx.union(output,each)
>>>nx.draw(out)
>>>plt.show()
>>>nx.write_adjlist(output,"8_clusters_adjlist")
>>>nodes=[]#the list of nodes for these 8 clusters 
>>>for each in cluster:
...		nodes.append(each.nodes())
>>>nodes
[['motif_Train8_9', 'motif_Train1_10', 'motif_Train4_16', 'motif_Train9_12', 'motif_Train6_17', 'motif_Train3_12', 'motif_Train7_6', 'motif_10_14', 'motif_Train2_13', 'motif_Train5_11'], ['motif_Train9_8', 'motif_Train2_6', 'motif_Train5_8', 'motif_Train1_6', 'motif_Train3_6', 'motif_10_8', 'motif_Train7_5', 'motif_Train4_7', 'motif_Train6_7', 'motif_Train8_7'], ['motif_Train4_11', 'motif_Train1_11', 'motif_Train9_10', 'motif_Train7_10', 'motif_Train6_11', 'motif_Train3_11', 'motif_10_11', 'motif_Train8_10', 'motif_Train5_10', 'motif_Train2_10'], ['motif_Train7_24', 'motif_10_25', 'motif_Train1_19', 'motif_Train5_21', 'motif_Train6_26', 'motif_Train4_22', 'motif_Train8_23', 'motif_Train9_20', 'motif_Train3_18'], ['motif_Train9_2', 'motif_Train5_2', 'motif_Train6_2', 'motif_Train1_2', 'motif_Train2_2', 'motif_Train7_2', 'motif_Train3_2', 'motif_Train8_1', 'motif_10_2', 'motif_Train4_2'], ['motif_Train9_3', 'motif_Train5_3', 'motif_Train6_3', 'motif_Train1_3', 'motif_Train2_3', 'motif_Train7_3', 'motif_Train8_3', 'motif_Train4_3', 'motif_10_3'], ['motif_Train9_1', 'motif_Train5_1', 'motif_Train1_1', 'motif_Train6_1', 'motif_Train2_1', 'motif_Train7_1', 'motif_Train3_1', 'motif_Train8_2', 'motif_Train4_1', 'motif_10_1'], ['motif_Train5_4', 'motif_Train9_5', 'motif_Train2_5', 'motif_Train1_4', 'motif_Train6_4', 'motif_Train3_4', 'motif_Train7_4', 'motif_Train4_5', 'motif_10_5', 'motif_Train8_4']]
</code></pre>
	   

##Run MotifSetReduce.pl to generate consensus motifs 
For this step, we extract the motifs for each group in MEME format and then run MotifSetReduce.pl to produce consensus motifs.(Some lines of input files [motif-group1](https://github.com/xianyao710/YRB_Capstone/blob/master/results/motif_group1.txt),[motif-group2](https://github.com/xianyao710/YRB_Capstone/blob/master/results/motif_group2.txt),[motif-group3](https://github.com/xianyao710/YRB_Capstone/blob/master/results/motif_group3.txt),[motif-group4](https://github.com/xianyao710/YRB_Capstone/blob/master/results/motif_group4.txt),[motif-group5](https://github.com/xianyao710/YRB_Capstone/blob/master/results/motif_group5.txt),[motif-group6](https://github.com/xianyao710/YRB_Capstone/blob/master/results/motif_group6.txt),[motif-group7](https://github.com/xianyao710/YRB_Capstone/blob/master/results/motif_group7.txt),[motif-group8](https://github.com/xianyao710/YRB_Capstone/blob/master/results/motif_group8.txt)shown below)
<pre><code>
MEME version 4
ALPHABET= ACGT

MOTIF motif_Train8_9 10-CGCTAGAGGG 
letter-probability matrix: alength= 4 w= 10 nsites= 20 E= 1e-43 
0.103	0.786	0.043	0.068
0.16	0.001	0.793	0.046
0.107	0.73	0.063	0.1
0.109	0.317	0.045	0.529
0.941	0.011	0.047	0.001
0.053	0.014	0.869	0.064
0.674	0.101	0.124	0.101
0.047	0.029	0.602	0.322
0.101	0.162	0.585	0.152
0.165	0.058	0.605	0.172

MOTIF motif_Train1_10 10-CGCTAGAGGG 
letter-probability matrix: alength= 4 w= 10 nsites= 20 E= 1e-39 
0.089	0.821	0.055	0.035
0.097	0.018	0.844	0.041
0.057	0.811	0.056	0.076
0.074	0.142	0.062	0.722
0.914	0.019	0.048	0.019
0.026	0.03	0.859	0.085
0.812	0.066	0.063	0.059
0.023	0.014	0.794	0.169
0.111	0.115	0.689	0.085
0.148	0.029	0.74	0.083

</code></pre>
Codes can be found under directory [MotifSetReduce](https://github.com/BrendelGroup/bghandbook/tree/master/demo/MotifSetReduce).<br/>
<pre><code>
$for file in ls Motif_group*.txt;do ./MotifSetReduce.pl -m $file > $file.consensus(output file name) ;done

Now running MotifSetReduce.pl with arguments -m /Users/xiangyuyao/I692/data/motif_group1.txt -l 5 -t 0.09 -c 0.5 ...


For e.g, consensus motif for group1 is shown below

Consensus motifs at merging threshold 0.09:

DE	motif_10_14mmmmmm (7 positions) IC=  7.803
0.092	0.879	0.015	0.014	C	1.340
0.195	0.006	0.766	0.033	G	1.037
0.043	0.768	0.126	0.063	C	0.885
0.026	0.305	0.029	0.639	T	0.778
0.974	0.008	0.015	0.004	A	1.787
0.012	0.008	0.898	0.081	G	1.432
0.611	0.024	0.165	0.200	A	0.543
XX
</code></pre>
After this step, we produce consensus motifs for 8 groups.([consensus1](https://github.com/xianyao710/YRB_Capstone/blob/master/results/VB_group1.txt),[consensus2](https://github.com/xianyao710/YRB_Capstone/blob/master/results/VB_group2.txt),[consensus3](https://github.com/xianyao710/YRB_Capstone/blob/master/results/VB_group3.txt),[consensus4](https://github.com/xianyao710/YRB_Capstone/blob/master/results/VB_group4.txt),[consensus5](https://github.com/xianyao710/YRB_Capstone/blob/master/results/VB_group5.txt),[consensus6](https://github.com/xianyao710/YRB_Capstone/blob/master/results/VB_group6.txt),[consensus7](https://github.com/xianyao710/YRB_Capstone/blob/master/results/VB_group7.txt),[consensus8](https://github.com/xianyao710/YRB_Capstone/blob/master/results/VB_group8.txt))
Use the package [seqLogo](https://www.bioconductor.org/packages/release/bioc/html/seqLogo.html) in R, we show the representation of consensus motif for [group1](https://github.com/xianyao710/YRB_Capstone/blob/master/results/group1.png),[group2](https://github.com/xianyao710/YRB_Capstone/blob/master/results/group2.png),[group3](https://github.com/xianyao710/YRB_Capstone/blob/master/results/group3.png),[group4](https://github.com/xianyao710/YRB_Capstone/blob/master/results/group4.png),[group5](https://github.com/xianyao710/YRB_Capstone/blob/master/results/group5.png),[group6](https://github.com/xianyao710/YRB_Capstone/blob/master/results/group6.png),[group7](https://github.com/xianyao710/YRB_Capstone/blob/master/results/group7.png),[group8](https://github.com/xianyao710/YRB_Capstone/blob/master/results/group8.png).

##Results and discussion
The initial Tomtom file contains pairwise comaparison of 228 motifs. By taking each steps in this workflow, we have 8 clusters of motifs in MEME format.(under /data directory motif_group[index].txt ).By comparing the inital [Tomtom graph](https://github.com/xianyao710/YRB_Capstone/blob/master/results/raw_edge_list.png) and [8 clusters](https://github.com/xianyao710/YRB_Capstone/blob/master/results/8_clusters.png), we confirmed that these clusters are the connected components that every node in each group has degree more than 8. After having 8 groups of motifs,we generate consensus motif for each group shown in PFM format.The predicted consensus motifs are presented in the order of IC(information content) value. And the motifs with max IC are plotted in R using package seqLogo. The consensus motif files are named VB_[group_index].txt together with the seqLogo files(named group[1-8].png),located in /results directory.In conclusion, our workflow presents a simple way to use graphic anaylsis to remove redundancy and randomness of motif prediction.

