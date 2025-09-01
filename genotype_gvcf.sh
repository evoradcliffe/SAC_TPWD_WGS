#!/bin/bash
#SBATCH --job-name=genotype_gvcf_hypo
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=72:00:00
#SBATCH --mem=320gb
#SBATCH --output=genotype_gvcf.out
#SBATCH --error=genotype_gvcf.err
#SBATCH --array=0-28

# Print when the script began running
echo -n "Ran: "
date

# Load Java (GATK 3.8 requires Java 8)
module purge
module load Java/1.8.0_292-OpenJDK

# Set paths
GATK="/scratch/group/moranlab/shared/software/GATK/GATK_3.8/GenomeAnalysisTK.jar"
REF="/home/wrad07/moranlab/shared/SAC_TPWD/pacbio/hifiasm_out/reformatted_SAC_SMR.fasta"
REGFOF="/home/wrad07/moranlab/shared/SAC_TPWD/species_ID/GATK_Regions.fof"
COMBINED_GVCF="/home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/Comal_hypo/cohort_combined.g.vcf"
OUTPUT_DIR="/home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/Comal_hypo/genotyped"

# Get the region
REGION=$(sed "${SLURM_ARRAY_TASK_ID}q;d" ${REGFOF})
REG_BNAME=$(basename ${REGION})
REG_OUT=${REG_BNAME/.intervals/}

echo "Processing region: $REGION"

# Set Java heap space
export _JAVA_OPTIONS="-Xmx300g"

# Run GenotypeGVCFs
java -Djava.io.tmpdir=/tmp \
    -jar ${GATK} \
    -T GenotypeGVCFs \
    -R ${REF} \
    -V ${COMBINED_GVCF} \
    -L ${REGION} \
    -nt 32 \
    --includeNonVariantSites \
    --heterozygosity 0.005 \
    -o ${OUTPUT_DIR}/${REG_OUT}.vcf

echo -n "Done: "
date
