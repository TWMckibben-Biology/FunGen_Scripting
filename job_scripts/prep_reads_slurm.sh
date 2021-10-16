#! /bin/bash

#SBATCH -J DpulexCaloric_prepreads
#SBATCH -t 2-00:00:00
#SBATCH -N 1
#SBATCH -n 10
#SBATCH -o %x-%A-%a.out
#SBATCH -e %x-%A-%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=adc0032@auburn.edu
#SBATCH --array=1-10

# %x = job name, %j = job id, %A = array job id, %a = array task id


## Variables: data(dd), working(wd), and save(sd) directory; reference(ref), metadata(met), jobfile(jf), reference prefix(rfp) 
dd="/home/adc0032/DpulexCaloricWD/Data" # may exclude because I will probably make this in script
wd="/scratch/adc0032/DpulexCaloricWD"
sd="/home/adc0032/DpulexCaloricSD"
ref="${wd}/Daphnia_pulex.scaffolds.fa"
met="${wd}/dpulex.calor.meta"
jf="${wd}/dpulex.calor.jf"
rfp=`basename ${ref} | cut -d "." -f 1`

##Commands

# moving into wd, if exists; if not generate the directory and its parent directories. Also silence directory exists message
if [ -d ${wd} ]; then
	cd ${wd}
else
	mkdir -p ${wd}
	cd ${wd}
fi


# sample pulled from array task id (this should be the number of samples you have on your jf list and should be specified in the #SBATCH header)
sm=$( head -n ${SLURM_ARRAY_TASK_ID} ${jf} | tail -n 1)

# If the fastq data is not in a self-labeled directory in the wd, dump the data with sratools; see download_SRA_a.sh for more comments and details
source ~/workflow/download_SRA.sh ${sm} ${wd} ${met}

# make pre-trim directory
mkdir -p ${wd}/${sm}/pretrim

# make array of fq files
fqs=(`ls ${sm}/*.fastq.gz`)

# Run fastqc (pre-trim)
printf '%s\n' "${fqs[@]}"|parallel "source ~/workflow/run_fastqc.sh {} ${wd} pretrim"

# Run trimmomatic
source ~/workflow/run_trimmomatic.sh ${sm} ${wd}

# make post-trim directory
mkdir -p ${wd}/${sm}/posttrim

# make array of trimmed fq files
tfqs=(`ls ${sm}/*_trim_*P.fq.gz`)

# Run fastqc (post-trim)
printf '%s\n' "${tfqs[@]}"|parallel "source ~/workflow/run_fastqc.sh {} ${wd} posttrim"
