#! /bin/bash

## Purpose: The purpose of this script is to trim sequencing adapters and low quality regions from the read data.
## Input Data: Raw R1 & R2 reads (FASTQ); Adapter sequences to remove (FASTA)
## Output Data: Trimmed R1 & R2 paired and unpaired reads (FASTQ)
## More Information: http://www.usadellab.org/cms/?page=trimmomatic

# Modules
module load trimmomatic/0.39

# Variables: working directory(WD), sample(SM), forward read(lft), reverse read(rgt)
WD=${2}
SM=${1}
lft="${WD}/${SM}/${SM}_1.fastq.gz"
rgt="${WD}/${SM}/${SM}_2.fastq.gz"
adapters="${WD}/AdaptersToTrim.fa"

# Sanity Check that the left read (R1) exists in the indicated directory
if [ ! -s ${lft} ];then
	echo "${lft} was not found, aborting..."
	exit 1
# Sanity Check that the trimmed reads (by checking for the trimmed right (R2) read) 
elif [ -s "${SM}/${SM}_trim_2P.fq.gz" ]; then
	echo "${SM} reads have already been trimmed, moving on..."
else
# Run trimmomatic in paired end mode with 6 threads using phred 33 quality score format. 
#Check out the trimmomatic documentation to understand the parameters in line 30
	java -jar /tools/trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 6 -phred33 \
	${lft} ${rgt} \ 
	-baseout ${WD}/${SM}/${SM}_trim.fq.gz \ 
	ILLUMINACLIP:${adapters}:2:20:10 HEADCROP:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:6:25 MINLEN:36 
fi
