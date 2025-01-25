"""
This script processes a FASTA file to generate a list of isoforms grouped by gene in a format required by OMArk. 
Each line in the output file corresponds to one gene and lists all its associated isoforms, separated by semicolons.

**Workflow**:
1. Reads the input FASTA file and parses the header lines to extract gene and isoform identifiers.
2. Groups isoforms by their corresponding gene name.
3. Writes the grouped isoforms to an output file in the required semi-colon separated format.

**Input**:
- A FASTA file with headers in the format `>gene-isoform` (e.g., `>ice0009061-RA`).

**Output**:
- A text file (`isoforms_list.txt`) where each line contains:
  - The gene name.
  - A list of its isoforms, separated by semicolons (e.g., `ice0009061-RA;ice0009061-RB`).

**Requirements**:
- Python 3.6+
- The input FASTA file must follow the naming convention `>gene-isoform`.

**Variables**:
- `input_file`: Path to the input FASTA file.
- `output_file`: Path to the output file (`isoforms_list.txt`).
"""

import re
from collections import defaultdict

# OMArk requires a list of isoforms to be provided in a specific format. It should be semi-colon separated file, listing all isoforoms of each genes, with one gene per line

# Define the input and output file paths
input_file = "/path/to/assembly.all.maker.proteins.fasta.renamed.filtered.fasta"
output_file = "/path/to/isoforms_list.txt"

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
