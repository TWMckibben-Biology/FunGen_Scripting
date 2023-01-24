#! /bin/bash

## Purpose: The purpose of this script is to trim sequencing adapters and low quality regions from the read data.
## Input Data: Raw R1 & R2 reads (FASTQ); Adapter sequences to remove (FASTA)
## Output Data: Trimmed R1 & R2 paired and unpaired reads (FASTQ)
## More Information: http://www.usadellab.org/cms/?page=trimmomatic

# Modules
module load trimmomatic/0.39

# Variables: working directory(WD), sample(SM), forward read(FR), reverse read(RR)
DD=${2}
CS=${3)
SM=${1}
FR="${WD}/${SM}/${SM}_1.fastq.gz"
RR="${WD}/${SM}/${SM}_2.fastq.gz"
adapters="${WD}/AdaptersToTrim.fa"

mkdir $WD/$CS

# Run trimmomatic in paired end mode with 6 threads using phred 33 quality score format. 
#Check out the trimmomatic documentation to understand the parameters in line 30
	java -jar /tools/trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 6 -phred33 \
	$FR $RR \ 
	-baseout $WD/$CS/$SM_trim.fq.gz \ 
	ILLUMINACLIP:$adapters:2:20:10 HEADCROP:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:6:25 MINLEN:36 

############## FASTQC to assess quality of the Cleaned sequence data
## FastQC: run on each of the data files that have 'All' to check the quality of the data
## The output from this analysis is a folder of results and a zipped file of results

cd $WD/$CS
fastqc *.trim.fq.gz --outdir=$WD/$CS

#######  Tarball the directory containing the FASTQC results so we can easily bring it back to our computer to evaluate.
## when finished use scp or rsync to bring the .gz file to your computer and open the .html file to evaluate
tar cvzf $CS.gz $WD/$CS/*
