#!/bin/bash

# This script runs QUAST to assess and compare the quality of multiple genome assemblies
# (Flye, Hifiasm, and LJA) in two modes:
#   1. Without a reference genome.
#   2. Using the Arabidopsis thaliana reference genome.
#
# Usage:
#   Designed to run on a Slurm-based cluster environment, the analysis is performed within a
#   Singularity (Apptainer) container.
#
# Output:
#   - Comprehensive QUAST reports for all input assemblies, with and without a reference.
#
# Requirements:
#   - QUAST must be available via a Singularity container.
#   - Input assemblies and the reference genome must be in FASTA format.
#
# Parameters:
#   - Input Assemblies: Flye, Hifiasm, LJA.
#
# Reference:
#   QUAST documentation: http://quast.sourceforge.net/

#SBATCH --job-name=quast_analysis_tgt
#SBATCH --output=quast_analysis_tgt_%j.out
#SBATCH --error=quast_analysis_tgt_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH --time=12:00:00

# Define the working directory
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
OUTPUT_DIR=$WORKDIR/quast_results

# Define paths to the assemblies
flye_assembly="$WORKDIR/flye_assembly/assembly.fasta"
hifiasm_assembly="$WORKDIR/hifiasm/assembly.fa"
lja_assembly="$WORKDIR/lja/assembly.fasta"

# Reference file
reference_genome="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"

# Path to the QUAST container
quast_container="/containers/apptainer/quast_5.2.0.sif"

# Ensure the output directory exists
mkdir -p ${OUTPUT_DIR}

# Define the number of CPUs to use
num_cpus=16

# Function to run QUAST
run_quast () {
    local output_name=$1
    local reference=$2

    # If reference is provided, use it
    if [ -n "$reference" ]; then
        apptainer exec ${quast_container} quast.py \
            -o ${OUTPUT_DIR}/${output_name} \
            --threads ${num_cpus} \
            --eukaryote \
            -R ${reference} \
            --large \
            ${flye_assembly} ${hifiasm_assembly} ${lja_assembly}
    else
        # Run QUAST without reference
        apptainer exec ${quast_container} quast.py \
            -o ${OUTPUT_DIR}/${output_name} \
            --threads ${num_cpus} \
            --eukaryote \
            --large \
            ${flye_assembly} ${hifiasm_assembly} ${lja_assembly}
    fi
}

# Run QUAST on all genome assemblies without reference
run_quast "quast_all_no_ref" ""

# Run QUAST on all genome assemblies with reference
run_quast "quast_all_with_ref" "${reference_genome}"

echo "QUAST comparative analysis completed!"
