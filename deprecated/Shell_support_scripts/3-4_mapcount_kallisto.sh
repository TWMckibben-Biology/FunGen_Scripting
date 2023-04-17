#! /bin/bash

source ~/.bashrc

# Loading modules
#module load kallisto/0.46.2

conda activate MapFreeRNA

# Variales: WD-working directory, SM-sample ID
WD=${2}
SM=${1}

# Conditional test for final output else create it. 
if [ -s "${WD}/${SM}/kallisto_quant/abundance.tsv" ]; then
        echo "Reads for ${SM} have already be processed by Kallisto, moving on..."
else
# use kallisto to generate counts
kallisto quant -i kallisto_index -o ${WD}/${SM}/kallisto_quant --rf-stranded ${WD}/${SM}/${SM}_trim_1P.fq.gz ${WD}/${SM}/${SM}_trim_2P.fq.gz  
fi

