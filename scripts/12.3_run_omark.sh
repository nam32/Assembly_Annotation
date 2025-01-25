#!/bin/bash

# This script runs an OMArk analysis to process orthologous group results from an OMAmmer search. 
# It uses the isoform list, protein FASTA file, and OMA database to generate processed outputs.
#
# **Workflow**:
# 1. Navigates to the working directory containing the input files.
# 2. Activates the `OMArk` Conda environment for the analysis.
# 3. Executes the `omark` command to process the results of the OMAmmer search.
#
# **Input**:
# - `assembly.all.maker.proteins.fasta.renamed.fasta.omamer`: OMAmmer results file.
# - `assembly.all.maker.proteins.fasta.renamed.fasta`: Protein FASTA file.
# - `isoform_list.txt`: File listing isoforms for each gene.
# - `LUCA.h5`: OMA database file.
#
# **Output**:
# - `omark_output`: Directory containing the processed results.
#
# **Requirements**:
# - Conda environment: `OMArk` must be pre-configured.
# - OMAmmer results file (`.omamer`) must exist.
# - Isoform list (`isoform_list.txt`) must be correctly formatted and available.
# - OMA database (`LUCA.h5`) must be accessible.
#
# Reference:
# - OMArk documentation: https://omabrowser.org/oma/omark

#SBATCH --cpus-per-task=1
#SBATCH --time=5:00:00
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=omark_run
#SBATCH --output=omark_run_%j.out
#SBATCH --error=omark_run_%j.err

cd ./../final

protein=assembly.all.maker.proteins.fasta
# Activate conda environment
eval "$(/home/amaalouf/miniconda3/bin/conda shell.bash hook)"
conda activate OMArk

omark -f ${protein}.renamed.fasta.omamer -of ${protein}.renamed.fasta -i isoform_list.txt -d LUCA.h5 -o omark_output 
