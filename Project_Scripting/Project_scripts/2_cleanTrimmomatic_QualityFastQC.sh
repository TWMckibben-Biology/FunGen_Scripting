#! /bin/bash

######## Intro to Scripting Final Project #########

# Modules

source /opt/asn/etc/asn-bash-profiles-special/modules.sh
module load trimmomatic/0.39
module load fastqc/0.10.1

### DO NOT FORGET TO CHANGE THIS VARIABLE TO YOUR ASC ID ###
# PRETTY PLEASE #
# You will erase my data otherwise #

MyID=aubclsb0323                        

# Variables: raw data directory (DD), working directory(WD), cleaned status (CS), name of file containing the adpaters.

WD=/scratch/$MyID/Scripting                          ## Example: WD=/scratch/$MyID/PracticeRNAseq
DD=/scratch/$MyID/Scripting/RawData                          ## Example: DD=/scratch/$MyID/PracticeRNAseq/RawData
CD=/scratch/$MyID/Scripting/CleanData                          ## Example: CD=/scratch/$MyID/PracticeRNAseq/CleanData
CS=PostCleanQuality
adapters=AdaptersToTrim_All.fa  ## This is the fasta file containing illumina adapter sequences contained in the functional genomics repo.
				
## make the directories to hold the Cleaned Data files, and the directory to hold the results for assessing quality of the cleaned data.

mkdir $CD
mkdir $WD/$CS

################ Trimmomatic ###################################
## Move to Raw Data Directory
cd $DD

### This command grabs all of the sequence accession headers and cuts them into a list, leaving only the unique IDs (aka no duplicates)

ls | grep ".fastq" |cut -d "_" -f 1 | sort | uniq > list

### Copy the illumina sequencing adapters list

cp /home/$MyID/class_shared/AdaptersToTrim_All.fa . 

### Run a while loop to process through the names in the list and Trim them with the Trimmomatic Code

while read i
do

        ### Run Trimmomatic on all sequences, chop the adapters, set the acceptable amplicon length, and the desired phred score

        java -jar /mnt/beegfs/home/aubmxa/.conda/envs/BioInfo_Tools/share/trimmomatic-0.39-1/trimmomatic.jar  PE -threads 6 -phred33 \
        "$i"_1.fastq "$i"_2.fastq  \
        $CD/"$i"_1_paired.fastq $CD/"$i"_1_unpaired.fastq  $CD/"$i"_2_paired.fastq $CD/"$i"_2_unpaired.fastq \
        ILLUMINACLIP:AdaptersToTrim_All.fa:2:35:10 HEADCROP:10 LEADING:30 TRAILING:30 SLIDINGWINDOW:6:30 MINLEN:36
        
                ## Trim read for quality when quality drops below Q30 and remove sequences shorter than 36 bp
                ## PE for paired end phred-score-type  R1-Infile   R2-Infile  R1-Paired-outfile R1-unpaired-outfile R-Paired-outfile R2-unpaired-outfile  Trimming paramenter
                ## MINLEN:<length> #length: Specifies the minimum length of reads to be kept.
                ## SLIDINGWINDOW:<windowSize>:<requiredQuality>  #windowSize: specifies the number of bases to average across  
                ## requiredQuality: specifies the average quality required.

	############## FASTQC to assess quality of the Cleaned sequence data
	## FastQC: run on each of the data files that have 'All' to check the quality of the data
	## The output from this analysis is a folder of results and a zipped file of results

fastqc $CD/"$i"_1_paired.fastq --outdir=$WD/$CS
fastqc $CD/"$i"_2_paired.fastq --outdir=$WD/$CS

done<list

### Move to your output directory and tarball your files
# From here I transferred this tar back into my repo clone on the ASC

cd $WD/$CS
tar cvzf $CS.tar.gz $WD/$CS/*
