#! /bin/bash

#SBATCH -J DpulexCaloric_mapreads
#SBATCH -t 4-00:00:00
#SBATCH -N 1
#SBATCH -n 18
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

# array of mappers
mappers=(hisat2 star)

# run trimmed sample reads through hisat2 and through star
printf '%s\n' "${mappers[@]}" | parallel "sh ~/workflow/run_{}.sh ${sm} ${wd}"

