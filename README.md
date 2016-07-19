++++++++++++++++++++++++++++++++++++++++++++++++++++++

#MoVRs
"MoVRs", a workflow for de novo motifs cross-validation and redundancy removing.

MoVRs lets users specify their regions of interest in the genome, and then implements HOMER de novo motif finding program followed by statistics cross-validation and clustering. This workflow currently accepts HOMER peak or bed position files and reference genome in FASTA format or its name in HOMER as input, and output non-redundant consensus motifs for each clusters that meet certain criteria. 
 
 
##Quick install
###Download and uncompress
```
$wget https://github.com/xianyao710/YRB_Capstone/blob/master/MoVRs.tar.gz
$tar -xzvf MoVRs.tar.gz
```
Add the bin/ directory to envrionment path
```
$PATH=$PATH:/your working directory/MoVRs/bin
$export PATH
```
Also, you need to add the bin/ directory to PYTHONPATH
```
$ vi ~/.bashrc
$ export PYTHONPATH="${PYTHONPATH}:/path/to/bin/"
```
Or you can directly folk our Github depository (assuming not through SSH)

```
$git clone https://github.com/xianyao710/YRB_Capstone.git
$cd YRB_Capstone/bin
$bash MoVRs.sh -h
```


### Required program for motif finding
HOMER and MEME suite are two core incorporated softwares that required for normal function of MoVRs.

HOMER install guide [link](http://homer.salk.edu/homer/introduction/install.html) is attached here.

MEME suite install guide [link](http://meme-suite.org/doc/download.html?man_type=web) is attached here.

After installation, make sure you add the excutable scripts of these two softwares to envirmental path.

```
$ PATH=$PATH\:/dir/path/executable files; export PATH

or edit ~/.bash_profile and add the following line

export PATH=$PATH:/dir/path/executable files

$source ~/.bash_profile
```
Test if you've successfully installed HOMER and MEME.

```
$findMotifsGenome.pl
$annotatePeaks.pl
$tomtom

```

### Required package for clustering
Python module "networkx" and "matplotlib.pyplot" should be able to work so that graphical clustering and plot can be finished.

Download python module [Networkx](https://pypi.python.org/pypi/networkx/)

If you've installed pip for installing python packages, then you can type

```
$pip install networkx


```

##Quick Run
###Prepare your input
Two input parameters are mandatory.

Movrs -p `<`HOMER peak or BED file`>`

check file format at [HOMER peak or BED](http://homer.salk.edu/homer/ngs/peakMotifs.html) 
Movrs -G `<`HOMER build-in reference genome e.g. hg19 for human `>`

Movrs -g `<`fasta genome file provided by users`>`

###Simple command
```
$Movrs -p sample/tss_hs_A549_chr15.txt -G hg19
```
