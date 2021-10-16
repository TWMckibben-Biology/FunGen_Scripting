#! /bin/bash

# Modules
module load hisat2/2.2.1
module load gffreader/12.7
module load star/2.7.5

# Variables: working directory(WD), reference(RF), gff file(GF), reference prefix(RFP)
WD=${2}
RF=${1}
RFP=${3}
GF="${RFP}.gff3"

#Conditional test for gff3 to gtf conversion
if [ -s ${WD}/${RFP}.gtf ]; then
	echo "${GF} has already been converted to GTF format, moving on..."
else
# generating gtf from gff
gffread ${WD}/${GF} -T -o ${WD}/${RFP}.gtf
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
i1=`ls ${WD}/*.ht2|head -1`
i8=`ls ${WD}/*.ht2|tail -1`

if [[ -s ${i1} && -s ${i8} ]]; then
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
--sjdbGTFfile ${WD}/${RFP}.gtf --sjdbGTFtagExonParentTranscript transcript_id \
--genomeSAindexNbases 12
fi
