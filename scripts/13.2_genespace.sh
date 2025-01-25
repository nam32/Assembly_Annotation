#!/bin/bash

# This script runs the GENESPACE pipeline to analyze synteny and orthology relationships between genomes.
# It uses an Apptainer container to execute the GENESPACE R script in a controlled environment.
#
# **Workflow**:
# 1. Creates the working directory for GENESPACE outputs.
# 2. Ensures the R script for GENESPACE execution has the correct permissions.
# 3. Executes the GENESPACE pipeline using an Apptainer container.
#
# **Input**:
# - `genespace.R`: R script to configure and run GENESPACE.
# - Genome data and annotations (FASTA and BED files) must be organized in the working directory.
#
# **Output**:
# - GENESPACE results saved in `$GENESPACE_DIR`.
#
# **Requirements**:
# - GENESPACE R script: Ensure the script path and permissions are correct.
# - Apptainer container: The GENESPACE container should be accessible at `$CONTAINER`.
# - Input files: Required genome and annotation files should already be organized under `$GENESPACE_DIR`.
#
# **Steps**:
# 1. Define working directory (`$GENESPACE_DIR`) for outputs.
# 2. Set permissions for the R script to ensure it is executable.
# 3. Run the R script inside the GENESPACE container.
#
# **Usage**:
# Ensure all input files are organized and run the script:
# ```bash
# sbatch genespace_run.sh
# ```
#
# **Notes**:
# - Adjust paths and parameters as necessary for your specific dataset and cluster environment.
# - Review the R script to confirm it is configured correctly for GENESPACE.

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