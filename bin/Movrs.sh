###############################################################################
#  		        Movrs.sh is written by                                #
#        Xiangyu Yao, Raborn R.Taylor and Volker Brendel                      #
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
#make sure you add the bin/ directory to your enviroment path

#!/bin/bash
set -e 
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
######################################
#Step 1				     #	
#Check required program and packages #
######################################

echo "Checking required programs and packages ------> "
MovrsConfigure 
if [ "$?" -eq "0" ];then
	echo ""
	echo "Configuration is completed"
else
	echo "Checking process terminated with error" >&2
	exit 1
fi



#####################################
#Step 2			            #
#Parse command line input           #
#####################################

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
	-j | --cores)	shift
			CORES=$1
			;;
	-s | --size)	shift
			size=$1
			;;
	-l | --length)	shift
			length=$1
			;;
	-f | --fold)	shift
			fold=$1
			;;
	-e | --evalue) shift
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
			echo "basic usage:  Movrs.sh -p <peak or bed file> -g <genome>  [OPTION]"
			echo ""
			echo "Arugments listed below:"
			echo "-p or --pos for 1st argument :bed or homer peak file"
			echo "####################################################"
			echo "#Check HOMER peak files or BED files format at     #"
			echo "#http://homer.salk.edu/homer/ngs/peakMotifs.html   #"
			echo "####################################################"
			echo ""
			echo "-g or --genome for 2nd argument :reference genome"
			echo "usually in fasta format"
			echo "or -G/--GENOME for build-in reference genome in homer e.g. hg19"
			echo ""
			echo "-j or --cores for number of available cores"
			echo ""
			echo "-s or --size for the sequence window centered on mid point e.g. -60,40 is default"
			echo "-l pr --length for length of motifs e.g. -len 6,8,10,12 is default"
			echo ""
			echo "[Optional argument]"
			echo "-f or --fold numeric number for k-fold cross validation"
			echo "-e or --evalue for filtering out motifs with evalue bigger than this parameter"
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
if [ -z "$CORES"];then
	CORES=2
fi
if [ -z "$fold" ];then
	fold=10
fi

if [ -z "$evalue" ];then
	evalue=0.001
fi

if [ -z "$thresh" ];then
	thresh=0.001
fi

if [ -z "$size" ];then
	size="-60,40"
fi

if [ -z "$length" ];then
	length="6,8,10,12"
fi
#must have parameters
if [[ -z $position ]];then
	echo "No peak or bed position file detected, please check help info by typing Movrs.sh -h/--help"
	exit 1
fi

if [ -z "$genome" ] && [ -z "$GENOME" ];then
	echo "No reference genome file detected, please check help info by typing Movrs.sh -h/--help"
	exit 1
fi

if [[ -z $outdir ]];then
	echo "No output directory specified, we create the Movrs_out folder under the same parent directory as your peak file"
	outdir=$(dirname $(readlink -f $position))"/Movrs_out"
	if [ ! -d "$outdir" ];then
		mkdir $outdir
     	fi		
fi

position=$(readlink -f $position)
if [[ -n $genome  ]];then
	genome=$(readlink -f $genome)		#use absolute path
else
	genome=$GENOME                          #use reference genome name built-in homer
fi
outdir=$(readlink -f $outdir)
if [ ! -d "$outdir" ];then
	mkdir $outdir
fi
echo ""
echo "Configuration for command line input is completed!"
#change directory to output path
echo "All output will be put under the $outdir directory"
cd $outdir



#################################
#Step 3			        #
#make training sets and test set#
#################################

#separate peak or bed files randomly into k group for k-fold cross validation
echo "You have chosen $fold-fold cross validation" 
if [ ! -d "test_group" ];then
	mkdir test_group
fi
if [ ! -d "train_group" ];then
	mkdir train_group
fi

