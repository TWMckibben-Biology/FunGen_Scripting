#! /bin/bash

# Modules
module load sratoolkit/2.11.0

# Variables, given as arguments in the caller script: working directory (WD), sample (SM), metadata file (MT) sra id w/ path (SRA)
WD=${2}
SM=${1}
MT=${3}
SRA="${WD}/${SM}"

# move into  WD
cd ${WD}

# Prefetch data
# check to see if file has already been prefetched
if [[ -s ${SRA}/${SM}.sra ]]
then
	echo "${SM} has been prefetched "
else
# else prefetch the data and sleep for 5 seconds
	prefetch -X 50G ${SM}
	sleep 5
fi

# Dump data
# check if SRR is already downloaded
if [[ -s ${SRA}/${SM}_*.fastq.gz ]]
then
	echo "${SM} has already been dumped, moving on..."
else
	# check for prefetched data, dump, and validate
	if [[ -s ${SRA}/${SM}.sra ]]
	then
		fastq-dump --split-files --gzip -O ${SRA}  ${SRA}/${SM}.sra
	else
		# else, prefetch,dump the data, and validate
		echo "${SM} is not in ${SRA}. Starting from prefetch again..."
		prefetch -X 50G ${SM}
		sleep 5
		fastq-dump --split-files --gzip -O ${SRA} ${SRA}/${SM}.sra
	fi
fi


