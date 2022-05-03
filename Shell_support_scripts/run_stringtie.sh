#! /bin/bash


# Load Modules
module load stringtie/2.1.6


# Variables: WD-working directory,SM-sample sorted bam, RFP-reference prefix, MP-mapper, ID-sample ID
WD=${2}
SM=${1}
RFP=${3}
MP=`echo ${SM}|awk -F"_" '{print $2}'|awk -F"." '{print $1}'`
ID=`echo ${SM}|awk -F"_" '{print $1}'`

# Stringtie Assembly: -e limits from making new transcripts, -B formats for ballgown
stringtie -e -B -G ${WD}/${RFP}.gtf -o ${ID}/bg_${ID}_${MP}.gtf -l ${ID}_${MP} ${WD}/${ID}/${SM}


## Array with generated gtfs from stringtie assembly
#GTFs=(`ls bg_${ID}/bg_${ID}_${MP}.gtf`)
## Merge assembled transcripts from all samples to make non-redundant gtf of features
#stringtie --merge -G ${WD}/${RFP}.gtf -o stringtie_${MP}_merged.gtf ${GTFs[@]}

