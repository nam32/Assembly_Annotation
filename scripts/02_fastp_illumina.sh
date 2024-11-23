#!/bin/bash

#SBATCH --time=1-00:00:00        # 1 day max time
#SBATCH --mem=16G                # Memory allocation
#SBATCH --cpus-per-task=4        # Number of CPUs
#SBATCH --job-name=fastp         # Updated job name to match fastp
#SBATCH --partition=pibu_el8     # Partition to run on
#SBATCH --output=fastp_%j.out    # Output log file
#SBATCH --error=fastp_%j.err     # Error log file

module load fastp

WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
OUTDIR=/data/users/tjanjumratsang/assembly_annotation_course/data

# Define input/output file paths
ILLUMINA_INPUT_R1=$WORKDIR/RNAseq_Sha/ERR754081_1.fastq.gz
ILLUMINA_INPUT_R2=$WORKDIR/RNAseq_Sha/ERR754081_2.fastq.gz
ILLUMINA_OUTPUT_R1=$OUTDIR/ERR754081_1_tr.fastq.gz
ILLUMINA_OUTPUT_R2=$OUTDIR/ERR754081_2_tr.fastq.gz
ILLUMINA_REPORT=$OUTDIR/illumina_report.json
ILLUMINA_HTML=$OUTDIR/illumina_report.html

# Run fastp on Illumina data for filtering and trimming
fastp \
    -i $ILLUMINA_INPUT_R1 \
    -I $ILLUMINA_INPUT_R2 \
    -o $ILLUMINA_OUTPUT_R1 \
    -O $ILLUMINA_OUTPUT_R2 \
    --json $ILLUMINA_REPORT \
    --html $ILLUMINA_HTML \
    --trim_front1 10 \
    --trim_front2 10 \
    --cut_tail \
    --cut_mean_quality 20 \
    --length_required 50 \
    --thread 4