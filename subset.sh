#!/bin/bash
#SBATCH --job-name=subset
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=144:00:00
#SBATCH --mem=50gb
#SBATCH --output=subset3.out
#SBATCH --error=subset3.err
#SBATCH --array=0-28

#   Load modules and dependencies
#   Used GATK 3 because GATK 4 does not have SelectVariants and VariantFiltration
module load Java/1.8.0_92
GATK="/home/wrad07/moranlab/shared/software/GATK/GATK_3.8/GenomeAnalysisTK.jar"
export _JAVA_OPTIONS="-Xmx300g"


#   Define paths for reference genome, genotyped data, and where our filtered data will go
REF="/home/wrad07/moranlab/shared/SAC_TPWD/pacbio/hifiasm_out/reformatted_SAC_SMR.fasta"
RAW="/home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/SMR/genotyped"
FILTERED="/home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/SMR/genotyped/filtered"


#   We define the output region based on the basename of the intervals file that specifies the chromosome or group of unscaffolded reads
#   This was read from the file-of-files
REGFOF="/home/wrad07/moranlab/shared/SAC_TPWD/species_ID/GATK_Regions.fof"
REGION=$(sed "${SLURM_ARRAY_TASK_ID}q;d" ${REGFOF})
REG_BNAME=$(basename ${REGION})
REG_OUT=${REG_BNAME/.intervals/}


##################################################
###### Subset NO_VARIATION, SNPS, MIXED/INDELS #######
##################################################
#   T = Program to run
#   R = Reference genome
#   V = input
#   o = output
#   [selectTypeToExclude = what to get rid of] or [selectType = what to keep]
#   nt = number of threads

#   Subset monomorphic sites
java -Djava.io.tmpdir=/tmp -jar ${GATK} \
    -T SelectVariants \
    -R ${REF} \
    -V ${RAW}/${REG_OUT}.vcf \
    --selectTypeToExclude INDEL \
    --selectTypeToExclude MIXED \
    --selectTypeToExclude MNP \
    --selectTypeToExclude SYMBOLIC \
    --selectTypeToInclude NO_VARIATION \
    -nt 32 \
    -o ${FILTERED}/subset_mono/${REG_OUT}_mono_subset.vcf

echo -n "Done: subset mono"
date

#   Subset SNPs
java -Djava.io.tmpdir=/tmp -jar ${GATK} \
    -T SelectVariants \
    -R ${REF} \
    -V ${RAW}/${REG_OUT}.vcf \
    -selectType SNP \
    -nt 32 \
    -o ${FILTERED}/subset_snps/${REG_OUT}_snps_subset.vcf

echo -n "Done: subset snps"
date


#   Subset mixed/indels
java -Djava.io.tmpdir=/tmp -jar ${GATK} \
    -T SelectVariants \
    -R ${REF} \
    -V ${RAW}/${REG_OUT}.vcf \
    -selectType MIXED \
    -selectType INDEL \
    -nt 32 \
     -o ${FILTERED}/subset_mixed/${REG_OUT}_mixed_indels_subset.vcf

echo -n "Done: subset mixed/indels"
date
