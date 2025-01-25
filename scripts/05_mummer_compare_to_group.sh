#!/bin/bash
#SBATCH --job-name=mummer_analysis
#SBATCH --output=compare_accessions_mummer_analysis_%j.out
#SBATCH --error=compare_accessions_mummer_analysis_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

# Define working directory and paths
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
OUTPUT_DIR=$WORKDIR/mummer_results
REFERENCE_GENOME="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"

# Paths to assemblies
ice_flye_assembly="$WORKDIR/flye_assembly/assembly.fasta"
edi_flye_assembly="/data/users/acastro/genome_assembly_annotation/analysis/flyeEdi-0/assembly.fasta"
pyl_flye_assembly="/data/users/mrubin/assembly_annotation_course/flye_output/assembly.fasta"

# Path to the MUMmer container
MUMMER_CONTAINER="/containers/apptainer/mummer4_gnuplot.sif"

# Ensure the output directory exists
mkdir -p ${OUTPUT_DIR}

# Function to run nucmer and mummerplot
run_nucmer_and_plot () {
    local reference=$1
    local assembly=$2
    local prefix=$3

    # Run nucmer
    apptainer exec ${MUMMER_CONTAINER} nucmer --prefix=${OUTPUT_DIR}/${prefix} --breaklen 1000 --mincluster 1000 ${reference} ${assembly}

    # Run mummerplot
    #apptainer exec ${MUMMER_CONTAINER} mummerplot --png --layout --large -p ${OUTPUT_DIR}/${prefix} ${OUTPUT_DIR}/${prefix}.delta
    apptainer exec ${MUMMER_CONTAINER} mummerplot -R ${reference} -Q ${assembly} --breaklen 1000 --filter -t png --large --layout --fat -p ${OUTPUT_DIR}/${prefix} ${OUTPUT_DIR}/${prefix}.delta

}

# Compare each assembly with the reference genome
run_nucmer_and_plot ${ice_flye_assembly} ${edi_flye_assembly} "ice_vs_edi"
run_nucmer_and_plot ${ice_flye_assembly} ${pyl_flye_assembly} "ice_vs_pyl"
run_nucmer_and_plot ${pyl_flye_assembly} ${edi_flye_assembly} "pyl_vs_edi"

echo "MUMmer analysis completed!"
