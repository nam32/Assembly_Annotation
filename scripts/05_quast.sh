#!/bin/bash
#SBATCH --job-name=quast_analysis
#SBATCH --output=quast_analysis_%j.out
#SBATCH --error=quast_analysis_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=16  # Adjust based on available resources
#SBATCH --mem=64G           # Adjust memory requirements
#SBATCH --time=24:00:00     # Adjust time as needed

# Define the working directory
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
OUTPUT_DIR=$WORKDIR/quast_results

# Define paths to the assemblies
flye_assembly="$WORKDIR/flye_assembly/assembly.fasta"
hifiasm_assembly="$WORKDIR/hifiasm/assembly.fa"
lja_assembly="$WORKDIR/lja/assembly.fasta"

# Reference files
reference_genome="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"

# Path to the QUAST container
quast_container="/containers/apptainer/quast_5.2.0.sif"

# Ensure the output directory exists
mkdir -p ${OUTPUT_DIR}

# Define the number of CPUs to use
num_cpus=16

# Function to run QUAST
run_quast () {
    local assemblies=$1
    local output_name=$2
    local reference=$3

    # If reference is provided, use it
    if [ -n "$reference" ]; then
        apptainer exec ${quast_container} quast.py \
            -o ${OUTPUT_DIR}/${output_name} \
            --threads ${num_cpus} \
            --eukaryote \
            -R ${reference} \
            --large \
            ${assemblies}
    else
        # Run QUAST without reference
        apptainer exec ${quast_container} quast.py \
            -o ${OUTPUT_DIR}/${output_name} \
            --threads ${num_cpus} \
            --eukaryote \
            --large \
            ${assemblies}
    fi
}

# Run QUAST on genome assemblies without reference
run_quast "${flye_assembly}" "flye_quast_no_ref" ""
run_quast "${hifiasm_assembly}" "hifiasm_quast_no_ref" ""
run_quast "${lja_assembly}" "lja_quast_no_ref" ""

# Run QUAST on genome assemblies with reference
run_quast "${flye_assembly}" "flye_quast_with_ref" "${reference_genome}"
run_quast "${hifiasm_assembly}" "hifiasm_quast_with_ref" "${reference_genome}"
run_quast "${lja_assembly}" "lja_quast_with_ref" "${reference_genome}"

echo "QUAST analysis completed!"
