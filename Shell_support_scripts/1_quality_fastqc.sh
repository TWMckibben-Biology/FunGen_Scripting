#! /bin/bash

## Purpose: The purpose of this script is to evaluate the quality of the raw Illumina sequencing data.
## Input: Two raw paired-end (PE)sequece read files, typically referred to as R1 & R2)(.fastq or .fq)
## Output: A directory for each sample with ZIP & HTML files; Download HTML files to view QC results in a web browser
## More Information: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/INSTALL.txt
## Recommended Run Parameters on Alabama Super Computer: 

# Modules
module load fastqc/0.11.9

# Define Your Variables: replace these numbers with your working directory(WD), read file name (RD), pre or post clean status (CS), run id(ID)
## for example
	## WD=${/
WD=${2}
RD=${1}
CS=${3}
ID=`basename ${RD}|awk -F"_" '{print $1}'` #generates a run id variable with the first field of the read name (delimited by underscores)

# Sanity Check that the read file exists (full path is provided from parent script, hence basename command to strip path in line 15)
if [ ! -s ${RD} ]; then
	echo "${RD} was not found, aborting..."
	exit 1
	
# Sanity Check if prior FASTQC files have been generated for these data to save on run time & HPC resources. 	
elif [[ -s "${WD}/${ID}/${CS}/${ID}_2_fastqc.zip" || -s "${WD}/${ID}/${CS}/${ID}_trim_2P_fastqc.zip" ]]; then
	echo "FASTQC has been run for ${ID} fastq files, moving on..."
else

# If not a previous run, run fastqc on the specified read file, and provide an output directory based on the ID and pre/post trim status. 
	fastqc --outdir=${WD}/${ID}/${CS} ${WD}/${RD}
fi
