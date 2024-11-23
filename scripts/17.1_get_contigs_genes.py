# Preparing files for genespace
# Directory structure should be like so:
# /workingDirectory 
# ├─ peptide 
# │   ├─ Accession1.fa 
# │   ├─ Accession2.fa 
# │   └─ TAIR10.fa 
# ├─ bed 
# │   ├─ Accession1.bed 
# │   ├─ Accession2.bed 
# │   └─ TAIR10.bed 

import csv
import re
from collections import defaultdict

############################
## get 20 longest contigs ##
############################

# Define file paths
contigs_file = "longest_contigs.fai"
gff_file = "filtered.genes.renamed.final.gff3"
output_file = "genes_in_longest_contigs.gff3"

# Step 1: Read contig names from the longest_contigs.fai.txt
with open(contigs_file, 'r') as f:
    contig_names = [line.split()[0] for line in f]
    print(contig_names)

# Step 2: Extract genes from the GFF file based on the selected contigs
with open(gff_file, 'r') as gff, open(output_file, 'w', newline='') as out:
    gff_reader = csv.reader(gff, delimiter='\t')
    out_writer = csv.writer(out, delimiter='\t')

    # Write header if present in GFF file
    for line in gff:
        if line.startswith("#"):
            out.write(line)
        else:
            break
    gff.seek(0)

    # Read GFF content and filter for selected contigs and gene features
    for row in gff_reader:
        if len(row) < 3:  # Ignore lines with insufficient columns
            continue
        contig, source, feature = row[0], row[1], row[2]
        
        if contig in contig_names and feature == "gene":
            out_writer.writerow(row)

print(f"Genes from the longest contigs are saved in {output_file}")

# Extract entries from longest_proteins.fasta where the IDs (ignoring the part after the "-") match the IDs in the last column of ice.bed

from Bio import SeqIO

# Paths to input files
fasta_file = "longest_proteins.fasta"
bed_file = "ice1.bed"
output_file = "ice1.fa"

# Extract gene IDs from ice.bed (remove parts after "-")
with open(bed_file, 'r') as bed:
    gene_ids = {line.strip().split("\t")[-1].split("-")[0] for line in bed}

# Filter, format, and write matching FASTA entries to output
with open(output_file, 'w') as output:
    for record in SeqIO.parse(fasta_file, "fasta"):
        # Extract the gene ID (ignoring part after "-")
        gene_id = record.id.split("-")[0]
        if gene_id in gene_ids:
            # Update the record ID to keep only the gene ID before "-"
            record.id = gene_id
            record.description = ""
            SeqIO.write(record, output, "fasta")

######################
## Extract isoforms ##
######################

# Define the input and output file paths
input_file = "assembly.all.maker.proteins.fasta.renamed.filtered.fasta"
output_file = "isoforms_list.txt"

# Initialize a dictionary to store isoforms by gene name
isoforms_dict = defaultdict(list)

# Read the input file and extract isoform information
with open(input_file, 'r') as file:
    for line in file:
        if line.startswith('>'):
            match = re.match(r">(ice\d+[-\w]*)", line)
            print(match)
            if match:
                gene_name = match.group(1).split('-')[0]
                isoforms_dict[gene_name].append(match.group(1))

# Write the extracted isoforms to the output file in the required format
with open(output_file, 'w') as file:
    for gene_name, isoforms in isoforms_dict.items():
        file.write(';'.join(isoforms) + '\n')
