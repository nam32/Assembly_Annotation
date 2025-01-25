#!/bin/bash

# This script runs the LJA assembler for genome assembly using PacBio HiFi reads.
# The assembly process is performed within a Singularity (Apptainer) container.
#
# Usage:
#   This script is designed to run on a Slurm-based cluster environment.
#   Input is a gzipped FASTQ file containing PacBio HiFi reads.
#
# Output:
#   - Assembled genome files will be saved in the specified output directory.
#
# Requirements:
#   - Apptainer (Singularity) must be available on the cluster.
#   - The LJA container image must be accessible at the specified path.
#
# Parameters:
#   - Input: PacBio HiFi reads file (ERR11437339.fastq.gz)
#
# Reference:
#   LJA documentation: https://github.com/AntonBankevich/LJA

#SBATCH --job-name=lja_assembly
#SBATCH --output=lja_assembly_%j.out
#SBATCH --error=lja_assembly_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=48:00:00

# Define input reads and output directory
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
PACBIO_HIFI_READS=$WORKDIR/Ice-1/ERR11437339.fastq.gz
OUTPUT_DIR=$WORKDIR/lja

# Run LJA assembly within the container
apptainer exec /containers/apptainer/lja-0.2.sif lja \
    --reads $PACBIO_HIFI_READS \
    --output-dir $OUTPUT_DIR \
    --threads 16