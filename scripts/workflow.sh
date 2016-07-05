#workflow.sh incorporates all the scripts in our workflow 
################################
#input is a homer motif file   #
#prompt for threshold input    #
#all results in ../results     #
################################ 
#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


#check pre-required programs and packages
echo "Checking required programs and packages ------> "
bash $DIR"/configure"
if [ "$?" -eq "0" ];then
	echo "Checking completed"
else
	echo "Checking process terminated with error" >&2
	exit 1
fi

#reminding
echo "We highly suggest that you create a folder that only contains the HOMER motif file. We will output all our result in that folder."

#raw homer file input
echo "Enter your raw HOMER motifs [ENTER]: "
read raw_homer
#retrieve the path of the folder which contains raw HOMER file
WD=$(dirname "${raw_homer}")
cd $WD
{
	find $raw_homer
} || {
	echo "Can't find the HOMER file !"
	exit 1
}

#process the raw_homer motif to meme format
raw_meme=$raw_homer".meme"
Rscript motif2meme.R $raw_homer $raw_meme
if [ $? -eq 0 ]
then 
	echo "Format transformation succeed"
else
	echo "Error in format processing"
fi

#tomtom comparison of motifs in meme format
echo -n "Enter your evalue threshold, or enter 0 using default >"
read evalue
if [ $evalue -eq 0 ]
then
	tomtom $raw_meme $raw_meme
else
	tomtom -thresh $evalue -evalue $raw_meme $raw_meme
fi

mkdir Network
#extract motif id and output raw_edgelist file
cut -f 1,2 tomtom_out/tomtom.txt > raw_edgelist
mv raw_edgelist ./Network
cd Network
#extract motif clusters in graph
echo -n "Enter your minimal number of node that should be contained in motif subgraph, or enter 0 using default 9>"
read degree
if [ $degree -eq 0 ];
then
	python GetCluster.py -i raw_edgelist 	
else
	python GetCluster.py -i raw_edgelist -t $degree
fi

mkdir Nodes
mv cluster*.txt Nodes/
mkdir Cluster_meme
#generate motif group files in meme format
cd Nodes
for file in cluster*.txt;do python $DIR"/extract_motif.py" -i $raw_meme -n $file -o "../Cluster_meme"$file".meme";done 



#generate consensus motif for each group
cd ../Cluster_meme
mkdir ../Cluster_consensus
for file in *.meme;do perl $DIR"/MotifSetReduce.pl" -m $file > "../Cluster_meme"${file/meme/consensus}; done

cd ..
echo "Job completed"

