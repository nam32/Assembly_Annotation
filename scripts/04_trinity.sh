#!/bin/bash

# This script runs Trinity for de novo transcriptome assembly using paired-end RNA-Seq reads.
# It uses gzipped FASTQ files as input and produces assembled transcripts in the specified output directory.
#
# Usage:
#   This script is designed to run on a Slurm-based cluster environment.
#   Input files should be paired-end FASTQ files (left and right reads).
#
# Output:
#   - Assembled transcriptome files will be saved in the specified output directory.
#
# Requirements:
#   - Trinity must be installed or loaded as a module.
#   - Input FASTQ files should be preprocessed and quality-checked.
#
# Parameters:
#   - Input: Paired-end FASTQ files (ERR754081_1_tr.fastq.gz, ERR754081_2_tr.fastq.gz)
#
# Reference:
#   Trinity documentation: https://github.com/trinityrnaseq/trinityrnaseq

#SBATCH --job-name=trinity_assembly
#SBATCH --output=trinity_assembly_%j.out
#SBATCH --error=trinity_assembly_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=48:00:00

# Load Trinity module
module load Trinity/2.15.1-foss-2021a

# Define input fastq files (comma-separated if multiple)
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
OUTPUT_DIR=$WORKDIR/trinity

LEFT_FASTQ="/data/users/tjanjumratsang/assembly_annotation_course/data/ERR754081_1_tr.fastq.gz"
RIGHT_FASTQ="/data/users/tjanjumratsang/assembly_annotation_course/data/ERR754081_2_tr.fastq.gz"

# Run Trinity
Trinity --seqType fq \
        --max_memory 64G \
        --CPU 16 \
        --left $LEFT_FASTQ \
        --right $RIGHT_FASTQ \
        --output $OUTPUT_DIR