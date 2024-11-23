#!/bin/bash
#SBATCH --job-name=trinity_assembly
#SBATCH --output=trinity_assembly_%j.out
#SBATCH --error=trinity_assembly_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=16  # Adjust based on your computational resources
#SBATCH --mem=64G           # Adjust memory requirements
#SBATCH --time=48:00:00      # Adjust time as needed

# Load Trinity module
module load Trinity/2.15.1-foss-2021a

# Define input fastq files (comma-separated if multiple)
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
OUTPUT_DIR=$WORKDIR/trinity

LEFT_FASTQ="/data/users/tjanjumratsang/assembly_annotation_course/data/ERR754081_1_tr.fastq.gz"
RIGHT_FASTQ="/data/users/tjanjumratsang/assembly_annotation_course/data/ERR754081_2_tr.fastq.gz"

# Run Trinity
Trinity --seqType fq \
        --max_memory 64G \
        --CPU 16 \
        --left $LEFT_FASTQ \
        --right $RIGHT_FASTQ \
        --output $OUTPUT_DIR