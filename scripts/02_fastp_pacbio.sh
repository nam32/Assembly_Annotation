#!/bin/bash

# This script processes PacBio reads using fastp, focusing on generating 
# quality control reports without applying quality or length filtering.
# The processed reads and QC reports are saved to the specified output directory.
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
PACBIO_INPUT=$WORKDIR/Ice-1/ERR11437339.fastq.gz
PACBIO_OUTPUT=$OUTDIR/output_pacbio.fastq.gz
PACBIO_REPORT=$OUTDIR/pacbio_report.json
PACBIO_HTML=$OUTDIR/pacbio_report.html

fastp \
    -i $PACBIO_INPUT \
    -o $PACBIO_OUTPUT \
    --json $PACBIO_REPORT \
    --html $PACBIO_HTML \
    --disable_quality_filtering \
    --disable_length_filtering \
    --thread 4