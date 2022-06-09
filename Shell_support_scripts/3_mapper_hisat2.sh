#! /bin/bash

# Loading modules
module load hisat2/2.2.1
module load samtools/1.11

# Variales: WD-working directory, SM-sample ID
WD=${2}
SM=${1}

# Conditional test for final bam else create it. 
if [ -s "${WD}/${SM}/${SM}_hisat2.srt.bam" ]; then
	echo "Reads for ${SM} have already been mapped using hisat2, moving on..."
else
###-dta; Reports alignments tailored for transcript assemblers
###-x; Specifes the index file to use
###samtools sort: convert hisat2 STDOUT to a sorted BAM file.

hisat2 --dta -x ${WD}/DP_INDEX -1 ${WD}/${SM}/${SM}_trim_1P.fq.gz -2 ${WD}/${SM}/${SM}_trim_2P.fq.gz | samtools sort -o "${WD}/${SM}/${SM}_hisat2.srt.bam"

samtools index "${WD}/${SM}/${SM}_hisat2.srt.bam"
fi
