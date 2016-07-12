#workflow.sh incorporates all the scripts in our workflow 
################################
#input is a homer motif file   #
#    			       #
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


#detect command line input and assign them to variable if appropriate
while ["$1" != ""];do
	case $1 in
	-p | --pos)	position=$1
			shift
			;;
	-g | --genome)	genome=$1
			shift
			;;
	-f | --fold)	fold=$1
			shift
			;;
	-t | --thresh)  thresh=$1
			shift
			;;	
	-h | --help)	echo "-p or --pos for 1st argument :bed or homer peak file"
			echo "-g or --genome for 2nd argument :reference genome"
			echo "-f or --fold for 3rd argument: numeric number for k-fold cross validation"
			exit
			;;	
	* )		echo "type -h or --help for usage"
			exit 1
	esac
	shift
done

#use HOMER script findMotifsGenome.pl to predict motifs in region of interest
cd $position
echo "HOMER output will be put under the workflow_out directory"
mkdir workflow_out
cd workflow_out

#separate peak or bed files randomly into k group for k-fold cross validation
echo "You have chosen $fold-fold cross validation"
mkdir test_group
mkdir train_group

grep "^[^#]" $pos > tmp.txt #ignore comment lines
shuf -o tmp.new tmp.txt
bash $DIR"/split.sh" tmp.new $fold group
for file in group*;do mv $file ${file/./};done 
mv group* test_group
rm tmp.txt
rm tmp.new


cd test_group
shopt -s extglob
for file in group*;do cat -- !(file) > ${file/group/train};done
mv train* ../train_group
echo "random separation completed"

#use HOMER script findMotifsGenome.pl to predict novel motifs in 
cd ../train_group
for file in train*;do findMotifsGenome.pl $file $genome $file"_Homer_out" -len 6,8,10,12 -size -60,40;done

mkdir ../Train_Homer
echo "Train_Homer contains homer motifs for all training sets" >> ../Train_Homer/README.txt

for file in train*[0-9];do cp $file"_Homer_out/homerMotifs.all.motifs" "../Train_Homer/"$file".homer";done

cd ../
cat Train_Homer/*.homer > all_train.homer

#process the raw_homer motif to meme format
raw_meme="all_train.meme"
Rscript $DIR"/motif2meme.R" all_train.homer $raw_meme
if [ $? -eq 0 ]
then 
	echo "Format transformation succeed"
else
	echo "Error in format processing"
fi

#tomtom comparison of motifs in meme format
tomtom -thresh $thresh -evalue $raw_meme $raw_meme


if [! -d "Clustering_out"];then
	mkdir Clustering_out
fi
#extract motif id and output raw_edgelist file
cut -f 1,2 tomtom_out/tomtom.txt > raw_edgelist
mv raw_edgelist ./Clustering_out
cd Clustering_out
echo "Clustering_out contains results of motif clustering and merging" >> README.txt
#extract motif clusters in graph
python $DIR"/GetCluster.py" -i raw_edgelist -t $fold

if [! [-d "Nodes"]];then
	mkdir Nodes
fi
if ls cluster*.txt 1> /dev/null 2>&1; then
	echo "there are clusters extracted"
else
	echo "No clusters extracted, program halted"
	exit 1
fi
mv cluster*.txt Nodes/

mkdir Cluster_meme
echo "Cluster_meme folder contains meme motif extracted from similarity graph" >> Cluster_meme/README.txt	

#generate motif group files in meme format
cd Nodes
for file in cluster*.txt;do python $DIR"/extract_motif.py" -i $raw_meme -n $file -o "../Cluster_meme"$file".meme";done 



#generate consensus motif for each group
cd ../Cluster_meme
mkdir ../Cluster_consensus
echo "Cluster_consensus folder contains the consensus motifs for each cluster" >> ../Cluster_consensus/README.txt

for file in *.meme;do perl $DIR"/MotifSetReduce.pl" -m $file > "../Cluster_meme"${file/meme/consensus}; done

cd ..

#convert consensus motif to homer format
mkdir Consensus_Homer_motif
echo "Consensus_Homer_motif folder contains consensus motif in homer forat" >> Consensus_Homer_motif/README.txt

cd Cluster_consensus
for file in *.consensus;do python $DIR"/consensus2homer.py" -i $file -o "../Consensus_Homer_motif/"${file/consensus/homer};done

#use HOMER annotatePeaks.pl to identify motif positions on the reference genome
cd Consensus_Homer_motif
for file in *.homer;do annotatePeaks.pl $position $genome -m $file > ${file/homer/out};done

echo ".out files are results of annotatePeaks for each motif cluster" >> README.txt

echo "Job completed"


