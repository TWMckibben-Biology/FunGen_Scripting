#! /bin/bash

## Purpose: The purpose of this script is to map trimmed reads to an indexed reference (genome or transcriptome).
## Input Data: Trimmed R1 & R2 paired reads (FASTQ); Reference index 
## Output Data: Sequence aligment file (binary- BAM)
## More Information: http://daehwankimlab.github.io/hisat2/manual/

# Loading modules
module load hisat2/2.2.1
module load samtools/1.11

# Variales: working directory(WD), sample ID (SM)
WD=${2}
SM=${1}

# Sanity Check that desired bam file does not already exist 
if [ -s "${WD}/${SM}/${SM}_hisat2.srt.bam" ]; then
	echo "Reads for ${SM} have already been mapped using hisat2, moving on..."
else
# -dta; Reports alignments tailored for transcript assemblers, -x; Specifes the index prefix to use
# hisat2 writes to STDOUT. Piping the output to samtools sort for conversion to a sorted BAM file (fewer intermediate files == space saver).

hisat2 --dta -x ${WD}/DP_INDEX -1 ${WD}/${SM}/${SM}_trim_1P.fq.gz -2 ${WD}/${SM}/${SM}_trim_2P.fq.gz | samtools sort -o "${WD}/${SM}/${SM}_hisat2.srt.bam"

# generate BAM index
samtools index "${WD}/${SM}/${SM}_hisat2.srt.bam"
fi
