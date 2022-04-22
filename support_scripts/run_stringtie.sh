#! /bin/bash


# Load Modules
module load stringtie/2.1.6


# Variables: WD-working directory,SM-sample sorted bam, RFP-reference prefix, MP-mapper, ID-sample ID
WD=${2}
SM=${1}
RFP=${3}
MP=`echo ${SM}|awk -F"_" '{print $2}'|awk -F"." '{print $1}'`
ID=`echo ${SM}|awk -F"_" '{print $1}'`

if [ -s "${WD}/${ID}/bg_${ID}_${MP}/stringtie_${MP}_${ID}.gtf" ]; then 
        echo "Stringtie counting has already been completed; moving on..."
else
# Stringtie Assembly: -e limits from making new transcripts, -B formats for ballgown, --rf reverse first stranded library
stringtie -e --rf -B -G ${WD}/${RFP}.gtf -o ${WD}/${ID}/bg_${ID}_${MP}/stringtie_${MP}_${ID}.gtf ${WD}/${ID}/${SM}

# Add GTF to file list for prepDE.py3 script to generate gene_count & transcript_count tables
printf '%s\t%s\n' "${ID}" "${ID}/bg_${ID}_${MP}/stringtie_${MP}_${ID}.gtf" >> ${WD}/${MP}_list_prepDE.txt
fi
