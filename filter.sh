#!/bin/bash
#SBATCH --job-name=filter
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=144:00:00
#SBATCH --mem=64gb
#SBATCH --output=filter1.out
#SBATCH --error=filter1.err
#SBATCH --array=0-28

#   Load modules and dependencies
#   Used GATK 3 because GATK 4 does not have SelectVariants and VariantFiltration
module load Java/1.8.0_92
GATK="/home/wrad07/moranlab/shared/software/GATK/GATK_3.8/GenomeAnalysisTK.jar"
export _JAVA_OPTIONS="-Xmx300g"


#   Define paths for reference genome, genotyped data, and where our filtered data will go
REF="/home/wrad07/moranlab/shared/SAC_TPWD/alignment_and_genotyping/Hypostomus_genome.fasta"
RAW="/home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/genotyped"
FILTERED="/home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/genotyped/filtered"


#   We define the output region based on the basename of the intervals file that specifies the chromosome or group of unscaffolded reads
#   This was read from the file-of-files
REGFOF="/home/wrad07/moranlab/shared/SAC_TPWD/alignment_and_genotyping/GATK_Regions.fof"
#REGION=$(sed "${SLURM_ARRAY_TASK_ID}q;d" ${REGFOF})
#REG_BNAME=$(basename ${REGION})
#REG_OUT=${REG_BNAME/.intervals/}

##############################
######   Hard Filter  ########
##############################
#   T = Program to run
#   R = Reference genome
#   V = input
#   o = output
#   filter = hard quality filter

#   Apply hard-filter flags to mono sites 
java -Djava.io.tmpdir=/scratch/user/mdye -jar ${GATK} -T VariantFiltration -R ${REF} \
    -V ${FILTERED}/subset_mono/${REG_OUT}_mono_subset.vcf \
    -filter "QD < 2.0" -filterName "QD2" \
    -filter "FS > 60.0" -filterName "FS60" \
    -filter "MQ < 40.0" -filterName "MQ40" \
    -o ${FILTERED}/filtered_mono/${REG_OUT}_mono_filtered.vcf

echo -n "Done: filter mono"
date


#   Apply hard-filter flags to SNPs 
java -Djava.io.tmpdir=/tmp -jar ${GATK} -T VariantFiltration -R ${REF} \
    -V ${FILTERED}/subset_snps/${REG_OUT}_snps_subset.vcf \
    -filter "QD < 2.0" -filterName "QD2" \
    -filter "FS > 60.0" -filterName "FS60" \
    -filter "MQ < 40.0" -filterName "MQ40" \
    -filter "MQRankSum < -12.5" -filterName "MQRankSum-12.5" \
    -filter "ReadPosRankSum < -8.0" -filterName "ReadPosRankSum-8" \
    -o ${FILTERED}/filtered_snps/${REG_OUT}_snps_filtered.vcf

echo -n "Done: filter snps"
date

# Apply hard-filter flags for mixed/indel sites
java -Djava.io.tmpdir=/tmp -jar ${GATK} -T VariantFiltration -R ${REF} \
    -V ${FILTERED}/subset_mixed/${REG_OUT}_mixed_subset.vcf \
    -filter "QD < 2.0" -filterName "QD2" \
    -filter "FS > 60.0" -filterName "FS60" \
    -filter "MQ < 40.0" -filterName "MQ40" \
    -filter "MQRankSum < -12.5" -filterName "MQRankSum-12.5" \
    -filter "ReadPosRankSum < -8.0" -filterName "ReadPosRankSum-8" \
    -o ${FILTERED}/filtered_mixed/${CHR_NAME}_mixed_filtered.vcf

echo -n "Done: filter mixed"
date
