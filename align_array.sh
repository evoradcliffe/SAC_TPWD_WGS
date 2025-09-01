#!/bin/bash
#SBATCH --job-name=align_reads_Comal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=24:00:00
#SBATCH --mem=250gb
#SBATCH --output=align_reads.out
#SBATCH --error=align_reads.err
#SBATCH --array=0-## <-- change depending on how many lines are in the commands.txt file

#Load modules <-- check which modules are available to you and load those as needed!
module load GCC/13.2.0 seqtk/1.4 SAMtools/1.21
module load GCCcore/14.2.0 zlib/1.3.1
module load GCCcore/13.2.0 BWA/0.7.18

#Specify the job command list#
CMD_LIST="raw_comal_commands.txt"

#This is standard command to run an array!
CMD="$(sed "${SLURM_ARRAY_TASK_ID}q;d" ${CMD_LIST})"
eval ${CMD}
