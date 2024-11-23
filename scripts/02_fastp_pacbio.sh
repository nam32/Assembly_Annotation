#!/bin/bash

#SBATCH --time=1-00:00:00        # 1 day max time
#SBATCH --mem=16G                # Memory allocation
#SBATCH --cpus-per-task=4        # Number of CPUs
#SBATCH --job-name=fastp         # Updated job name to match fastp
#SBATCH --partition=pibu_el8     # Partition to run on
#SBATCH --output=fastp_%j.out    # Output log file
#SBATCH --error=fastp_%j.err     # Error log file

module load fastp

WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
OUTDIR=/data/users/tjanjumratsang/assembly_annotation_course/data

# Define input/output file paths
PACBIO_INPUT=$WORKDIR/Ice-1/ERR11437339.fastq.gz
PACBIO_OUTPUT=$OUTDIR/output_pacbio.fastq.gz
PACBIO_REPORT=$OUTDIR/pacbio_report.json
PACBIO_HTML=$OUTDIR/pacbio_report.html

fastp \
    -i $PACBIO_INPUT \
    -o $PACBIO_OUTPUT \
    --json $PACBIO_REPORT \
    --html $PACBIO_HTML \
    --disable_quality_filtering \
    --disable_length_filtering \
    --thread 4