#!/bin/bash

#SBATCH --job-name=extract_longest_isoforms
#SBATCH --output=extract_longest_isoforms_%j.out
#SBATCH --error=extract_longest_isoforms_%j.err
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

module load Biopython/1.79-foss-2021a

# Run the Python script
python - <<EOF
from Bio import SeqIO

def extract_longest_isoforms(input_fasta, output_fasta):
    # Dictionary to store the longest sequence for each gene
    longest_sequences = {}

    for record in SeqIO.parse(input_fasta, "fasta"):
        # Extract the main gene ID (e.g., "ice0009061" from "ice0009061-RA")
        gene_id = record.id.split('-')[0]

        # Check if this gene is already in the dictionary or if this sequence is longer
        if gene_id not in longest_sequences or len(record.seq) > len(longest_sequences[gene_id].seq):
            longest_sequences[gene_id] = record

    # Write the longest isoforms to the output FASTA file
    with open(output_fasta, "w") as output_handle:
        SeqIO.write(longest_sequences.values(), output_handle, "fasta")

# Specify the input and output file paths for transcripts
input_fasta_transcript = "/data/users/tjanjumratsang/assembly_annotation_course/final/assembly.all.maker.transcripts.fasta.renamed.fasta"
output_fasta_transcript = "/data/users/tjanjumratsang/assembly_annotation_course/final/longest_transcripts.fasta"
extract_longest_isoforms(input_fasta_transcript, output_fasta_transcript)

# Specify the input and output file paths for proteins
input_fasta_protein = "/data/users/tjanjumratsang/assembly_annotation_course/final/assembly.all.maker.proteins.fasta.renamed.fasta"
output_fasta_protein = "/data/users/tjanjumratsang/assembly_annotation_course/final/longest_proteins.fasta"
extract_longest_isoforms(input_fasta_protein, output_fasta_protein)
EOF
