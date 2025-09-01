#!/bin/bash
#SBATCH --job-name=haplotype_caller
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=96:00:00
#SBATCH --mem=124gb
#SBATCH --output=haplotype_caller.out
#SBATCH --error=haplotype_caller.err
#SBATCH --array=0-19

#   For this step use bams with mapped reads ONLY

#   Print when the script began running 
echo -n "Ran: "
date

#   Load modules and dependencies
#   Used GATK 3.8.0 because GATK 4.1.0 does not support threading and there were computational restrictions
module load Java/21.0.2

#   Set paths for the bam file directory, the reference genome, and the GATK version download
REF="/home/wrad07/moranlab/shared/SAC_TPWD/pacbio/hifiasm_out/reformatted_SAC_SMR.fasta"
ALN_DIR="/home/wrad07/moranlab/shared/SAC_TPWD/Comal/Hypo_alignment/raw_bams/dups_marked/mapped"

#   Get the samples to analyze
SAMPLE_LIST=($(find ${ALN_DIR} -name '*_dupsmarked_mapped.bam' | sort -V))
CURRENT_SAMPLE=${SAMPLE_LIST[${SLURM_ARRAY_TASK_ID}]}

#   Get the sample name
#   Make sure there are NO DASHES IN FILE NAME
FNAME=$(basename ${CURRENT_SAMPLE})
SAMPLENAME=${FNAME/_dupsmarked_mapped.bam/}

#   Set the output directory
OUTDIR="/home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/Comal_hypo"

#   Note: -ERC option should be BP_RESOLUTION, not GVCF

#   R = reference genome
#   I = input
#   O = output
#   genotyping-mode = Specifies how to determine the alternate alleles to use for genotyping
#   heterozygosity = Heterozygosity value used to compute prior likelihoods for any locus. See the GATKDocs for full details on the meaning of this population genetics concept
#   ERC = Mode for emitting reference confidence scores

# Load GATK 4
export PATH=/home/wrad07/moranlab/shared/software/GATK/gatk-4.5.0.0:$PATH

# Set Java memory
gatk --java-options "-Xmx61g" \
    HaplotypeCaller \
    --reference ${REF} \
    --input ${CURRENT_SAMPLE} \
    --output ${OUTDIR}/${SAMPLENAME}.g.vcf \
    --emit-ref-confidence BP_RESOLUTION \
    --native-pair-hmm-threads 12 \
    --heterozygosity 0.005


#   Print when the script finished running
echo -n "Done: "
date
