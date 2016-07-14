###############################################################################
#  		        workflow.sh is written by                             #
#        			 Xiangyu Yao	                              #
#     			     xianyao@indiana.edu                              #
#-----------------------------------------------------------------------------#
#requirement:								      #	
#HOMER, MEME should be installed. findMotifsGenome.pl, annotatePeaks.pl and   #
# tomtom should be added to your environmental path.                          #                       
#-----------------------------------------------------------------------------#
#Python packages "networkX" and "matplotlib.pyplot" are needed for graphical  #
#anaylsis. There may be other pre-required package needed for ploting graphs  #
#---------------------------------------------------------------------------- #	
#unix command "shuf" and "split" should be accessible                         #
#-----------------------------------------------------------------------------#	
#input: (1)alignment bed or peak files (2)reference genome file               #	
############################################################################### 

#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #DIR is the absolute path where workflow.sh lies


#check pre-required programs and packages
echo "Checking required programs and packages ------> "
bash $DIR"/configure"
if [ "$?" -eq "0" ];then
	echo ""
	echo "Configuration is completed"
else
	echo "Checking process terminated with error" >&2
	exit 1
fi


#detect command line input and assign them to variable if appropriate
while [ "$1" != "" ];do
	case $1 in
	-p | --pos)	shift
			position=$1
			;;
	-g | --genome)  shift
			genome=$1
			;;
	-G | --GENOME)  shift
			GENOME=$1
			;;
	-f | --fold)	shift
			fold=$1
			;;
	-e | --extract) shift
			evalue=$1
			;;
	-t | --thresh)  shift
			thresh=$1
			;;	
	-o | --output)  shift
			outdir=$1
			;;
	-h | --help)	echo ""
			echo "=========================================================="
			echo "basic usage:  workflow.sh -p <peak or bed file> -g <genome>  [OPTION]"
			echo ""
			echo "Arugments listed below:"
			echo "-p or --pos for 1st argument :bed or homer peak file"
			echo "-g or --genome for 2nd argument :reference genome"
			echo "or -G/--GENOME for build-in reference genome in homer"
			echo ""
			echo "[Optional argument]"
			echo "-f or --fold numeric number for k-fold cross validation"
			echo "-e or --extract for filtering out motifs with evalue bigger than this parameter"
			echo "-t or --thresh for tomtom comparison"
			echo "-o or --output for output directory"
			echo ""
			exit
			;;	
	* )		echo " Wrong input format! Type -h or --help for usage"
			exit 1
	esac
	shift
done

#configure default parameters if not provided by the user
#optional parameters
if [ -z "$fold" ];then
	fold=10
fi

if [ -z "$evalue" ];then
	evalue=0.001
fi

if [ -z "$thresh" ];then
	thresh=0.001
fi

#must have parameters
if [[ -z $position ]];then
	echo "No peak or bed position file detected, please check help info by typing workflow.sh -h/--help"
	exit 1
fi

if [ -z "$genome" ] && [ -z "$GENOME" ];then
	echo "No reference genome file detected, please check help info by typing workflow.sh -h/--help"
	exit 1
fi

if [[ -z $outdir ]];then
	echo "No output directory specified, we create the Workflow_out folder under the same parent directory as your peak file"
	outdir=$(dirname $(readlink -f $position))"/Workflow_out"
	mkdir $outdir           
fi

position=$(readlink -f $position)
if [[ -n $genome  ]];then
	genome=$(readlink -f $genome)		#use absolute path
else
	genome=$GENOME                          #use reference genome name built-in homer
fi
outdir=$(readlink -f $outdir)

echo ""
echo "Configuration for command line input is completed!"
#change directory to output path
echo "All output will be put under the $outdir directory"
cd $outdir

#separate peak or bed files randomly into k group for k-fold cross validation
echo "You have chosen $fold-fold cross validation" 
mkdir test_group
mkdir train_group

echo "begin cross-validation process ------>"
grep "^[^#]" $position > tmp.txt #ignore comment lines
shuf -o tmp.new tmp.txt
bash $DIR"/split.sh" tmp.new $fold group        #split peak files into k groups of equal size

if [ "$?" -eq "1" ];then
	echo "Something goes wrong when using shuf and split"
	exit 1
fi

for file in group*;do mv $file ${file/./};done  #change file name e.g. group.01 changed into group01
mv group* test_group
rm tmp.txt
rm tmp.new


cd test_group
shopt -s extglob	# for running th command below
for file in group*;do cat -- !($file) > ${file/group/train};done   # concatenate remaining files as training set in each round
mv train* ../train_group

if [ "$?" -eq "1" ];then
	echo "Woops, something wrong happened when making training sets!"
	echo ""
	exit 1
else
	echo "Random separation of peak file for cross-validation is completed!"
       	echo ""	
fi


#use HOMER script findMotifsGenome.pl to predict novel motifs in 
cd ../train_group
echo "begin HOMER findMotifsGenome.pl --->"
for file in train*;do 
	echo "Begin findMotifsGenome.pl for $file set..."
	findMotifsGenome.pl $file $genome $file"_Homer_out" -len 6,8,10,12 -size -60,40
	echo "motif finding for $file is completed"
