#Identify consensus motifs from Tomtom results
Here we present our workflow to generate consensus motifs from motif pairwise comparison results done by Tomtom.

##Work flow
[Tomtom results](https://github.com/xianyao710/YRB_Capstone/blob/master/data/tomtom.txt)(extract pair-wise comparison of motifs) <br/>
                ||<br/>
                || graphic analysis and cluster motifs by degree <br/>
                ||<br/>
        [extract clustered motifs](https://github.com/xianyao710/YRB_Capstone/tree/master/results) in MEME format (motif_group[1-8].txt)<br/>
                || <br/>
                || Run [MotifSetReduce.pl](https://github.com/BrendelGroup/bghandbook/blob/master/demo/MotifSetReduce/MotifSetReduce.pl) <br/>
                || <br/>
        generate [consensus motif](https://github.com/xianyao710/YRB_Capstone/tree/master/results) for each group (VB_group[1-8].txt)<br/>

##Tomtom results
Tomtom is the software package included in MEME suite to do comparsion of motifs against known motif databases or motifs provided by users. Some lines of the this file [tomtom.txt](https://github.com/xianyao710/YRB_Capstone/blob/master/data/tomtom.txt) are shown below.<br/>
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

$cut -f 1,2 tomtom.txt > raw_adjlist
</code></pre>
Since we want to construct graph for these motifs, we extracted the first two columns and append them to a new file [raw_adjlist](https://github.com/xianyao710/YRB_Capstone/blob/master/results/raw_adjlist).
##Using python package networkx to cluster motifs
Here we ultilize the well developed python package [networkx](http://networkx.github.io) to analyze our motifs.Input is the raw_adjlist file from last step.After running the commands below, we generated a new graph containing 8 connected components that represent 8 motif clusters<br/>. 
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
The output file is [motif_cluster](https://github.com/xianyao710/YRB_Capstone/blob/master/results/motif_cluster) in adjcent list format.
<pre><code>
motif_Train5_8 motif_Train9_8 motif_Train2_6 motif_Train1_6 motif_Train3_6 motif_10_8 motif_Train7_5 motif_Train4_7 motif_Train6_7 motif_Train8_7
motif_Train8_10 motif_Train4_11 motif_Train1_11 motif_Train9_10 motif_Train7_10 motif_Train3_11 motif_10_11 motif_Train5_10 motif_Train2_10
motif_Train8_1 motif_Train9_2 motif_Train5_2 motif_Train6_2 motif_Train1_2 motif_Train3_2
motif_Train8_3 motif_Train9_3 motif_Train5_3 motif_Train6_3 motif_Train1_3 motif_Train2_3 motif_Train7_3 motif_Train4_3 motif_10_3
motif_Train8_2 motif_Train9_1 motif_Train5_1 motif_Train1_1 motif_Train6_1 motif_Train2_1 motif_Train7_1 motif_Train3_1 motif_Train4_1 motif_10_1
motif_Train8_7 motif_Train9_8 motif_Train2_6 motif_Train1_6 motif_Train3_6 motif_10_8 motif_Train7_5 motif_Train4_7 motif_Train6_7
motif_Train9_2 motif_Train5_2 motif_Train6_2 motif_Train1_2 motif_Train3_2
motif_Train9_3 motif_Train5_3 motif_Train6_3 motif_Train1_3 motif_Train2_3 motif_Train7_3 motif_Train4_3 motif_10_3
motif_Train9_8 motif_Train2_6 motif_Train1_6 motif_Train3_6 motif_10_8 motif_Train7_5 motif_Train4_7 motif_Train6_7
motif_Train1_2 motif_Train5_2 motif_Train6_2 motif_Train3_2
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

##Results and discussion
The initial Tomtom file contains 228 motifs. By taking each steps in this workflow, we generate 8 clusters of motifs and extract the convert them in MEME format.(under /data directory motif_group[index].txt ).By comparing the inital Tomtom graph and processed graph, we confirmed that these clusters are the connected components that every node in each group has degree more than 8. After having 8 groups of motifs,we generate consensus motif for each group shown in PFM format.The predicted consensus motifs are presented in the order of IC(information content) value. And the motifs with max IC are plotted in R using package seqLogo. The consensus motif files are named VB_[group_index].txt together with the seqLogo files,located in /results directory.


