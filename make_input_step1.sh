#!/bin/bash
#SBATCH --job-name=make_input
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=4:00:00
#SBATCH --mem=250gb
#SBATCH --output=make_input1_allo.out
#SBATCH --error=make_input1_allo.err

#load modules and dependencies
module load GCC/12.3.0
module load VCFtools/0.1.16

#make .ped .map files
## if file is gzipped or bgzipped:
vcftools --gzvcf ../../snp_data/biallelic_ot.recode.vcf.gz --out ot --plink
## if file is uncompressed:
vcftools --vcf ../../snp_data/ --out sym_ot --plink
