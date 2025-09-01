#!/bin/bash

# Define software paths
module load GCC/12.2.0 seqtk/1.4

# Define output directory
OUTDIR="/home/wrad07/moranlab/shared/SAC_TPWD/Comal/Hypo_alignment/raw_bams"

# Define reference base           
#REFBASE="/home/wrad07/moranlab/shared/SAC_TPWD/species_ID/Pterygoplichthys_pardalis_genome.fasta"
REFBASE="/home/wrad07/moranlab/shared/SAC_TPWD/pacbio/hifiasm_out/reformatted_SAC_SMR.fasta"
# Define the root of all reads
READS_ROOT="/home/wrad07/moranlab/shared/SAC_TPWD/RAW_fall_2024/Raw_Lanes_Concatenated/Trimmomatic_Out/Comal"

THREADS="16"

SAMPLES=(
"SAC-Comal-f10" "SAC-Comal-f11" "SAC-Comal-f12" "SAC-Comal-f13" "SAC-Comal-f14" "SAC-Comal-f1" "SAC-Comal-f2" "SAC-Comal-f3" "SAC-Comal-f4" "SAC-Comal-f5" "SAC-Comal-f6" "SAC-Comal-f7" "SAC-Comal-f8" "SAC-Comal-f9" 

"SAC-Comal-m10" "SAC-Comal-m11" "SAC-Comal-m1" "SAC-Comal-m2" "SAC-Comal-m3" "SAC-Comal-m4" "SAC-Comal-m5" "SAC-Comal-m6" "SAC-Comal-m7" "SAC-Comal-m8" "SAC-Comal-m9" 
"SAC-Comal-m1" "SAC-Comal-m2" "SAC-Comal-m9"
)

