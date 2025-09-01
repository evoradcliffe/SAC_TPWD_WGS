#!/bin/bash
#SBATCH --job-name=picard_array
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=48:00:00
#SBATCH --mem=50gb
#SBATCH --output=align_reads.out
#SBATCH --error=align_reads.err
#SBATCH --array=0-9 <-- again, change to the number of lines in command file but always start with 0!

#Load modules
module load picard/2.18.27-Java-1.8
module load Java/17

#Run the array using the previously generated command list
CMD_LIST="rgadd_commands.txt"
CMD_LIST="dups_commands.txt"

CMD="$(sed "${SLURM_ARRAY_TASK_ID}q;d" ${CMD_LIST})"
eval ${CMD}
