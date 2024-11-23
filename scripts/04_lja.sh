#!/bin/bash

#SBATCH --job-name=lja_assembly
#SBATCH --output=lja_assembly_%j.out
#SBATCH --error=lja_assembly_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=16   # Adjust based on your computational resources
#SBATCH --mem=64G            # Adjust memory requirements
#SBATCH --time=48:00:00       # Adjust time as needed

# Define input reads and output directory
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
PACBIO_HIFI_READS=$WORKDIR/Ice-1/ERR11437339.fastq.gz
OUTPUT_DIR=$WORKDIR/lja

# Run LJA assembly within the container
apptainer exec /containers/apptainer/lja-0.2.sif lja \
    --reads $PACBIO_HIFI_READS \
    --output-dir $OUTPUT_DIR \
    --threads 16