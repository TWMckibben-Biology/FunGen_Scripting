#! /bin/bash

## Purpose: The purpose of this script is to assign and count reads mapped to genes.
## Input Data: Binary sequence alignment file (BAM); General transfer format (gene feature) file (GTF)
## Output Data: Text files with counts per gene and summary information (TXT)
## More Information: https://htseq.readthedocs.io/en/master/tutorials/tutorial_exon_level.html

# Load Modules
module load python/3.9.2


# Variables: working directory(WD),sample sorted bam(SM), reference prefix(RFP), mapper(MP), sample ID (ID)
WD=${2}
SM=${1}
RFP=${3}
MP=`echo ${SM}|awk -F"_" '{print $2}'|awk -F"." '{print $1}'` # extract the mapper used to generate input BAM file
ID=`echo ${SM}|awk -F"_" '{print $1}'` # extract sample ID for input BAM file

# Sanity Check that counting has not already been completed for these data
if [ -s "${ID}/${ID}_${MP}_htscount.txt" ]; then
	echo "Htseq counting has already been completed; moving on..."
else

# Count reads mapped to genes indicating a first stranded library (see accompanying tutorial page on strandeness for more information)
htseq-count -f bam -s reverse -m intersection-nonempty ${WD}/${ID}/${SM} ${RFP}.gtf > ${ID}/${ID}_${MP}_htscount.txt

fi

