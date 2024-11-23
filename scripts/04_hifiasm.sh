#!/bin/bash

#SBATCH --job-name=hifiasm_assembly
#SBATCH --output=hifiasm_assembly_%j.out
#SBATCH --error=hifiasm_assembly_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=16   # Adjust based on your computational resources
#SBATCH --mem=64G            # Adjust memory requirements
#SBATCH --time=48:00:00       # Adjust time as needed


# Define input reads and output directory
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
PACBIO_HIFI_READS=$WORKDIR/Ice-1/ERR11437339.fastq.gz
OUTPUT_DIR=$WORKDIR/hifiasm

# Define input reads and output directory
GFA_OUTPUT=${OUTPUT_DIR}/assembly.gfa
FASTA_OUTPUT=${OUTPUT_DIR}/assembly.fa

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Run Hifiasm within the container
apptainer exec /containers/apptainer/hifiasm_0.19.8.sif hifiasm \
    -o $GFA_OUTPUT \
    -t 16 \
    $PACBIO_HIFI_READS

# Convert GFA to FASTA format
awk '/^S/{print ">"$2;print $3}' $GFA_OUTPUT > $FASTA_OUTPUT