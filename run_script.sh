#!/bin/bash
#SBATCH --job-name=plot
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=1:00:00
#SBATCH --mem=120gb
#SBATCH --output=plot.out
#SBATCH --error=plot.err


module load GCC/13.3.0 OpenMPI/5.0.3 R_tamu/4.4.2

Rscript your_script.R
