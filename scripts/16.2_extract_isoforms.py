import re
from collections import defaultdict

#  OMArk requires a list of isoforms to be provided in a specific format. It should be semi-colon separated file, listing all isoforoms of each genes, with one gene per line

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
