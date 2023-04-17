#! /bin/bash

#SBATCH -J DpulexCaloric_refprep
#SBATCH -t 2-00:00:00
#SBATCH -N 1
#SBATCH -n 10
#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=adc0032@auburn.edu

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

# run reference preparation; needs to be performed once

sh ~/workflow/prep_reference.sh ${ref} ${wd} ${rfp}

