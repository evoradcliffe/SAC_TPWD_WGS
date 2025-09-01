#!/bin/bash
#SBATCH --job-name=sex_association
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=2:00:00
#SBATCH --mem=320gb
#SBATCH --output=sex_association.out
#SBATCH --error=sex_association.err

#load modules and dependencies
module load GCC/12.2.0 OpenMPI/4.1.4 GEMMA/0.98.5

#gemma -bfile ${in_dir}/HERE -gk 2 -o ${in_dir}/HERE
#relatedness files: prefix.sXX.txt

in_dir="/home/wrad07/moranlab/shared/darters/sdr_mysia/sex_association/input"
output_dir="${in_dir}/output"

gemma -bfile ${in_dir}/NO_ADMIX -gk 2 -o NO_ADMIX
gemma -bfile ${in_dir}/NO_ADMIX -k ./output/NO_ADMIX.sXX.txt -lmm 4 -o NO_ADMIX
