#!/bin/bash
#SBATCH --job-name=busco_analysis
#SBATCH --output=busco_analysis_%j.out
#SBATCH --error=busco_analysis_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=16  # Adjust based on your computational resources
#SBATCH --mem=64G           # Adjust memory requirements
#SBATCH --time=48:00:00     # Adjust time as needed

# Load the BUSCO module
module load BUSCO/5.4.2-foss-2021a

# Define working directory and output directory
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course
OUTPUT_DIR=$WORKDIR/busco

# Define paths to the assemblies
flye_assembly="$WORKDIR/flye_assembly/assembly.fasta"
hifiasm_assembly="$WORKDIR/hifiasm/assembly.fa"
lja_assembly="$WORKDIR/lja/assembly.fasta"
trinity_assembly="$WORKDIR/trinity.Trinity.fasta"

# Ensure the output directory exists
mkdir -p ${OUTPUT_DIR}

# Define the number of CPUs to use (should match or be less than --cpus-per-task)
num_cpus=16

# Define lineage (use --auto-lineage or specify the lineage manually)
lineage="--lineage brassicales_odb10"

# Function to run BUSCO
run_busco () {
    local input_file=$1
    local output_name=$2
    local mode=$3

    busco \
        --in ${input_file} \
        --out ${output_name} \
        --mode ${mode} \
        ${lineage} \
        --cpu ${num_cpus} \
        --out_path ${OUTPUT_DIR} \
        -f  # Force overwrite of existing results
}

# Run BUSCO on genome assemblies
run_busco ${flye_assembly} "flye_busco" "genome"
run_busco ${hifiasm_assembly} "hifiasm_busco" "genome"
run_busco ${lja_assembly} "lja_busco" "genome"

# Run BUSCO on transcriptome assembly
run_busco ${trinity_assembly} "trinity_busco" "transcriptome"

echo "BUSCO analysis completed!"
