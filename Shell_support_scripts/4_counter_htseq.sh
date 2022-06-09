#! /bin/bash

# Load Modules
module load python/3.9.2


# Variables: WD-working directory,SM-sample sorted bam, RFP-reference prefix, MP-mapper, ID-sample ID
WD=${2}
SM=${1}
RFP=${3}
MP=`echo ${SM}|awk -F"_" '{print $2}'|awk -F"." '{print $1}'`
ID=`echo ${SM}|awk -F"_" '{print $1}'`

if [ -s "${ID}/${ID}_${MP}_htscount.txt" ]; then
	echo "Htseq counting has already been completed; moving on..."
else

# HTSeq: finish commenting -s reverse-reverse first stranded
htseq-count -f bam -s reverse -m intersection-nonempty ${WD}/${ID}/${SM} ${RFP}.gtf > ${ID}/${ID}_${MP}_htscount.txt

fi