declare -A READS
READS["SAC-Comal-f10_R1"]=${READS_ROOT}/SAC-Comal-f10_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-f10_R2"]=${READS_ROOT}/SAC-Comal-f10_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-f10_U"]=${READS_ROOT}/SAC-Comal-f10_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-f11_R1"]=${READS_ROOT}/SAC-Comal-f11_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-f11_R2"]=${READS_ROOT}/SAC-Comal-f11_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-f11_U"]=${READS_ROOT}/SAC-Comal-f11_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-f12_R1"]=${READS_ROOT}/SAC-Comal-f12_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-f12_R2"]=${READS_ROOT}/SAC-Comal-f12_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-f12_U"]=${READS_ROOT}/SAC-Comal-f12_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-f13_R1"]=${READS_ROOT}/SAC-Comal-f13_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-f13_R2"]=${READS_ROOT}/SAC-Comal-f13_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-f13_U"]=${READS_ROOT}/SAC-Comal-f13_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-f14_R1"]=${READS_ROOT}/SAC-Comal-f14_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-f14_R2"]=${READS_ROOT}/SAC-Comal-f14_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-f14_U"]=${READS_ROOT}/SAC-Comal-f14_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-f1_R1"]=${READS_ROOT}/SAC-Comal-f1_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-f1_R2"]=${READS_ROOT}/SAC-Comal-f1_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-f1_U"]=${READS_ROOT}/SAC-Comal-f1_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-f2_R1"]=${READS_ROOT}/SAC-Comal-f2_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-f2_R2"]=${READS_ROOT}/SAC-Comal-f2_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-f2_U"]=${READS_ROOT}/SAC-Comal-f2_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-f3_R1"]=${READS_ROOT}/SAC-Comal-f3_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-f3_R2"]=${READS_ROOT}/SAC-Comal-f3_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-f3_U"]=${READS_ROOT}/SAC-Comal-f3_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-f4_R1"]=${READS_ROOT}/SAC-Comal-f4_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-f4_R2"]=${READS_ROOT}/SAC-Comal-f4_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-f4_U"]=${READS_ROOT}/SAC-Comal-f4_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-f5_R1"]=${READS_ROOT}/SAC-Comal-f5_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-f5_R2"]=${READS_ROOT}/SAC-Comal-f5_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-f5_U"]=${READS_ROOT}/SAC-Comal-f5_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-f6_R1"]=${READS_ROOT}/SAC-Comal-f6_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-f6_R2"]=${READS_ROOT}/SAC-Comal-f6_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-f6_U"]=${READS_ROOT}/SAC-Comal-f6_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-f7_R1"]=${READS_ROOT}/SAC-Comal-f7_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-f7_R2"]=${READS_ROOT}/SAC-Comal-f7_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-f7_U"]=${READS_ROOT}/SAC-Comal-f7_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-f8_R1"]=${READS_ROOT}/SAC-Comal-f8_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-f8_R2"]=${READS_ROOT}/SAC-Comal-f8_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-f8_U"]=${READS_ROOT}/SAC-Comal-f8_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-f9_R1"]=${READS_ROOT}/SAC-Comal-f9_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-f9_R2"]=${READS_ROOT}/SAC-Comal-f9_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-f9_U"]=${READS_ROOT}/SAC-Comal-f9_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-m10_R1"]=${READS_ROOT}/SAC-Comal-m10_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-m10_R2"]=${READS_ROOT}/SAC-Comal-m10_adtrim_trim_pair_R2.fastq.gz 
READS["SAC-Comal-m10_U"]=${READS_ROOT}/SAC-Comal-m10_adtrim_trim_unpair_all.fastq.gz                            
READS["SAC-Comal-m1_R1"]=${READS_ROOT}/SAC-Comal-m11_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-m11_R2"]=${READS_ROOT}/SAC-Comal-m11_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-m11_U"]=${READS_ROOT}/SAC-Comal-m11_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-m1_R1"]=${READS_ROOT}/SAC-Comal-m1_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-m1_R2"]=${READS_ROOT}/SAC-Comal-m1_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-m1_U"]=${READS_ROOT}/SAC-Comal-m1_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-m2_R1"]=${READS_ROOT}/SAC-Comal-m2_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-m2_R2"]=${READS_ROOT}/SAC-Comal-m2_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-m2_U"]=${READS_ROOT}/SAC-Comal-m2_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-m3_R1"]=${READS_ROOT}/SAC-Comal-m3_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-m3_R2"]=${READS_ROOT}/SAC-Comal-m3_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-m3_U"]=${READS_ROOT}/SAC-Comal-m3_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-m4_R1"]=${READS_ROOT}/SAC-Comal-m4_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-m4_R2"]=${READS_ROOT}/SAC-Comal-m4_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-m4_U"]=${READS_ROOT}/SAC-Comal-m4_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-m5_R1"]=${READS_ROOT}/SAC-Comal-m5_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-m5_R2"]=${READS_ROOT}/SAC-Comal-m5_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-m5_U"]=${READS_ROOT}/SAC-Comal-m5_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-m6_R1"]=${READS_ROOT}/SAC-Comal-m6_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-m6_R2"]=${READS_ROOT}/SAC-Comal-m6_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-m6_U"]=${READS_ROOT}/SAC-Comal-m6_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-m7_R1"]=${READS_ROOT}/SAC-Comal-m7_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-m7_R2"]=${READS_ROOT}/SAC-Comal-m7_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-m7_U"]=${READS_ROOT}/SAC-Comal-m7_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-m8_R1"]=${READS_ROOT}/SAC-Comal-m8_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-m8_R2"]=${READS_ROOT}/SAC-Comal-m8_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-m8_U"]=${READS_ROOT}/SAC-Comal-m8_adtrim_trim_unpair_all.fastq.gz
READS["SAC-Comal-m9_R1"]=${READS_ROOT}/SAC-Comal-m9_adtrim_trim_pair_R1.fastq.gz
READS["SAC-Comal-m9_R2"]=${READS_ROOT}/SAC-Comal-m9_adtrim_trim_pair_R2.fastq.gz
READS["SAC-Comal-m9_U"]=${READS_ROOT}/SAC-Comal-m9_adtrim_trim_unpair_all.fastq.gz

for s in ${SAMPLES[@]}
do
    # Define output file
    outfile=${OUTDIR}/${s}_raw.bam

    # Get the R1, R2, and unpaired read paths
    r1=${READS["${s}_R1"]}
    r2=${READS["${s}_R2"]}
    un=${READS["${s}_U"]}

    # Echo the commands for debugging
    echo "(seqtk mergepe ${r1} ${r2}; gzip -cd ${un}) | bwa mem -t ${THREADS} -k 12 -M -p ${REFBASE} - | samtools view -hbu - | samtools sort -@ ${THREADS} -o ${outfile}"
done
