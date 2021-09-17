#! /bin/bash

# Modules
module load sratoolkit/2.11.0

# Variables
WD="/scratch/adc0032/DpulexCaloricWD"
zSRRs="${WD}/SRA_acc_list.txt"

# head to WD and make a directory for fastq files
cd ${WD}
mkdir SRRs

# Prefetch data
for line in `cat ${zSRRs}`
do
SRAs="${WD}/${line}"

# check to see if file has already been prefetched
if [[ -s ${SRAs}/${line}.sra ]]
then
	echo "${line} has been prefetched "
else
# else prefetch the data
	prefetch -X 50G ${line}
	sleep 5
fi
done

# Dump data
for line in `cat ${zSRRs}`
do
SRAs="${WD}/${line}"

# check if SRR is already downloaded
if [[ -s ${WD}/SRRs/$line_*.fastq.gz ]]
then
	echo "${line} has already been dumped, moving on..."
else
	# check for prefetched data, dump, and validate
	if [[ -s ${SRA}/${line}.sra ]]
	then
		fastq-dump --split-files --gzip -O ${WD}/SRRs ${SRAs}/${line}.sra
	else
		# else, prefetch,dump the data, and validate
		echo "${line} is not in ${SRAs}. Starting from prefetch again..."
		prefetch -X 50G ${line}
		fastq-dump --split-files --gzip -O ${WD}/SRRs ${SRAs}/${line}.sra
	fi
fi
done

