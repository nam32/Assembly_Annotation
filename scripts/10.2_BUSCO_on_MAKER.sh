#!/bin/bash

# This script runs BUSCO (Benchmarking Universal Single-Copy Orthologs) analysis on the longest protein and transcript 
# FASTA files generated during the MAKER annotation process. It evaluates the completeness of the annotations against 
# the `brassicales_odb10` lineage database.
#
# **Workflow**:
# 1. Navigates to the working directory containing the input files (`longest_proteins.fasta` and `longest_transcripts.fasta`).
# 2. Loads the BUSCO module.
# 3. Runs BUSCO in protein mode for `longest_proteins.fasta`.
# 4. Runs BUSCO in transcriptome mode for `longest_transcripts.fasta`.
#
# **Input**:
# - `longest_proteins.fasta`: FASTA file containing the longest protein isoforms for each gene.
# - `longest_transcripts.fasta`: FASTA file containing the longest transcript isoforms for each gene.
#
# **Output**:
# - `maker_busco_output_protein`: BUSCO output directory for protein analysis.
# - `maker_busco_output_transcript`: BUSCO output directory for transcriptome analysis.
#
# **Requirements**:
# - BUSCO (version 5.4.2 or compatible) must be available.
# - The lineage database (`brassicales_odb10`) must be installed and accessible.
#
# Reference:
# - BUSCO documentation: https://busco.ezlab.org/

#SBATCH --job-name=MAKER_BUSCO
#SBATCH --output=MAKER_BUSCO_%j.out
#SBATCH --error=MAKER_BUSCO_%j.err
#SBATCH --time=06:00:00
#SBATCH --partition=pibu_el8
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8  # Example to use 8 CPUs

cd /data/users/tjanjumratsang/assembly_annotation_course/final

module load BUSCO/5.4.2-foss-2021a 

busco -i longest_proteins.fasta -l brassicales_odb10 -o maker_busco_output_protein -m proteins -c 8
busco -i longest_transcripts.fasta -l brassicales_odb10 -o maker_busco_output_transcript -m transcriptome -c 8
