#!/bin/bash
#SBATCH --job-name=biallelic_maf
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=72:00:00
#SBATCH --mem=320gb
#SBATCH --output=biallelic_maf.out
#SBATCH --error=biallelic_maf.err

module load GCC/11.2.0
module load BCFtools/1.14
module load SAMtools/1.14

# Set the directory where your merged VCF files are stored
VCF_DIR="/home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/Comal_hypo/genotyped/filtered/filtered_snps"
OUTPUT_DIR="/home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/Comal_hypo/genotyped/filtered/biallelic_filtered"

# Create the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Loop over each VCF file in the combined_filtered directory
for VCF_FILE in $VCF_DIR/*_snps_filtered_PASS_ONLY.vcf; do
    # Extract the base name of the file (without path)
    BASENAME=$(basename $VCF_FILE .vcf)

    # Define the output file paths
    BIALLELIC_VCF="$OUTPUT_DIR/${BASENAME}_biallelic.vcf"
    BIALLELIC_NO_MAF_VCF="$OUTPUT_DIR/${BASENAME}_biallelic_nolowmaf.vcf"

    echo "Processing $VCF_FILE..."

    # Step 1: Retain biallelic variants
    bcftools view $VCF_FILE -M2 --threads 32 -o $BIALLELIC_VCF

    # Step 2: Remove variants with MAF < 0.01
    bcftools view $BIALLELIC_VCF -e 'MAF<0.01' --threads 32 -o $BIALLELIC_NO_MAF_VCF

    echo "Finished processing $VCF_FILE. Output saved to $BIALLELIC_NO_MAF_VCF"
done
