#!/bin/bash

#   These are the samples that we are analyzing. These will eventually be part of filenames, so we define them here, as a bash array.

SAMPLES=("SAC-Comal-f11" "SAC-Comal-f12" "SAC-Comal-f13" "SAC-Comal-f14" "SAC-Comal-f2" "SAC-Comal-f3" "SAC-Comal-f4" "SAC-Comal-f5" "SAC-Comal-f6" "SAC-Comal-f7" "SAC-Comal-f8"

"SAC-Comal-m10" "SAC-Comal-m11" "SAC-Comal-m12" "SAC-Comal-m3" "SAC-Comal-m4" "SAC-Comal-m5" "SAC-Comal-m6" "SAC-Comal-m7" "SAC-Comal-m8"
)
#   Generate two commands for each sample to (1) mark duplicate and (2) add read groups (i.e. sample name)

for s in ${SAMPLES[@]}
do
    echo "java -jar /home/wrad07/moranlab/shared/darters/Ready_To_Align/symIL_Ecaer_reads/picard.jar MarkDuplicates TMP_DIR=/tmp INPUT=/home/wrad07/moranlab/shared/SAC_TPWD/Comal/Hypo_alignment/raw_bams/${s}_rgadd.bam OUTPUT=/home/wrad07/moranlab/shared/SAC_TPWD/Comal/Hypo_alignment/raw_bams/dups_marked/${s}_dupsmarked.bam METRICS_FILE=/home/wrad07/moranlab/shared/SAC_TPWD/Comal/Hypo_alignment/raw_bams/dups_marked/${s}_metrics.txt REMOVE_DUPLICATES="true" CREATE_INDEX="true""
done
