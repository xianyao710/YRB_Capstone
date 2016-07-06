#Statistics cross-validation of de novo motif finding combinds graphical clustering
Here we give a simple illustration of how our workflow works to reduce redundancy in de novo motif finding.

##Work flow
![Workflow](https://github.com/xianyao710/YRB_Capstone/blob/master/figure/YRB_workflow.png?raw=true)

![Diagram](https://github.com/xianyao710/YRB_Capstone/blob/master/figure/Diagram.png?raw=true)

###Sample case 
[raw Homer output](https://github.com/xianyao710/YRB_Capstone/tree/master/data/homer_motif)<br/>
||<br/> [R script](https://github.com/xianyao710/YRB_Capstone/blob/master/bin/motif2meme.R) convert HOMER motif to MEME motif<br/>
||<br/>
||[meme motif in training sets](https://github.com/xianyao710/YRB_Capstone/blob/master/results/Cluster_result/all_train.meme) <br/>
				||<br/>
				||run [Tomtom](http://meme-suite.org/tools/tomtom),compare motifs against themselves<br/>
				||<br/>
[Tomtom results](https://github.com/xianyao710/YRB_Capstone/blob/master/results/Cluster_result/tomtom_out/tomtom.txt)(extract pair-wise comparison of motifs) <br/>
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
>source("motif2meme.R")
>motif2meme("homer motif","meme motif")
You can also directly run through command line.
$Rscript motif2meme.R <homer motif> <meme motif>
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
Since we want to construct graph for these motifs, we extracted the first two columns and append them to a new file [raw_edgelist](https://github.com/xianyao710/YRB_Capstone/blob/master/results/Cluster_result/raw_edgelist).
##Using python package networkx to cluster motifs
Here we ultilize the well developed python package [NetworkX](http://networkx.github.io) to analyze our motifs. [Raw_edgelist](https://github.com/xianyao710/YRB_Capstone/blob/master/results/Cluster_result/raw_edgelist) extracted from tomtom.txt output was used as input,  The nodes of [10 clusters](https://github.com/xianyao710/YRB_Capstone/tree/master/results/Cluster_result/cluster_nodes) were retrieved for further clustering. Picture for the clusters are shown here ([clusters](https://github.com/xianyao710/YRB_Capstone/blob/master/results/Cluster_result/human_clusters.png)) 
	   

##Run MotifSetReduce.pl to generate consensus motifs 
For this step, we extract the motifs for each group in MEME format ([motif in cluster](https://github.com/xianyao710/YRB_Capstone/tree/master/results/Cluster_result/cluster_motif)) and then run [MotifSetReduce.pl](https://github.com/BrendelGroup/bghandbook/tree/master/demo/MotifSetReduce) to produce consensus motifs.

<pre><code>
$for file in (all the cluster motif);do ./MotifSetReduce.pl -m $file > $file.consensus(output file name) ;done

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
After this step, we produce [consensus motifs](https://github.com/xianyao710/YRB_Capstone/tree/master/results/Cluster_result/cluster_consensus/raw_out) for 10 groups.Use the package [seqLogo](https://www.bioconductor.org/packages/release/bioc/html/seqLogo.html) to represent motifs([sample figure](https://github.com/xianyao710/YRB_Capstone/tree/master/results/Cluster_result/cluster_seqLogo)).
##Results and discussion
After comparison with JASPAR 2016 core vertebrate database, three motifs of our result show highly identity to known *cis*-regulatory elments like SP1, NRF1 and ZBTB33 in *Homo sapiens*.
![NRF1](https://github.com/xianyao710/YRB_Capstone/blob/master/figure/train1_7.png?raw=true)

![SP1](https://github.com/xianyao710/YRB_Capstone/blob/master/figure/train10_28.png?raw=true)

![ZBTB33](https://github.com/xianyao710/YRB_Capstone/blob/master/figure/train10_15.png?raw=true)
