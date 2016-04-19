#Agenda for YRB project
[Githublink](https://github.com/xianyao710/YRB_Capstone) Including a sample case running of the workflow

[svn](http://brendelgroup.org/svn/doc/YRB/trunk/) 
Including writings about background and motivate of this project

#materials reviewed so far
i) [Bibtex citation](http://brendelgroup.org/svn/doc/YRB/trunk/YRB16.bib) </br>
ii) What I have learned from these literature and how this is incorporated into the paper document? </br>

Before reading, I know motifs are pattern of nucleotide sequences that play roles in gene expression regulation and there are some tools to identify them.

After reading, I learned that the idea of motifs come from the discovery of promoter and enhancer region of certain genes. TATA box for example, one of the best known motifs in promoter region of genes in most eukaryotes is the binding site for RNA polymerase and mutation of this motifs may lead to significant different gene expression level. To identify motifs therefore can help us better know the possible cis-element and TFs of gene expression regulation network.

There are experimental and combined programs to indentify motifs. Tools like CAGE, ChIp-Seq detect the protein binding regions that have higher chance to contain motifs.
Mainly two different ways exist to use these result: one stretgy is to count motif hits occuring with a sequence window of some size and the other is use probablistic model and EM algorithm to discriminate motifs clusters from background DNAs. However, predictions of motifs are not always of biological significance and validations are needed. 

There some tools to validate the predictions of motifs. Cluster motifs by calculating distance(different ways to measure distance) and do comparison with validated known motifs. The program Tomtom included in MEME suite for example can achieved this goal with probability score. Based on these comparison and calculation of motif distance, we think of the idea to do cross-validation of motif identification.

Cross-validation is a statistical analysis to estimate how accurately a prediction will perform. In our project, we employed 10-fold cross-validation which means we randomly split our genome into 10 groups of equal length and pick 9 groups as training set and the remaing as test set.

#result so far
We performed our workflow with adjustment of parameters and we got 8 motifs together with their PWM(Included in github ). Codes for this workflow have been wrapped up in a shell script.I have not included these results in our writings, I intended to do this part after we finish test set validation. 

#plans for coming few days
Test set data and validation?


