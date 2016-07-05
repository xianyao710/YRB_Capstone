#workflow.sh integrates all the scripts under the makefile directory 
################################
#input is a homer motif file   #
#prompt for threshold input    #
#all results in ../results     #
################################ 
#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PDIR=$(dirname "${DIR}")


#check pre-required programs and packages
echo "Checking required programs and packages ------> "
bash check.sh
if [ "$?" -eq "0" ];then
	echo "Checking process successfully finished"
else
	echo "Checking process terminated with error" >&2
	exit 1
fi



#raw homer file input
echo "Enter the absolute path for your raw Homer motifs [ENTER]: "
read raw_homer
{
	find $raw_homer
} || {
	echo "Can't find file !"
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
tomtom_output=$PDIR"/results/tomtom"
if [ $evalue -eq 0 ]
then
	tomtom -o $tomtom_output $raw_meme $raw_meme
else
	tomtom -evalue -o $tomtom_output -evalue $evalue $raw_meme $raw_meme
fi


#extract motif id and output raw_edgelist file
cut -f 1,2 $tomtom_output"/tomtom.txt" > ../results/raw_edgelist

#extract motif clusters in graph
echo -n "Enter your threshold for degree of node in motif graph, or enter 0 using default >"
read degree
if [ $degree -eq 0 ];
then
	python GetCluster.py -i ../results/raw_edgelist -e ../results/motif_cluster.txt	
else
	python GetCluster.py -i ../results/raw_edgelist -e ../results/motif_cluster.txt -t $degree
fi

#generate motif group files in meme format
python extract_motif.py -i $raw_meme -e ../results/motif_cluster.txt 

mkdir ../results/motif_group
mv Group* ../results/motif_group

#generate consensus motif for each group
for file in ../results/motif_group/Group* ;do ./MotifSetReduce.pl -m $file > $file".consensus"; done


