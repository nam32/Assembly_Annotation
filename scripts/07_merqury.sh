#!/bin/bash
#SBATCH --job-name=merqury_analysis
#SBATCH --output=merqury_analysis_%j.out
#SBATCH --error=merqury_analysis_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=16  # Adjust based on available resources
#SBATCH --mem=80G           # Adjust memory requirements
#SBATCH --time=5:00:00     # Adjust time as needed

# Define working directory
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course/merq

# Create the directory if it does not exist
mkdir -p $WORKDIR

# Run meryl to generate the database
apptainer exec \
--bind $WORKDIR \
/containers/apptainer/merqury_1.3.sif \
bash -c "meryl k=23 count /data/users/tjanjumratsang/assembly_annotation_course/Ice-1/ERR11437339.fastq.gz output $WORKDIR/reads.meryl"

export MERQURY="/usr/local/share/merqury"

# Define paths for input files and output
READS_MERYL="${WORKDIR}/reads.meryl"

flye_assembly="/data/users/tjanjumratsang/assembly_annotation_course/flye_assembly/assembly.fasta"
hifiasm_assembly="/data/users/tjanjumratsang/assembly_annotation_course/hifiasm/assembly.fa"
lja_assembly="/data/users/tjanjumratsang/assembly_annotation_course/lja/assembly.fasta"

SCRIPT_DIR="/data/users/tjanjumratsang/assembly_annotation_course/scripts"

# Run the Merqury script inside the container using apptainer

# Flye Assembly Analysis
mkdir -p ${WORKDIR}/flye
cd ${WORKDIR}/flye
OUTPUT_PREFIX="flye"
apptainer exec /containers/apptainer/merqury_1.3.sif bash $SCRIPT_DIR/merqury.sh $READS_MERYL $flye_assembly $OUTPUT_PREFIX

# Hifiasm Assembly Analysis
mkdir -p ${WORKDIR}/hifiasm
cd ${WORKDIR}/hifiasm
OUTPUT_PREFIX="hifiasm"
apptainer exec /containers/apptainer/merqury_1.3.sif bash $SCRIPT_DIR/merqury.sh $READS_MERYL $hifiasm_assembly $OUTPUT_PREFIX

# LJA Assembly Analysis
mkdir -p ${WORKDIR}/lja
cd ${WORKDIR}/lja
OUTPUT_PREFIX="lja"
apptainer exec /containers/apptainer/merqury_1.3.sif bash $SCRIPT_DIR/merqury.sh $READS_MERYL $lja_assembly $OUTPUT_PREFIX