echo "begin cross-validation process ------>"
grep "^[^#]" $position > tmp.txt #ignore comment lines
shuf -o tmp.new tmp.txt
bash MovrsSplit.sh tmp.new $fold group        #split peak files into k groups of equal size

if [ "$?" -eq "1" ];then
	echo "Something goes wrong when using shuf and split"
	exit 1
fi

for file in group*;
do 
	mv $file ${file/./}
done  #change file name e.g. group.01 changed into group01
mv group* test_group
rm tmp.txt
rm tmp.new


cd test_group
shopt -s extglob	# for running th command below
for file in group[0-1][0-9];
do 
	cat -- !($file) > "../train_group/"${file/group/train}
done   # concatenate remaining files as training set in each round


if [ "$?" -eq "1" ];then
	echo "Woops, something wrong happened when making training sets!"
	echo ""
	exit 1
else
	echo "Random separation of peak file for cross-validation is completed!"
       	echo ""	
fi


#########################################################
#Step 4							#		
#Use HOMER to predict motifs in regions in training set #
#########################################################

#use HOMER script findMotifsGenome.pl to predict novel motifs in 
cd ../train_group
echo "begin HOMER findMotifsGenome.pl --->"
for file in train[0-1][0-9];
do	
	echo "Begin findMotifsGenome.pl for $file set..."
	sem -j $CORES findMotifsGenome.pl $file $genome $file"_Homer_out" -len $length -size $size
	echo "motif finding for $file is completed"
done
sem --wait

if [ "$?" -eq "1" ];then
	echo "Oh, something wrong when finding motifs all training sets!"
	echo ""
	exit 1
else
	echo "Motif finding for all training sets is completed!"
fi

if [ ! -d "../Train_Homer" ];then
	mkdir ../Train_Homer
fi
echo "Train_Homer contains homer motifs for all training sets" >> ../Train_Homer/README.txt

for file in train[0-1][0-9];
do 
	cp $file"_Homer_out/homerMotifs.all.motifs" "../Train_Homer/"$file".homer"
done

cd ../Train_Homer

########################################################
#Step 5						       #
#Convert homer motif to meme format and run Tomtom     #
########################################################
if [ ! -d "../Train_meme" ];then
	mkdir ../Train_meme
fi

for file in *.homer;
do
	Rscript $DIR"/MovrsMotif2meme.R" $file "../Train_meme/"${file/homer/meme}
