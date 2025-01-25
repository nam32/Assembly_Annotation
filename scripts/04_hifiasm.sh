#!/bin/bash

# This script runs Hifiasm for de novo genome assembly using PacBio HiFi reads. 
# The assembly process is performed within a Singularity (Apptainer) container.
# After assembly, the GFA file is converted to a FASTA format for downstream analysis.
#
# Usage:
#   This script is designed to run on a Slurm-based cluster environment.
#   Input is a gzipped FASTQ file containing PacBio HiFi reads.
#
# Output:
#   - A GFA file containing the genome assembly graph.
#   - A FASTA file with assembled contigs/sequences.
#
# Requirements:
#   - Apptainer (Singularity) must be available on the cluster.
#   - The Hifiasm container image must be accessible at the specified path.
#
# Parameters:
#   - Input: PacBio HiFi reads file (ERR11437339.fastq.gz)
#
# Reference:
#   Hifiasm documentation: https://github.com/chhylp123/hifiasm

#SBATCH --job-name=hifiasm_assembly
#SBATCH --output=hifiasm_assembly_%j.out
#SBATCH --error=hifiasm_assembly_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=02:00:00


# Define input reads and output directory
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
PACBIO_HIFI_READS=$WORKDIR/Ice-1/ERR11437339.fastq.gz
OUTPUT_DIR=$WORKDIR/hifiasm

# Define input reads and output directory
GFA_OUTPUT=${OUTPUT_DIR}/assembly.gfa
FASTA_OUTPUT=${OUTPUT_DIR}/assembly.fa

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Run Hifiasm within the container
apptainer exec /containers/apptainer/hifiasm_0.19.8.sif hifiasm \
    -o $GFA_OUTPUT \
    -t 16 \
    $PACBIO_HIFI_READS

# Convert GFA to FASTA format
awk '/^S/{print ">"$2;print $3}' $GFA_OUTPUT > $FASTA_OUTPUT