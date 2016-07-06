#!/usr/bin/Rscript
##########################
#input: cluster.consensus#
#output:seqLogo figure	 #
##########################

#load required library
library(grid)
library(seqLogo)


args=commandArgs(trailingOnly=TRUE)
if (length(args)!=2){
	stop("Wrong input! \n",call.=FALSE)
}else{
fin=args[1]
outdir=args[2]
}
#png(filename=outFile)

all_dat<-readLines(fin)
#all_dat
count<-0
flag<-FALSE
for (i in 1:length(all_dat)){
	if(grepl("DE",all_dat[i])){
		DF<-NULL
		tmp<-""
		count<-count+1
		fout<-paste(fin,"_",as.character(count),".png",sep="")
		flag<-TRUE
		next
		}
	if(grepl("XX",all_dat[i])){
		con<-textConnection(tmp)
		DF<-read.delim(con,header=FALSE)
		close(con)
		DF<-data.frame(DF)
		data.frame(lapply(DF,as.numeric))
	#	print(DF)
		A<-DF$V1
		C<-DF$V2
		G<-DF$V3
		T<-DF$V4
		df<-data.frame(A,C,G,T)
		pwm<-t(df)
		pwm<-makePWM(pwm)
		fout<-paste(outdir,fout,sep="")
		png(filename=fout)
		seqLogo(pwm)
		dev.off()
		flag<-FALSE
	}
	if(flag){
                tmp<-paste(tmp,all_dat[i],"\n",sep="")
                }
}

