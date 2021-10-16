#! /bin/bash

# Load Modules
module load python/3.9.2


# Variables: WD-working directory,SM-sample sorted bam, RFP-reference prefix, MP-mapper, ID-sample ID
WD=${2}
SM=${1}
RFP=${3}
MP=`echo ${SM}|awk -F"_" '{print $2}'|awk -F"." '{print $1}'`
ID=`echo ${SM}|awk -F"_" '{print $1}'`


# HTSeq

htseq-count -f bam -s no -m intersection-nonempty ${WD}/${ID}/${SM} ${RFP}.gtf > ${ID}/${ID}_${MP}_htscount.txt


