#!/bin/bash

# This script processes paired-end Illumina RNA-seq reads using fastp.
# It performs quality control, filtering, and trimming of reads while generating a JSON and HTML report.
# The trimmed and filtered reads are saved to the specified output directory.
# Designed to run on a Slurm cluster with the 'fastp' module loaded.

#SBATCH --time=00:30:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=fastp
#SBATCH --partition=pibu_el8
#SBATCH --output=fastp_%j.out
#SBATCH --error=fastp_%j.err

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

# Run fastp with specified options for trimming and filtering
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