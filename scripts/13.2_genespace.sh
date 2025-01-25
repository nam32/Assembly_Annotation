#!/bin/bash
#SBATCH --job-name=genespace
#SBATCH --output=genespace_%j.out
#SBATCH --error=genespace_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=8
#SBATCH --mem=84G
#SBATCH --time=24:00:00

GENESPACE_DIR="/data/users/tjanjumratsang/assembly_annotation_course/genespace_all"
SCRIPT_DIR="/data/users/tjanjumratsang/assembly_annotation_course/scripts"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
CONTAINER="$COURSEDIR/containers/genespace_latest.sif"

# Change to the working directory
mkdir -p $GENESPACE_DIR
cd $GENESPACE_DIR

# Ensure the R script has the correct permissions
chmod +x $SCRIPT_DIR/genespace.R

# Run GENESPACE in the Apptainer container
apptainer exec --bind $GENESPACE_DIR --bind $SCRATCH:/temp $CONTAINER \
    Rscript $SCRIPT_DIR/genespace.R $GENESPACE_DIR