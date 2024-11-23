#!/bin/bash

#SBATCH --time=2-00:00:00              # 2 days maximum time
#SBATCH --mem=40G                      # Allocate at least 40GB of memory
#SBATCH --cpus-per-task=4              # Number of CPUs
#SBATCH --job-name=jellyfish_count     # Job name
#SBATCH --partition=pibu_el8           # Partition name
#SBATCH --output=jellyfish_%j.out      # Output log file
#SBATCH --error=jellyfish_%j.err       # Error log file

# 
# module --ignore_cache load "jellyfish"                # Load jellyfish module
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


# analyzed results not trimmed: http://genomescope.org/genomescope2.0/analysis.php?code=P1GhBdC8x2YMEKMKswjG
# analyzed result pacbio: http://genomescope.org/genomescope2.0/analysis.php?code=wGgxMCFdjaE3IOjJrAlY
