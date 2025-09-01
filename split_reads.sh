#!/bin/bash
#SBATCH --job-name=split_reads
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16  # Number of parallel tasks
#SBATCH --time=24:00:00
#SBATCH --mem=62gb
#SBATCH --output=split_reads.out
#SBATCH --error=split_reads.err

# Load required modules
module load GCC/13.2.0 SAMtools/1.21
module load GCCcore/13.2.0 parallel/20240322

# Set directory where the BAM files are
export BAM_DIR="/home/wrad07/moranlab/shared/SAC_TPWD/Comal/Hypo_alignment/raw_bams/dups_marked"

# Set directories where the reads will go
export MAP_DIR="/home/wrad07/moranlab/shared/SAC_TPWD/Comal/Hypo_alignment/raw_bams/dups_marked/mapped"
export UNMAP_DIR="/home/wrad07/moranlab/shared/SAC_TPWD/Comal/Hypo_alignment/raw_bams/dups_marked/unmapped"

# Create output directories if they don't exist
mkdir -p ${MAP_DIR} ${UNMAP_DIR}

# Get a list of the input alignments
ALNS=($(find ${BAM_DIR} -maxdepth 1 -name '*_dupsmarked.bam' | sort -V))

# Define the number of parallel jobs
NUM_JOBS=8  # Adjust based on system resources

# Function to process a single BAM file
process_bam() {
    local C_ALN=$1
    local bname=$(basename ${C_ALN})
    local sample=${bname/.bam}

    echo "Processing ${sample}..."
    
    # Run samtools to split the reads into mapped and unmapped
    samtools view -hb -@ 8 -f 4 ${C_ALN} > ${UNMAP_DIR}/${sample}_unmapped.bam
    samtools view -hb -@ 8 -F 260 ${C_ALN} > ${MAP_DIR}/${sample}_mapped.bam
}

export -f process_bam  # Export function for parallel execution

# Run in parallel
parallel -j ${NUM_JOBS} process_bam ::: "${ALNS[@]}"

echo "Done processing all BAM files."
