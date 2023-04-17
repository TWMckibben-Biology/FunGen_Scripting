#!/bin/sh
 
######### Intro to Scripting Final Project ##########
### This uses the mapper hisat2 and the counter stringtie to align our sequences with a reference genome and create a gene level count matrix

###Module Load###

source /opt/asn/etc/asn-bash-profiles-special/modules.sh
module load hisat2
module load stringtie/2.2.1
module load gffcompare
module load python/2.7.1
module load gcc/9.3.0
module load samtools
module load bcftools/1.2
module load gffread/
module load gffcompare/


#  Set the stack size to unlimited

ulimit -s unlimited

# Turn echo on so all commands are echoed in the output log. Not necessary for you but helps with debugging

set -x

##########  Define variables and make directories
### ONCE AGAIN PLEASE CHANGE THE MYID VARIABLE TO MATCH YOUR ASC ID ###

MyID=aubclsb0323         

WD=/scratch/$MyID/Scripting                           ## Example:/scratch/$MyID/PracticeRNAseq  
CLEAND=/scratch/$MyID/Scripting/CleanData2                      ## Example:/scratch/$MyID/PracticeRNAseq/CleanData20   #   *** This is where the cleaned paired files are located
REFD=/scratch/$MyID/Scripting/DaphniaRefGenome_6      ## Example:/scratch/$MyID/PracticeRNAseq/DaphniaRefGenome_6                      # this directory contains the indexed reference genome for the garter snake
MAPD=/scratch/$MyID/Scripting/Map_HiSat2_6            ## Example:/scratch/$MyID/PracticeRNAseq/Map_HiSat2_6
COUNTSD=/scratch/$MyID/Scripting/Counts_StringTie_6   ## Example:/scratch/$MyID/PracticeRNAseq/Counts_StringTie_6

RESULTSD=/home/aubclsb0323/FunGen_Scripting/Counts_H_S_6     

REF=DaphniaPulex_RefGenome_PA42_v3.0                  ## This is what the "easy name" will be for the genome reference

## Recursively make your new directories

mkdir -p $REFD
mkdir -p $MAPD
mkdir -p $COUNTSD
mkdir -p $RESULTSD
mkdir -p $CLEAND

##################  Prepare the Reference Index for mapping with HiSat2   #############################

cd $REFD
cp ~/class_shared/references/DaphniaPulex/PA42/$REF.fasta .
cp ~/class_shared/references/DaphniaPulex/PA42/$REF.gff3 .

###  Identify exons and splice sites

gffread $REF.gff3 -T -o $REF.gtf               ## gffread converts the annotation file from .gff3 to .gft formate for HiSat2 to use.
extract_splice_sites.py $REF.gtf > $REF.ss
extract_exons.py $REF.gtf > $REF.exon

#### Create a HISAT2 index for the reference genome

hisat2-build --ss $REF.ss --exon $REF.exon $REF.fasta DpulPA42_index

########################  Map and Count the Data using HiSAT2 and StringTie  ########################

# Move to the data directory

cd $CLEAND  
cp /scratch/$MyID/Scripting/CleanData/*_paired.fastq .

## Create list of sequences to map. Identical to previous script

ls | grep ".fastq" |cut -d "_" -f 1| sort | uniq > list    

## Move to the directory for mapping

cd $MAPD

## move the list of unique ids from the original files to map

mv $CLEAND/list . 

while read i;
do

  ## HiSat2 is the mapping program
  ##  -p indicates number of processors, --dta reports alignments for StringTie --rf is the read orientation

   hisat2 -p 6 --dta --phred33       \
    -x "$REFD"/DpulPA42_index       \
    -1 "$CLEAND"/"$i"_1_paired.fastq  -2 "$CLEAND"/"$i"_2_paired.fastq      \
    -S "$i".sam

    ### view: convert the SAM file into a BAM file  -bS: BAM is the binary format corresponding to the SAM text format.
    ### sort: convert the BAM file to a sorted BAM file.
    ### Example Input: SRR629651.sam; Output: SRR629651_sorted.bam

  samtools view -@ 6 -bS "$i".sam > "$i".bam
  samtools sort -@ 6  "$i".bam    "$i"_sorted

    ### Index the BAM and get mapping statistics

  samtools flagstat   "$i"_sorted.bam   > "$i"_Stats.txt

  ### Stringtie counts the reads mapped to the reference genome by sample ID

mkdir "$COUNTSD"/"$i"
stringtie -p 6 -e -B -G  "$REFD"/"$REF".gtf -o "$COUNTSD"/"$i"/"$i".gtf -l "$i"   "$MAPD"/"$i"_sorted.bam

done < list

### Bring these results back to your pc
### I brought them back to the repo file for easy uploading

cp *.txt $RESULTSD

### The prepDE.py is a python script that converts the files in your ballgown folder to a count matrix
cd $COUNTSD
python /home/$MyID/class_shared/prepDE.py -i $COUNTSD

### copy the final results files (the count matricies that are .cvs to your home directory)
cp *.csv $RESULTSD

