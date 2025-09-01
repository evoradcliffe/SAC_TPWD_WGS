#!/bin/bash
#SBATCH --job-name=make_input_ot
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=3:00:00
#SBATCH --mem=320gb
#SBATCH --output=make_alloOTinput2_ot.out
#SBATCH --error=make_alloOTinput2_ot.err

#load modules and dependencies
module load GCC/12.3.0 PLINK/2.00a3.7
#make .bed .bim .fam files
plink --file ot_chr --pheno ot.pheno --pheno-name Sex --make-bed --out ot_chr

#check the output files: awk '{print $2, $6}' ot.fam
#male = 2 and female = 1
