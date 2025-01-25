#!/bin/bash

# This script runs the Flye assembler to assemble a genome using PacBio HiFi reads. 
# The Flye assembly is executed within a Singularity (Apptainer) container.
#
# Usage:
#   This script is designed to run on a Slurm-based cluster environment.
#   The input is a gzipped FASTQ file containing PacBio HiFi reads.
#
# Output:
#   - Assembled genome files will be saved in the specified output directory.
#
# Requirements:
#   - Apptainer (Singularity) must be available on the cluster.
#   - The Flye container image must be accessible at the specified path.
#
# Parameters:
#   - Input: PacBio HiFi reads file (ERR11437339.fastq.gz)
#
# Reference:
#   Flye documentation: https://github.com/fenderglass/Flye

#SBATCH --job-name=flye_assembly
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pibu_el8
#SBATCH --output=flye_assembly_%j.out
#SBATCH --error=flye_assembly_%j.err

# Load Apptainer (Singularity) module
module load apptainer

# Define input reads and output directory
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
PACBIO_HIFI_READS=$WORKDIR/Ice-1/ERR11437339.fastq.gz
OUTPUT_DIR=$WORKDIR/flye_assembly

# Run Flye within the container
apptainer exec /containers/apptainer/flye_2.9.5.sif flye \
    --pacbio-hifi $PACBIO_HIFI_READS \
    --out-dir $OUTPUT_DIR \
    --threads 16
