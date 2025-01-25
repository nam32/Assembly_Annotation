#!/bin/bash

# This script performs k-mer counting using Jellyfish for a PacBio FASTQ file, followed by
# generating a k-mer frequency histogram for downstream analysis. The results can be used 
# with GenomeScope for further genome size and heterozygosity analysis.
#
# Usage:
#   This script is designed to run on a Slurm-based cluster environment.
#   The output includes:
#     - A Jellyfish database file containing k-mer counts.
#     - A k-mer frequency histogram in plain text format.
#
# Prerequisites:
#   - Ensure Jellyfish is installed or loaded as a module.
#   - The input file should be in gzipped FASTQ format.
#
# Parameters:
#   - K-mer size: 21
#   - Input file: PacBio reads (ERR11437339.fastq.gz)

#SBATCH --time=00:30:00
#SBATCH --mem=40G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=jellyfish_count
#SBATCH --partition=pibu_el8
#SBATCH --output=jellyfish_%j.out
#SBATCH --error=jellyfish_%j.err

module load Jellyfish/2.3.0-GCC-10.3.0

# Set working directory and file paths
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
OUTDIR=$WORKDIR/pacbio_kmer_counting
FASTQ_ice1=$WORKDIR/Ice-1/ERR11437339.fastq.gz

# Run jellyfish count
jellyfish count \
    -C \
    -m 21 \
    -s 5G \
    -t 4 \
    -o $OUTDIR/mer_counts.jf \
    <(zcat $FASTQ_ice1)

# Create a k-mer frequency histogram
jellyfish histo \
    -t 4 \
    $OUTDIR/mer_counts.jf > $OUTDIR/mer_counts.histo
