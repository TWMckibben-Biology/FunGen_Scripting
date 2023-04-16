#! /bin/bash

###Trinity is a de novo assembler that does not require a reference in order to construct assemblies

source /opt/asn/etc/asn-bash-profiles-special/modules.sh
module load trinity
module load samtools

###Setting directory variables

MyID=aubclsb0323
DD=/scratch/$MyID/Scripting/CleanData2
OD=~/FunGen_Scripting/trinity

###Make a list of left and right reads. We're setting left as "1" and right as "2"
cd $DD
grep -l "*_1_*" > left
grep -l "*_2_*" > right
###Running Trinity

Trinity --seqType fq --max_memory 12G --left *_1_.fq --right *_2_.fq --CPU 6 --normalize_by_read_set --output $OD
