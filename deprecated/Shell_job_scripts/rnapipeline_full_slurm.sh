#! /bin/bash

# run ref preparation

jid1=`sbatch ~/workflow/prep_ref_slurm.sh| sed 's/Submitted batch job //'`

# run read preparation

jid2=`sbatch --dependency=afterany:${jid1} ~/workflow/prep_reads_slurm.sh | sed 's/Submitted batch job //'`

# run alternative programs for transcript quantification
jid3=`sbatch --dependency=afterany:${jid2} ~/workflow/alt_counts_slurm.sh | sed 's/Submitted batch job //'`

# run read mapping

jid4=`sbatch --dependency=afterany:${jid2} ~/workflow/map_reads_slurm.sh | sed 's/Submitted batch job //'`

# run counting

jid5=`sbatch --dependency=afterany:${jid4} ~/workflow/count_reads_slurm.sh | sed 's/Submitted batch job //'`

# run merging count results

jid6=`sbatch --dependency=afterany:${jid5} ~/workflow/merge_counts_slurm.sh | sed 's/Submitted batch job //'`





## To Archive
## run test script 10/25/21, getting super weird error with last job. need to troubleshoot why it won't run

#jid4=`sbatch --dependency=afterany:${jid3} /scratch/adc0032/run_you.sh 1| sed 's/Submitted batch job //'`
	## something else is afoot here, because this wont run either
	## error message: >$ sbatch: error: Unable to open file 88932
	## after a quick ls, noticed that previous job is "88932"
	## output looks fine, and when I run the script that I am attempting to submit (count_reads_slurm.sh), I am getting output as well.  ??
	## RESOLVED; did not include space at the end of my sed statement after "job"; Moving comments and test to the end of the run before transfer to log
