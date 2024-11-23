#!/bin/bash
#SBATCH --job-name=mummer_analysis
#SBATCH --output=mummer_analysis_%j.out
#SBATCH --error=mummer_analysis_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=8   # Adjust based on available resources
#SBATCH --mem=32G           # Adjust memory requirements
#SBATCH --time=24:00:00     # Adjust time as needed

# Define working directory and paths
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
OUTPUT_DIR=$WORKDIR/mummer_results
REFERENCE_GENOME="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"

# Paths to assemblies
flye_assembly="$WORKDIR/flye_assembly/assembly.fastaa"
hifiasm_assembly="$WORKDIR/hifiasm/assembly.fa"
lja_assembly="$WORKDIR/lja/assembly.fasta"

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
run_nucmer_and_plot ${REFERENCE_GENOME} ${flye_assembly} "flye_vs_ref"
run_nucmer_and_plot ${REFERENCE_GENOME} ${hifiasm_assembly} "hifiasm_vs_ref"
run_nucmer_and_plot ${REFERENCE_GENOME} ${lja_assembly} "lja_vs_ref"

# Compare the assemblies with each other
run_nucmer_and_plot ${flye_assembly} ${hifiasm_assembly} "flye_vs_hifiasm"
run_nucmer_and_plot ${flye_assembly} ${lja_assembly} "flye_vs_lja"
run_nucmer_and_plot ${hifiasm_assembly} ${lja_assembly} "hifiasm_vs_lja"

echo "MUMmer analysis completed!"
