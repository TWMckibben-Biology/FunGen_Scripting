#! /bin/bash

# Running my bashrc so that the system can find my conda configurations
source ~/.bashrc

# Modules
module load hisat2/2.2.1
module load star/2.7.5
module load salmon/1.5.1
module load kallisto/0.46.2

conda activate MapFreeRNA

# Variables: working directory(WD), reference(RF), gff file(GF), reference prefix(RFP)
WD=${2}
RF=${1}
RFP=${3}
GF="${RFP}.gff3"

#Conditional test for gff3 to gtf conversion
if [[ -s "${WD}/${RFP}.gtf" && -s "${WD}/${RFP}.transcripts.fa" ]]; then
        echo "${GF} has already been converted to GTF format, moving on..."
else
# generating gtf from gff3; RSEM also generates the transcripts used for Salmon and Kallisto downstream
rsem-prepare-reference ${RF} ${RFP} --gff3 ${GF}
fi

#Conditional test for exon and splice site files
if [[ -s ${WD}/${RFP}.exon && -s ${WD}/${RFP}.ss ]]; then
	echo "${WD}/${RFP}.exon and ${WD}/${RFP}.ss have already been generated, moving on..."
else
# generatiing exon and splice site information
extract_splice_sites.py ${WD}/${RFP}.gtf > ${WD}/${RFP}.ss
extract_exons.py ${WD}/${RFP}.gtf > ${WD}/${RFP}.exon
fi

#Conditional test for first and last Hisat2 indices files
iF=`ls ${WD}/*.ht2|head -1`
iL=`ls ${WD}/*.ht2|tail -1`

if [[ -s ${iF} && -s ${iL} ]]; then
	echo "Hisat2 Genome Indexing has been performed, moving on... "
else
# building hisat2 index
hisat2-build --ss ${WD}/${RFP}.ss --exon ${WD}/${RFP}.exon ${RF} DP_INDEX
fi

#Conditional test for final STAR indices files
if [[ -s ${WD}/SA && -s ${WD}/SAindex ]]; then
	echo "STAR Genome Indexing has been performed, moving on..."
else
# building star index: setting genome directory to wd, using the sjdbGTFtagExonParentTranscript to use transcript_id as tag name to be used as exons’ transcript-parents relationship
	#10/12/21 edited "--genomeSAindexNbases" to 12 based on Log.out recommendation to avoid segment-default error when mapping
STAR --runMode genomeGenerate --genomeDir ${WD} --genomeFastaFiles ${RF} \
--sjdbGTFfile ${WD}/${RFP}.gtf --genomeSAindexNbases 12
fi

#Conditional test for files used to make Salmon indices
if [[ -s "${WD}/decoys.txt" && -s "${WD}/${RFP}.salmon.fa.gz" ]]; then
	echo "Files for Salmon indices present, moving on..."
else
# generating a list of decoys (full genome sequences) from the reference fasta
grep -e '^>' ${RF} |tr -d ">" > ${WD}/decoys.txt
# taking transcripts based on gtf extracted from genome using RSEM and concatenating with the full genome as bait for quasi-mapping
cat ${WD}/${RFP}.transcripts.fa ${RF} > ${WD}/${RFP}.salmon.fa
gzip ${WD}/${RFP}.salmon.fa
fi

if [ -s "${WD}/salmon_index" ]; then
	echo "Salmon Transcript Indexing has been performed, moving on..."
else
# generating salmon index; read salmon manual on logic for 31 kmer size for read sizes 75 bp and higher; read salmon FAQ on logic for --keepDuplicates flag
salmon index -p 12 --keepDuplicates -t ${WD}/${RFP}.salmon.fa.gz -i salmon_index --decoys decoys.txt -k 31
fi

if [ -s "${WD}/kallisto_index" ]; then
	echo "Kallisto Transcript Indexing has been performed, moving on..."
else
# generating kallisto index
kallisto index -i kallisto_index ${WD}/${RFP}.transcripts.fa
fi


###### Archived Code ######
#module load gffreader/12.7
#Conditional test for gff3 to gtf conversion
	#11/12/21 gtf is malformatted in this output. i.e. genes with T-1 suffixes, which should only be the case for transcripts. This problem wasn't in the gff3, but present after using this code.
#if [ -s ${WD}/${RFP}.gtf ]; then
#	echo "${GF} has already been converted to GTF format, moving on..."
#else
# generating gtf from gff
#gffread ${WD}/${GF} -T -o ${WD}/${RFP}.gtf
#fi
