#!/bin/bash
#SBATCH --job-name=edta_annotation
#SBATCH --output=edta_annotation_%j.out
#SBATCH --error=edta_annotation_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=82:00:00

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