done	
#process the raw_homer motif to meme format
raw_meme="all_train.meme"
cd ..
cat Train_meme/*.meme > $raw_meme

if [ "$?" -eq "0" ];then 
	echo "Format transformation succeed" 
else
	echo "There are errors in homer to meme format processing"
       	exit 1	
fi

#filter meme motifs 
tmp="tmp.txt"
python $DIR"/MovrsExtractMotif.py" -i $raw_meme -t $evalue -o $tmp
rm $raw_meme
mv $tmp $raw_meme
raw_meme=$(readlink -f $raw_meme)
if [ "$?" -eq "1"];then
	echo "Something goes wrong trying to filter raw motifs with specfic theshold"
else
	echo "Succeed filtering raw motifs"
fi

#tomtom comparison of motifs in meme format
tomtom -thresh $thresh -evalue $raw_meme $raw_meme || true
if [ "$?" -eq "1" ];then
	echo "Something goes wrong trying to use tomtom!"
	if [ -d "tomtom_out" ];then
		echo " we still continue to analyze"
	else
		echo " we can not continue without tomtom.txt"
		exit 1
	fi
else
	echo "tomtom motif comparison is completed!"
fi


if [ ! -d "Clustering_out" ];then
	mkdir Clustering_out
fi

######################################################
#Step 6						     #			
#Graphical clustering of training motifs             #
######################################################

cut -f 1,2 tomtom_out/tomtom.txt > raw_edgelist
mv raw_edgelist ./Clustering_out
cd Clustering_out
echo "Clustering_out contains results of motif clustering and merging" >> README.txt
#extract motif clusters in graph
ClusterThresh=$((fold-1))
python $DIR"/MovrsGetCluster.py" -i raw_edgelist -t $ClusterThresh

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
clusters=$(ls cluster*.txt)
if [[ $clusters ]]; then
	echo "there are clusters extracted" 
else
	echo "No clusters extracted, program halted" 
	exit 0
fi
mv cluster*.txt Nodes/
if [ ! -d "Cluster_meme" ];then
	mkdir Cluster_meme
fi
echo "Cluster_meme folder contains meme motif extracted from similarity graph" >> Cluster_meme/README.txt	

#generate motif group files in meme format
cd Nodes
for file in cluster*.txt;
do 
	python $DIR"/MovrsExtractMotif.py" -i $raw_meme -n $file -o "../Cluster_meme/"${file/txt/meme}
	echo "Trying to extract motifs in $file from raw motif set"
done 

if [ "$?" -eq "1" ];then
	echo "Something goes wrong when trying to extract motifs in clusters!"
	echo ""
	exit 1
else
	echo "Succeed extracting motifs in each cluster"
fi

##########################################
#Step 7 				 #
#generate consensus motif for each group #
##########################################

cd ../Cluster_meme
if [ ! -d "../Cluster_consensus" ];then
	mkdir ../Cluster_consensus
fi
echo "Cluster_consensus folder contains the consensus motifs for each cluster" >> ../Cluster_consensus/README.txt

for file in *.meme;
do 
	echo "Trying to generate consensus motifs for $file ..."
	MovrsMotifSetReduce.pl -m $file > "../Cluster_consensus/"${file/meme/consensus}
	echo "Succeed generating consensus motifs for $file !"
	echo ""
done

if [ "$?" -eq "1" ];then
	echo "Something goes wrong when trying to generate consensus motifs"
else
	echo "Finish generating consensus motif. Our Job is completed!"
fi
cd ..

####################################
#Step 8                            #
#Remove temporary files            #
####################################
echo "Deleting  temporary files ------>"
rm -rf Cluster_meme
rm -rf Nodes
rm raw_edgelist

rm -rf ../Train_meme
rm -rf ../Train_Homer
rm -rf ../test_group
rm -rf ../train_group
rm $raw_meme
rm -rf ../tomtom_out
echo "Temporary files are deleted!"


####################################
#Step 9                            #
#Generate html output              #
####################################

#generate SeqLogo for each consensus motif
if [ ! -d "figure"];then
	mkdir "figure"
fi

cd Cluster_consensus
for file in *.consensus;
do
	Rscript $DIR"/MovrsSeqLogo4cluster.R" $file "../figure/"
done	

echo "Finish generating SeqLogo for validated motifs"

echo ""

echo "Motifs can be found in Cluster_consensus folder"

echo "SeqLogo of motifs can be found in figure folder"


##################################################################
#Step 10							 #	
#Convert consensus motif to homer format and run compareMotifs.pl#
##################################################################
if [ ! -d "../Cluster_homer"];then
	mkdir ../Cluster_homer
fi

for file in *.consensus;
do 
	python $DIR"/MovrsConsensus2homer.py" -i $file -o "../Cluster_homer/"${file/consensus/homer}
done

cd ../Cluster_homer

for file in *.homer;
do
	compareMotifs.pl $file ./
done

echo "Annotation of the predicted motifs is completed. Check the html files for detail"





##########################################################
#Step 11					         #
#Annotate position of novel motifs                       #
##########################################################
#use HOMER annotatePeaks.pl to identify motif positions on the reference genome

#for file in *.homer;
#do 
#	echo "Begin annotatePeaks.pl for motif $file ..."
#	annotatePeaks.pl $position $genome -m $file > ${file/homer/out}
#	echo ""
#done

#echo ".out files are results of annotatePeaks for each motif cluster" >> README.txt

#echo "Finally, out job is completed. Check README.txt for information about output files"


