#! /bin/bash

#SBATCH -J DpulexCaloric_mergecounts
#SBATCH -t 4-00:00:00
#SBATCH -N 1
#SBATCH -n 15
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


# array of mappers
mappers=(hisat2 star)

# run prepDE.py3 from stringtie on stringtie output to generate gene and transript count tables from all samples (counts merged into one file) 
printf '%s\n' "${mappers[@]}" | parallel "python ~/programs/stringtie/prepDE.py3 -i ${wd}/{}_list_prepDE.txt -g ${wd}/{}_gene_count -t ${wd}/{}_transcript_count"

# sort prepDE.py3 output for gene and transcript files
printf '%s\n' "${mappers[@]}" | parallel "head -1 {}_gene_count > {}_gene_count_matrix.csv; awk 'NR>1' {}_gene_count|sort -V -k1,1 >> {}_gene_count_matrix.csv"

printf '%s\n' "${mappers[@]}" | parallel "head -1 {}_transcript_count > {}_transcript_count_matrix.csv; awk 'NR>1' {}_transcript_count|sort -V -k1,1 >> {}_transcript_count_matrix.csv"

printf '%s\n' "${mappers[@]}" | parallel "mv {}_gene_count {}_gene_count_unsrt; mv {}_transcript_count {}_transcript_count_unsrt"

# similarly, generate count table (gene) from all samples for htseq output
for i in ${mappers[@]}
do

files=(`find ./ -name "*_${i}_htscount.txt" | sort`)
head -1 ${i}_gene_count_matrix.csv > ${i}_htscount_matrix.csv
paste ${files[@]} | awk 'OFS="," {print $1,$2,$4,$6,$8,$10,$12,$14,$16,$18,$20}' >> ${i}_htscount_matrix.csv

done
