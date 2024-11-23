#!/bin/bash
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
