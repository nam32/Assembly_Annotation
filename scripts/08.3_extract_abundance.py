# This script processes a TE annotation summary file (`genome.mod.EDTA.TEanno.sum`) and extracts relevant data 
# for TE abundance analysis. The processed output includes only the `ID` and `Count` columns and is saved 
# to a CSV file (`TE_abundance.txt`).

# **Workflow**:
# 1. Reads the input file line by line.
# 2. Cleans up each line by replacing multiple spaces with a single space.
# 3. Extracts relevant data lines (ignoring headers, separators, or non-data text).
# 4. Converts the processed data into a pandas DataFrame.
# 5. Saves the `ID` and `Count` columns into a CSV file for further analysis.

# **Input File Assumptions**:
# - The input file contains headers and separators (`=` or `total`) that are ignored.
# - Data lines follow a specific format with columns like `ID`, `Count`, `bpMasked`, and `%masked`.

# **Output**:
# - A CSV file (`TE_abundance.txt`) containing the `ID` and `Count` columns.

# **Requirements**:
# - Python packages: pandas, re
# - Input file: A text file in the format produced by EDTA's TE annotation summary.

# **Notes**:
# - Ensure the input file path (`input_file_path`) and output file path (`output_path`) are correct.
# - Modify the column selection or processing logic as needed based on your input file structure.

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
