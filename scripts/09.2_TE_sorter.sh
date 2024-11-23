#!/bin/bash
#SBATCH --job-name=refine_TE_TEsorter
#SBATCH --output=refine_TE_TEsorter_%j.out
#SBATCH --error=refine_TE_TEsorter_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

# Load the SeqKit module
module load SeqKit/2.6.1

# Define paths
WORKDIR="/data/users/tjanjumratsang/assembly_annotation_course/edta_annotation"
CONTAINER="/data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif"
INPUT_FILE="contigs.fasta.mod.EDTA.raw/LTR/contigs.fasta.mod.LTR.intact.fa"
genome="contigs"
# Change to the working directory
cd $WORKDIR

# Run TEsorter on the initial input file to classify TEs within the container
apptainer exec -C -H $WORKDIR -H $(pwd):/work --writable-tmpfs -u \
$CONTAINER TEsorter $INPUT_FILE -db rexdb-plant


# Extract Copia sequences from the TE library
seqkit grep -r -p "Copia" /data/users/tjanjumratsang/assembly_annotation_course/edta_annotation/contigs.fasta.mod.EDTA.TElib.fa > Copia_sequences.fa

# Extract Gypsy sequences from the TE library
seqkit grep -r -p "Gypsy" /data/users/tjanjumratsang/assembly_annotation_course/edta_annotation/contigs.fasta.mod.EDTA.TElib.fa > Gypsy_sequences.fa

# Run TEsorter on the Copia sequences within the container
apptainer exec -C -H $WORKDIR -H $(pwd):/work --writable-tmpfs -u \
$CONTAINER TEsorter /data/users/tjanjumratsang/assembly_annotation_course/edta_annotation/Copia_sequences.fa -db rexdb-plant

# Run TEsorter on the Gypsy sequences within the container
apptainer exec -C -H $WORKDIR -H $(pwd):/work --writable-tmpfs -u \
$CONTAINER TEsorter /data/users/tjanjumratsang/assembly_annotation_course/edta_annotation/Gypsy_sequences.fa -db rexdb-plant
