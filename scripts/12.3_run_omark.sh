#!/bin/bash
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