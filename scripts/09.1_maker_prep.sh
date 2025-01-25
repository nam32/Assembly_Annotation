#!/bin/bash

# This script prepares the necessary control files for MAKER to perform gene annotation on a genome assembly.
# It sets up a dedicated directory for MAKER, navigates to the directory, and generates control files
# using the `maker -CTL` command within a Singularity (Apptainer) container.
#
# **Workflow**:
# 1. Defines the working directory and genome assembly file path.
# 2. Creates a dedicated directory for MAKER annotation output.
# 3. Generates MAKER control files (`maker_opts.ctl`, `maker_exe.ctl`, and `maker_bopts.ctl`) using the containerized MAKER tool.
#
# **Output**:
# - Control files for MAKER: `maker_opts.ctl`, `maker_exe.ctl`, and `maker_bopts.ctl`, stored in the specified annotation directory.
#
# **Requirements**:
# - MAKER must be accessible via a Singularity (Apptainer) container.
# - Genome assembly file (`assembly.fasta`) must be available.
# - Ensure sufficient permissions for creating and writing to the annotation directory.
#
# Reference:
# - MAKER documentation: http://www.yandell-lab.org/software/maker.html

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
