#!/bin/bash

# This script sets up and runs an OMAmmer search to find orthologous groups for a given protein sequence file. 
# It uses the OMA database and saves the results to an output file with a `.omamer` suffix.
#
# **Workflow**:
# 1. Navigates to the working directory containing the protein FASTA file.
# 2. Activates the `OMArk` Conda environment for OMAmmer functionality.
# 3. Downloads the OMA database (`LUCA.h5`).
# 4. Runs the OMAmmer search to find orthologous groups and outputs the results.
#
# **Input**:
# - Protein FASTA file: `assembly.all.maker.proteins.fasta.renamed.fasta`.
#
# **Output**:
# - Results file: `assembly.all.maker.proteins.fasta.renamed.fasta.omamer`.
#
# **Requirements**:
# - Modules: Anaconda3 (to manage the `OMArk` environment).
# - OMA database: Downloaded from https://omabrowser.org/All/LUCA.h5.
# - Conda environment: `OMArk` must be pre-configured with OMAmmer installed.
#
# Reference:
# - OMAmmer: https://omabrowser.org/oma/omamer
# - OMA database: https://omabrowser.org/

#SBATCH --cpus-per-task=1
#SBATCH --time=5:00:00
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=omark
#SBATCH --output=omark_%j.out
#SBATCH --error=omark_%j.err

#  sets up and runs an OMAmmer search to find orthologous groups for a given protein sequence file saving the results to an output file with the .omamer suffix

cd ./../final

protein=assembly.all.maker.proteins.fasta
# Activate conda environment
eval "$(/home/amaalouf/miniconda3/bin/conda shell.bash hook)"
conda activate OMArk

cd ./../final

protein=assembly.all.maker.proteins.fasta.renamed.fasta

# Load Anaconda3 module
module add Anaconda3/2022.05

# Download OMA database
wget https://omabrowser.org/All/LUCA.h5 -O LUCA.h5

# Run OMAmmer search
omamer search --db LUCA.h5 --query ${protein} --out ${protein}.omamer
