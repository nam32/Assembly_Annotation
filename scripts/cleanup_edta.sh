#!/bin/bash
#SBATCH --job-name=edta_annotation
#SBATCH --output=edta_clean_%j.out
#SBATCH --error=edta_clean_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=8   # Adjust based on available resources
#SBATCH --mem=32G           # Adjust memory requirements
#SBATCH --time=3:00:00     # Adjust time as needed

WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
OUTDIR=$WORKDIR/edta_annotation/contigs.fasta.mod.EDTA.raw/LTR
IMAGE=/data/courses/assembly-annotation-course/containers2/TEsorter_1.3.0.sif
ASSEMBLY=$WORKDIR/flye_assembly/assembly.fasta
DUSTED=/data/users/tjanjumratsang/assembly_annotation_course/edta_annotation/contigs.fasta.mod.EDTA.raw/LTR/contigs.fasta.mod.LTR.intact.fa


cd $OUTDIR

apptainer exec -C -H $WORKDIR -H ${pwd}:/work \
 --writable-tmpfs -u $IMAGE TEsorter $DUSTED -db rexdb-plant