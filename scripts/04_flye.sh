#!/bin/bash

#SBATCH --job-name=flye_assembly
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pibu_el8
#SBATCH --output=flye_assembly_%j.out
#SBATCH --error=flye_assembly_%j.err

# Load Apptainer (Singularity) module
module load apptainer

# Define input reads and output directory
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
PACBIO_HIFI_READS=$WORKDIR/Ice-1/ERR11437339.fastq.gz
OUTPUT_DIR=$WORKDIR/flye_assembly

# Run Flye within the container
apptainer exec /containers/apptainer/flye_2.9.5.sif flye \
    --pacbio-hifi $PACBIO_HIFI_READS \
    --out-dir $OUTPUT_DIR \
    --threads 16
