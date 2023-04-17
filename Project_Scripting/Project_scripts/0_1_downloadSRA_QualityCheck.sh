#! /bin/bash

######### Intro to Scripting Final Project ##########

###ASC Use###
#use 'run_script 0_1_downloadSRA_QualityCheck.sh' to launch script
#I used the 'small' queue with maxed cpu and memory settings, default on all others

########## Load Modules

source /opt/asn/etc/asn-bash-profiles-special/modules.sh
module load sra
module load fastqc/0.10.1

##########  Define variables and make directories
## Replace the numbers in the brackets with Your specific information
  ## make variable for your ASC ID so the directories are automatically made in YOUR directory

MyID=aubclsb0323          ## Example: MyID=aubtss

  ## Make variable that represents YOUR working directory(WD) in scratch, your Raw data directory (DD) and the pre or postcleaned status (CS).

DD=/scratch/$MyID/Scripting/RawData   			## Example: DD=/scratch/$MyID/PracticeRNAseq/RawData
WD=/scratch/$MyID/Scripting				## Example: WD=/scratch/$MyID/PracticeRNAseq
CS=PreCleanQuality
 
## Recursively make the directories in SCRATCH for holding the raw data 

mkdir -p $DD

## move to the Data Directory

cd $DD

##########  Download data files from NCBI: SRA using the Run IDs
  ### from SRA use the SRA tool kit - see NCBI website https://www.ncbi.nlm.nih.gov/sra/docs/sradownload/
	## this downloads the SRA file and converts to fastq
	## -F 	Defline contains only original sequence name.
	## splits the files into R1 and R2 (forward reads, reverse reads)

## These samples are from Bioproject PRJNA437447. An experiment on Daphnia pulex, 5 samples on ad lib feed, 5 samples on caloric restriction diet
## https://www.ncbi.nlm.nih.gov/bioproject?LinkName=sra_bioproject&from_uid=5206312

vdb-config --interactive

fastq-dump -F --split-files SRR6819014
fastq-dump -F --split-files SRR6819015
fastq-dump -F --split-files SRR6819016
fastq-dump -F --split-files SRR6819017
fastq-dump -F --split-files SRR6819018
fastq-dump -F --split-files SRR6819019
fastq-dump -F --split-files SRR6819020
fastq-dump -F --split-files SRR6819021
fastq-dump -F --split-files SRR6819022
fastq-dump -F --split-files SRR6819023

############## FASTQC to assess quality of the sequence data
## FastQC: run on each of the data files that have 'All' to check the quality of the data
## The output from this analysis is a folder of results and a zipped file of results

mkdir $WD/$CS
fastqc *.fastq --outdir=$WD/$CS

#######  Tarball the directory containing the FASTQC results so we can easily bring it back to our computer to evaluate.
### I moved them to my github directory so I could directly upload them

cd $WD/$CS
tar cvzf $CS.tar.gz $WD/$CS/*
