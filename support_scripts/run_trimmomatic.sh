#! /bin/bash


# Modules
module load trimmomatic/0.39

# Variables: working directory(WD), sample(SM), forward read(lft), reverse read(rgt)
WD=${2}
SM=${1}
lft="${WD}/${SM}/${SM}_1.fastq.gz"
rgt="${WD}/${SM}/${SM}_2.fastq.gz"
adapters="${WD}/AdaptersToTrim.fa"

if [ ! -s ${lft} ];then
	echo "${lft} was not found, aborting..."
	exit 1
elif [ -s "${SM}/${SM}_trim_2P.fq.gz" ]; then
	echo "${SM} reads have already been trimmed, moving on..."
else
	java -jar /tools/trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 6 -phred33 \
	${lft} ${rgt} \
	-baseout ${WD}/${SM}/${SM}_trim.fq.gz \
	ILLUMINACLIP:${adapters}:2:20:10 HEADCROP:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:6:25 MINLEN:36
fi
