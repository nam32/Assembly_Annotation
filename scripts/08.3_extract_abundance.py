import re
import pandas as pd

# Read the content from the file 'genome.mod.EDTA.TEanno.sum'
input_file_path = "contigs.fasta.mod.EDTA.TEanno.sum"
output_path = "TE_abundance.txt"

# Open the input file and read the lines
with open(input_file_path, 'r') as file:
    lines = file.readlines()

# Process each line to replace multiple spaces with a single space
processed_lines = [re.sub(r'\s+', ' ', line).strip() for line in lines]

# Extract data lines that contain actual values (ignore headers or separators)
data = []
for line in processed_lines:
    # Only process lines that contain valid data, skipping headers or other text
    if line and not line.startswith('=') and not line.startswith('ID') and not line.startswith('total'):
        data.append(line.split(' '))

# Convert the extracted data into a pandas DataFrame
# Assuming the columns are 'ID', 'Count', 'bpMasked', '%masked' based on your image
columns = ['ID', 'Count', 'bpMasked', '%masked']
df = pd.DataFrame(data, columns=columns)

# Display the resulting DataFrame
print(df)

df = df.iloc[:, [0, 1]]

# If you want to save this DataFrame to a CSV file for further use
df.to_csv(output_path, index=False)
