#!/bin/bash
#SBATCH --job-name=admixture45
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=124gb
#SBATCH --time=12:00:00
#SBATCH --output=admixture45.out
#SBATCH --error=admixture45.err

./admixture --cv=10 -j8 /home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/hypo_all_25_filtered.bed 4
./admixture --cv=10 -j8 /home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/hypo_all_25_filtered.bed 5

### repeat above line, changing only the last number to the K value you want to analyze ###
