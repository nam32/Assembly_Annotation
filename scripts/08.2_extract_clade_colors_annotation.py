# This script processes transposable element (TE) clade annotations and assigns unique colors to each clade.
# It takes as input a combined TE annotation file and outputs a file with the following fields:
# - id: The identifier of the TE sequence.
# - color: A unique color assigned to the clade for visualization.
# - clade: The clade of the TE sequence.
#
# Functionality:
# 1. Reads the input file into a pandas DataFrame.
# 2. Extracts unique clades and assigns colors to each clade using a shuffled list of CSS4 colors.
# 3. Creates a new DataFrame containing the id, clade, and assigned color for each TE.
# 4. Saves the annotated data to a space-separated output file without headers or indices.
#
# Notes:
# - The input file path and output file path are hardcoded and need to be updated as required.
# - The script assumes specific column positions in the input file:
#   - Column 0: 'id' (TE identifier)
#   - Column 3: 'clade' (TE clade)
# - The script randomly assigns colors from a fixed palette (CSS4_COLORS).
#
# Requirements:
# - Python packages: pandas, numpy, matplotlib
# - Input file: The combined TE annotation file in a space-separated format with a header.
# - Output file: Annotated TE clade file with id, color, and clade columns.

import pandas as pd
import numpy as np
import matplotlib.colors as mcolors
import random
import matplotlib.colors as mcolors


input_file = f"Copia_combined_rexdb.txt"
input_file = f"Gypsy_combined_rexdb.txt"
final_output_file = f"Gypsy_clade_annotation.txt"


# Read the combined Copia file into a pandas DataFrame
data = pd.read_csv(input_file, sep=' ', header=0)
# Convert 'id' column to string to prevent concatenation issues
data.iloc[:, 0] = data.iloc[:, 0].astype(str)

# Extract unique clades
unique_clades = data.iloc[:, 3].unique()

# Assign a unique color to each clade using a color map
colors = list(mcolors.CSS4_COLORS.values()) 
random.shuffle(colors)  # Shuffle to ensure randomness

# Limit to unique colors based on the number of unique clades
clade_colors = {clade: colors[i % len(colors)] for i, clade in enumerate(unique_clades)}

# Create a new DataFrame for the output
output_data = data.copy()
output_data = output_data.iloc[:, [0, 3]]
output_data.columns = ['id', 'clade']

# Add color and modify the 'id' column
output_data['color'] = output_data['clade'].map(clade_colors)

# Save the output to the final output file
output_data[['id', 'color', 'clade']].to_csv(final_output_file, sep=' ', index=False, header=False)
