#!/bin/bash

# This script refines homologous orthologous group (HOG) annotations by aligning conserved HOG fragments 
# to a genomic assembly using Miniprot. It downloads and compiles Miniprot if not already available,
# then aligns the sequences and generates output in GFF format.
#
# **Workflow**:
# 1. Loads necessary modules for Miniprot compilation (GCC and zlib).
# 2. Downloads and compiles Miniprot from the GitHub repository if not already installed.
# 3. Aligns conserved HOG fragments (`conserved_hog_fragment.fa`) to the genomic assembly (`assembly.fasta`) using Miniprot.
# 4. Saves alignment results in GFF format (`miniprot_output.gff`).
#
# **Input**:
# - `assembly.fasta`: Genomic assembly to align against.
# - `conserved_hog_fragment.fa`: FASTA file containing conserved HOG fragments.
#
# **Output**:
# - `miniprot_output.gff`: GFF file containing alignment results.
#
# **Requirements**:
# - Modules: GCC and zlib for Miniprot compilation.
# - Git access to clone the Miniprot repository.
# - Genomic assembly and HOG fragment files must exist in the specified paths.
#
# Reference:
# - Miniprot GitHub repository: https://github.com/lh3/miniprot

#SBATCH --cpus-per-task=1
#SBATCH --time=5:00:00
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=hog_refinement
#SBATCH --output=hog_refinement_%j.out
#SBATCH --error=hog_refinement_%j.err

# Load necessary modules for compiling Miniprot
module load GCC
module load zlib

cd ./../final

# Define variables for Miniprot setup
MINIPROT_DIR="miniprot"                 # Directory to store Miniprot
MINIPROT_PATH="$MINIPROT_DIR/miniprot"  # Path to the Miniprot executable

# If Miniprot directory does not exist, download and compile Miniprot
if [ ! -d "$MINIPROT_DIR" ]; then
    echo "Downloading and compiling Miniprot..."
    git clone https://github.com/lh3/miniprot.git $MINIPROT_DIR
    cd $MINIPROT_DIR
    make
    cd ..
fi

# Define variables for input files and output
GENOMIC_FASTA="/data/users/tjanjumratsang/assembly_annotation_course/flye_assembly/assembly.fasta"
SEQ_FASTA="conserved_hog_fragment.fa"
MINIPROT_OUTPUT="miniprot_output.gff"

# Run Miniprot
$MINIPROT_PATH -I --gff --outs=0.95 $GENOMIC_FASTA $SEQ_FASTA > $MINIPROT_OUTPUT
