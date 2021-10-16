#! /bin/bash

# Loading modules
module load star/2.7.5
module load samtools/1.11

# Variables: WD-working directory, SM-sample ID
WD=${2}
SM=${1}

# Conditional test for final bam else create it
if [ -s ${WD}/${SM}/${SM}_star.srt.bam ]; then
	echo "Reads for ${SM} have already been mapped with STAR, moving on..."
else

# STAR for mapping RNA-seq data: --readFilesCommand allows for reading in compressed files; --outStd SAM allows sam to be sent to STDOUT for piping
###samtools sort: convert the BAM file to a sorted BAM file.
STAR --genomeDir ${WD} --readFilesCommand gunzip -c \
--readFilesIn ${WD}/${SM}/${SM}_trim_1P.fq.gz ${WD}/${SM}/${SM}_trim_2P.fq.gz \
--runThreadN 12 --outFileNamePrefix ${WD}/${SM}/${SM}_star --outStd SAM | samtools sort -o ${WD}/${SM}/${SM}_star.srt.bam

samtools index
fi


