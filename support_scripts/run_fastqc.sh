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
else
	fastqc --outdir=${WD}/${ID}/${TS} ${WD}/${SM}
fi
