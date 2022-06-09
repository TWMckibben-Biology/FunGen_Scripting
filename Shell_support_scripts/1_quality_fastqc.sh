#! /bin/bash

## Purpose: The purpose of this script is to gain a sense of quality of the raw data.
## Input Data: Raw R1 & R2 reads (FASTQ)
## Output Data: Sample-specific directory with ZIP & HTML files; Download HTML files to view QC results in a web browser
## More Information: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/INSTALL.txt

# Modules
module load fastqc/0.11.9

# Variables: working directory(WD), Read file(RD), pre or post clean status(CS), run id(ID)
WD=${2}
RD=${1}
CS=${3}
ID=`basename ${RD}|awk -F"_" '{print $1}'` #generate a run id variable with the first field of the read name (delimited by underscores)

# Sanity Check that the read file exists (full path is provided from parent script, hence basename command to strip path in line 15)
if [ ! -s ${RD} ]; then
	echo "${RD} was not found, aborting..."
	exit 1
# Sanity Check that prior FASTQC files have been generated for these data to save on run time & HPC resources. 	
elif [[ -s "${WD}/${ID}/${CS}/${ID}_2_fastqc.zip" || -s "${WD}/${ID}/${CS}/${ID}_trim_2P_fastqc.zip" ]]; then
	echo "FASTQC has been run for ${ID} fastq files, moving on..."
else
# If not, run fastqc on the specified read file, and provide an output directory based on the SRR ID and pre/post trim status. 
	fastqc --outdir=${WD}/${ID}/${CS} ${WD}/${RD}
fi
