#workflow.sh integrate all the scripts under the makefile directory 


#check pre-required programs and packages
echo "Checking required programs and packages "
bash check.sh
if [$? -eq 0]
then
	echo "Checking successfully finished"
else
	echo "Checking terminated with error" >&2
fi


#raw homer file input
echo -n "Enter the file name for your raw Homer motifs > "
read raw_homer
echo "The file you entered: $raw_homer "
{
	find $raw_homer
} || {
	echo "Can't find file $raw_homer"
	exit
}

#process the raw_homer motif to meme format
Rscript process_format.R $raw_homer
if [$? -eq 0]
then 
	echo "Format transformation succeed"
else
	echo "Error in format processing" >&2
fi
$suffix = ".meme"
$raw_homer_meme = $raw_homer$suffix
mv $raw_homer_meme ../results

#tomtom comparison of motifs in meme format
echo -n "Enter your evalue threshold, or enter 0 using default >"
read evalue
if [$evalue -eq 0]
then
	tomtom $evalue $raw_homer_meme $raw_homer_meme
else
	tomtom -evalue $evalue $raw_homer_meme $raw_homer_meme
fi
mv tomtom_out ../results

#extract motif id and output raw_edgelist file
cut -f 1,2 ../results/tomtom_out/tomtom.txt > ../results/raw_edgelist

#extract motif clusters in graph
echo -n "Enter your threshold for degree of node in motif graph, or enter 0 using default >"
read degree
if [$degree -eq 0]
then
	python GetCluster.py -i ../results/raw_edgelist -e ../results/motif_cluster.txt	
else
	python GetCluster.py -i ../results/raw_edgelist -e ../results/motif_cluster.txt -t $degree

#generate motif group files in meme format
python extract_motif.py -i $raw_homer_meme -e ../results/motif_cluster.txt 

mkdir ../results/motif_group
mv Group* ../results/motif_group

#generate consensus motif for each group
for file in ls ../results/motif_group/Group* ;do ./MotifSetReduce.pl -m $file > $file.consensus; done