done

if [ "$?" -eq "1" ];then
	echo "Oh, something wrong when finding motifs all training sets!"
	echo ""
	exit 1
else
	echo "Motif finding for all training sets is completed!"
fi

mkdir ../Train_Homer
echo "Train_Homer contains homer motifs for all training sets" >> ../Train_Homer/README.txt

for file in train*[0-9];do cp $file"_Homer_out/homerMotifs.all.motifs" "../Train_Homer/"$file".homer";done

cd ../
cat Train_Homer/*.homer > all_train.homer

if [ "$?" -eq "1" ];then
	echo "Oh, something unexpected when trying to concatenate training homer motifs! "
	echo ""
	exit 1
else
	echo "all_train.homer is successfully created! Heading to next step -->"
fi
	
	
#process the raw_homer motif to meme format
raw_meme="all_train.meme"
Rscript $DIR"/motif2meme.R" all_train.homer $raw_meme
if [ "$?" -eq "0" ];then 
	echo "Format transformation succeed" 
else
	echo "There are errors in format processing" 
fi

#filter meme motifs 
tmp="tmp.txt"
python $DIR"/extract_motif.py" -i $raw_meme -t $evalue -o $tmp
rm $raw_meme
mv $tmp $raw_meme

if [ "$?" -eq "1"];then
	echo "Something goes wrong trying to filter raw motifs with specfic theshold"
else
	echo "Succeed filtering raw motifs"
fi

#tomtom comparison of motifs in meme format
tomtom -thresh $thresh -evalue $raw_meme $raw_meme
if [ "$?" -eq "1" ];then
	echo "Something goes wrong trying to use tomtom!"
	exit 1
else
	echo "tomtom motif comparison is completed!"
fi


if [ ! -d "Clustering_out" ];then
	mkdir Clustering_out
fi
#extract motif id and output raw_edgelist file
cut -f 1,2 tomtom_out/tomtom.txt > raw_edgelist
mv raw_edgelist ./Clustering_out
cd Clustering_out
echo "Clustering_out contains results of motif clustering and merging" >> README.txt
#extract motif clusters in graph
python $DIR"/GetCluster.py" -i raw_edgelist -t $fold

if [ "$?" -eq "1" ];then
	echo "Woops, something goes wrong when trying to extract clusters from motif similarity graph!"
	echo ""
	exit 1
else
	echo "Succeed extract motif clusters from motif similarity graph!"
fi

if [ ! -d "Nodes" ];then
	mkdir Nodes
fi

# check if any motif clusters are extracted 
if [ [ $(ls -A cluster*.txt) ] ]; then
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
for file in cluster*.txt;
do 
	python $DIR"/extract_motif.py" -i $raw_meme -n $file -o "../Cluster_meme/"${file/txt/meme}
	echo "Trying to extract motifs in $file from raw motif set"
done 

if [ "$?" -eq "1" ];then
	echo "Something goes wrong when trying to extract motifs in clusters!"
	echo ""
	exit 1
else
	echo "Succeed extracting motifs in each cluster"
fi

#generate consensus motif for each group
cd ../Cluster_meme
mkdir ../Cluster_consensus
echo "Cluster_consensus folder contains the consensus motifs for each cluster" >> ../Cluster_consensus/README.txt

for file in *.meme;
do 
	echo "Trying to generate consensus motifs for $file ..."
	perl $DIR"/MotifSetReduce.pl" -m $file > "../Cluster_consensus"${file/meme/consensus}
	echo "Succeed generating consensus motifs for $file !"
	echo ""
done

if [ "$?" -eq "1" ];then
	echo "Something goes wrong when trying to generate consensus motifs"
else
	echo "Finish generating consensus motif. We are almost done!"

cd ..

#convert consensus motif to homer format
mkdir Consensus_Homer_motif
echo "Consensus_Homer_motif folder contains consensus motif in homer format" >> Consensus_Homer_motif/README.txt

cd Cluster_consensus
for file in *.consensus;
do 
	echo "Trying to convert consensus motif in $file to homer format ..."
	python $DIR"/consensus2homer.py" -i $file -o "../Consensus_Homer_motif/"${file/consensus/homer}
	echo "Succeed converting $file to homer format"
	echo ""
done

if [ "$?" -eq "1" ];then
	echo "Something goes wrong when trying to convert consensus motif to homer format!"
else
	echo "Finish converting consensus motif to homer format!"
fi

#use HOMER annotatePeaks.pl to identify motif positions on the reference genome
cd Consensus_Homer_motif
for file in *.homer;
do 
	echo "Begin annotatePeaks.pl for motif $file ..."
	annotatePeaks.pl $position $genome -m $file > ${file/homer/out}
	echo "Finish annotatePeaks.pl for motif $file !"
	echo ""
done

echo ".out files are results of annotatePeaks for each motif cluster" >> README.txt

echo "Finally, out job is completed. Check README.txt for information about output files"


