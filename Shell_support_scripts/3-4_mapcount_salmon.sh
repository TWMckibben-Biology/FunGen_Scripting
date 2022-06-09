#! /bin/bash

# Loading modules
module load salmon/1.5.1
module load samtools/1.11

# Variales: WD-working directory, SM-sample ID
WD=${2}
SM=${1}

# Conditional test for final output else create it. 
if [ -s ${WD}/${SM}/${SM}_salmon_quant ]; then
	echo "Reads for ${SM} have already been processed by Salmon"
else
# use salmon to generate counts
salmon quant -i salmon_index -l A -1 ${WD}/${SM}/${SM}_trim_1P.fq.gz -2 ${WD}/${SM}/${SM}_trim_2P.fq.gz  -o ${WD}/${SM}/${SM}_salmon_quant
fi
