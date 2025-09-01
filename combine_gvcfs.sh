#!/bin/bash
#SBATCH --job-name=combine_gvcfs
#SBATCH --output=combine_gvcfs.out
#SBATCH --error=combine_gvcfs.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=96:00:00
#SBATCH --mem=250gb
#SBATCH --cpus-per-task=1

#   Print when the script began running
echo -n "Ran: "
date

#   Load the correct GATK module (v4.6.1.0, which supports CombineGVCFs)
module purge
module load GCCcore/13.3.0 GATK/4.6.1.0-Java-17

#   Reference genome
REF="/home/wrad07/moranlab/shared/SAC_TPWD/pacbio/hifiasm_out/reformatted_SAC_SMR.fasta"

#   Directory containing GVCFs
GVCF_DIR="/home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/Comal_hypo/"

#   Output file
OUTPUT="/home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/Comal_hypo/cohort_combined.g.vcf"

#   Export Java memory options — essential to avoid Java heap space errors
export _JAVA_OPTIONS="-Xmx200g"

#   Run GATK CombineGVCFs with proper formatting
gatk --java-options "-Xmx200g" CombineGVCFs \
  -R "$REF" \
  $(find "$GVCF_DIR" -name '*.g.vcf' | sort | sed 's/^/--variant /') \
  -O "$OUTPUT"

echo -n "Done: "
date
