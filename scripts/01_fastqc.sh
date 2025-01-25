#!/usr/bin/env bash

# This script runs FastQC quality control analysis on a list of input files or directories
# using Apptainer to execute the FastQC container. It processes RNA-Seq data and specific
# FASTQ files, and outputs the results to a specified directory. The script is designed
# to run on a Slurm cluster with specified resource allocations.

#SBATCH --time=00:30:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=fastqc
#SBATCH --partition=pibu_el8
#SBATCH --output=fastqc_%j.out
#SBATCH --error=fastqc_%j.err

WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
OUTDIR=/data/users/tjanjumratsang/assembly_annotation_course/read_QC

# List of directories or files to process
INPUTS=(
    "$WORKDIR/RNAseq_Sha/*"
    "$WORKDIR/Ice-1/ERR11437339.fastq.gz"
)

# Run FastQC on each input
for INPUT in "${INPUTS[@]}"; do
    apptainer exec \
    --bind $WORKDIR \
    /containers/apptainer/fastqc-0.12.1.sif \
    fastqc -o $OUTDIR/ $INPUT
done
