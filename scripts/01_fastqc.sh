#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=fastqc
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
OUTDIR=/data/users/tjanjumratsang/assembly_annotation_course/read_QC

apptainer exec \
--bind $WORKDIR \
/containers/apptainer/fastqc-0.12.1.sif \
fastqc -o $OUTDIR/ $WORKDIR/Ice-1/ERR11437339.fastq.gz
