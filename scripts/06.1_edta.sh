#!/bin/bash
#SBATCH --job-name=edta_annotation
#SBATCH --output=edta_annotation_%j.out
#SBATCH --error=edta_annotation_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=84:00:00

# This script runs EDTA (Extensive de-novo TE Annotator) for transposable element annotation
# on a Flye assembly genome. The analysis is performed using a Singularity (Apptainer) container.
#
# Usage:
#   Designed to run on a Slurm-based cluster environment. It performs all steps of the EDTA
#   pipeline, including genome masking and annotation.
#
# Output:
#   - Annotated genome with transposable elements in the specified output directory.
#
# Requirements:
#   - The EDTA container must be accessible.
#   - The genome assembly file must be in FASTA format.
#   - TAIR10 CDS annotation file is required for the annotation step.
#
# Parameters:
#   - Input Genome: Flye assembly (`assembly.fasta`).
#
# Reference:
#   EDTA documentation: https://github.com/oushujun/EDTA

WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
mkdir -p $WORKDIR/edta_annotation
cd $WORKDIR/edta_annotation
flye_assembly="$WORKDIR/flye_assembly/assembly.fasta"
CONTAINER_PATH=/data/courses/assembly-annotation-course/containers2/EDTA_v1.9.6.sif

apptainer exec -C -H $(pwd):/work \
 --writable-tmpfs $CONTAINER_PATH \
 EDTA.pl \
 --genome $flye_assembly \
 --species others \
 --step all \
 --cds "/data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10_cds_20110103_representative_gene_model_updated" \
 --anno 1 \
 --threads 20