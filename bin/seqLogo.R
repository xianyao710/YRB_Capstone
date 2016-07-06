#!/usr/bin/Rscript
#use PWM motif matrix to output seqLogo
library(grid)
library(seqLogo)

args=commandArgs(trailingOnly=TRUE)
if (length(args)!=2){
	stop("Two arguments must be supplied. \n",call.=FALSE)
}else{
inFile=args[1]
outFile=args[2]
}
png(filename=outFile)

tmp<-read.table(inFile)
A<-tmp$V1
C<-tmp$V2
G<-tmp$V3
T<-tmp$V4
df<-data.frame(A,C,G,T)
df<-t(df)
df<-makePWM(df)

seqLogo(df)
dev.off()
