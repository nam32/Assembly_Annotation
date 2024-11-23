#!/bin/bash

#SBATCH --job-name=_insertion_age
#SBATCH --output=insertion_age_%j.out
#SBATCH --error=insertion_age_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=8   # Adjust based on available resources
#SBATCH --mem=32G           # Adjust memory requirements
#SBATCH --time=6:00:00     # Adjust time as needed

# Define the directory for the EDTA output
DIR_EDTA=/data/users/tjanjumratsang/assembly_annotation_course/edta_annotation
DIR_REPEATMASKER=$DIR_EDTA/contigs.fasta.mod.EDTA.anno

# Download parseRM.pl
wget -P $DIR_REPEATMASKER https://raw.githubusercontent.com/4ureliek/Parsing-RepeatMasker-Outputs/master/parseRM.pl

# Make parseRM.pl executable
chmod +x $DIR_REPEATMASKER/parseRM.pl

# Load the BioPerl module
module load BioPerl/1.7.8-GCCcore-10.3.0

# Run parseRM.pl to process RepeatMasker
perl $DIR_REPEATMASKER/parseRM.pl -i $DIR_REPEATMASKER/contigs.fasta.mod.out -l 50,1 -v > $DIR_REPEATMASKER/parsed_TE_divergence_output.tsv
