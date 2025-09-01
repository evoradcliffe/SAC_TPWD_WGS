#!/bin/bash
#SBATCH --job-name=genotype_gvcf_single
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=48:00:00
#SBATCH --mem=320gb
#SBATCH --output=genotype_gvcf_%j.out
#SBATCH --error=genotype_gvcf_%j.err

echo -n "Ran: "
date

module purge
module load Java/1.8.0_292-OpenJDK

GATK="/scratch/group/moranlab/shared/software/GATK/GATK_3.8/GenomeAnalysisTK.jar"
REF="/home/wrad07/moranlab/shared/SAC_TPWD/pacbio/hifiasm_out/reformatted_SAC_SMR.fasta"
COMBINED_GVCF="/home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/Comal_hypo/cohort_combined.g.vcf"
OUTPUT_DIR="/home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/Comal_hypo/genotyped"

# >>> set this manually for each run <<<
REGION="/home/wrad07/moranlab/shared/SAC_TPWD/species_ID/Chr2.intervals"

REG_BNAME=$(basename ${REGION})
REG_OUT=${REG_BNAME/.intervals/}

echo "Processing region: $REGION"

export _JAVA_OPTIONS="-Xmx300g"

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
