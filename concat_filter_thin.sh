#!/bin/bash
#SBATCH --job-name=concat_filter_thin
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=24:00:00
#SBATCH --mem=124gb
#SBATCH --output=concat_filter_thin.out
#SBATCH --error=concat_filter_thin.err

module load GCCcore/12.3.0 BCFtools/1.17

# ==========================
# Paths
# ==========================
VCF_DIR="/home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/Comal_hypo/genotyped"
OUT_DIR="${VCF_DIR}/combined"
mkdir -p $OUT_DIR

# ==========================
# Step 1. Gather all VCFs
# ==========================
VCF_LIST=$(ls ${VCF_DIR}/Chr*.vcf | sort -V)

# ==========================
# Step 2. Concatenate into one big genome-wide VCF
# ==========================
#bcftools concat -Oz -o ${OUT_DIR}/cohort_all.vcf $VCF_LIST
#bcftools index ${OUT_DIR}/cohort_all.vcf

# ==========================
# Step 3. Keep only biallelic SNPs
# ==========================
#bcftools view -v snps -m2 -M2 ${OUT_DIR}/cohort_all.vcf.gz -Oz -o ${OUT_DIR}/cohort_all_biallelic.vcf.gz
#bcftools index ${OUT_DIR}/cohort_all_biallelic.vcf.gz

# ==========================
# Step 4. Thin to 1 kb
# ==========================
bcftools view --thin 1000 ${OUT_DIR}/cohort_all_biallelic.vcf.gz -Oz -o ${OUT_DIR}/cohort_all_biallelic_thin1kb.vcf.gz
bcftools index ${OUT_DIR}/cohort_all_biallelic_thin1kb.vcf.gz

echo "Finished: Final file is ${OUT_DIR}/cohort_all_biallelic_thin1kb.vcf.gz"
