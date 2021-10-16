#! /bin/bash

# Modules
module load fastqc/0.11.9

# Variables: working directory(WD), sample(SM), trim status(TS), run id(ID)
WD=${2}
SM=${1}
TS=${3}
ID=`basename ${SM}|awk -F"_" '{print $1}'`

if [ ! -s ${SM} ]; then
	echo "${SM} was not found, aborting..."
	exit 1
elif [[ -s "${WD}/${ID}/${TS}/${ID}_2_fastqc.zip" || -s "${WD}/${ID}/${TS}/${ID}_trim_2P_fastqc.zip" ]]; then
	echo "FASTQC has been run for ${ID} fastq files, moving on..."
else
	fastqc --outdir=${WD}/${ID}/${TS} ${WD}/${SM}
fi
