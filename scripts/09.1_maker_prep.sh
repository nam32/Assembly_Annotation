#!/bin/bash
#SBATCH --job-name=maker_prep
#SBATCH --output=maker_prep_%j.out
#SBATCH --error=maker_prep_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=1:00:00

# prepares the necessary control files for MAKER to perform gene annotation on a genome assembly

# Define working directory and assembly file
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
ASSEMBLY=$WORKDIR/flye_assembly/assembly.fasta

# Create a dedicated directory for MAKER annotation
ANNOTATION_DIR=$WORKDIR/gene_annotation_directory
mkdir -p $ANNOTATION_DIR
cd $ANNOTATION_DIR

# Generate control files for MAKER
apptainer exec --bind $WORKDIR \
/data/courses/assembly-annotation-course/CDS_annotation/containers/MAKER_3.01.03.sif maker -CTL
