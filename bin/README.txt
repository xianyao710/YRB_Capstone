################################
#README for running workflow.sh#
################################
/bin folder contains all the scripts needed to run workflow.sh.
workflow.sh takes <region of interest> <reference genome> [OPTION] as input for non-redundant novel motif discovery.

See more detail by typying
$bash workflow.sh -h/--help

-----------------------------------------------------------------------------
How to run a example job?
$bash workflow.sh -p tss.txt -g hg19

All results are put in the Workflow_out directory
-----------------------------------------------------------------------------
Dependencies for running workflow.sh

MEME suite is required to be installed, and the enviromental path for program `tomtom` should be added to ~/.bash_profile.

HOMER software is required for using findMotifsGenome.pl and annotatePeaks.pl scripts, which should also be included in environment path

bash command "shuf" and "split" should be included. 

python module "networkx" and "matplotlib.pyplot" should pre-installed for graphical analysis
(python version should be higher than 2.6 for running "networkx")




