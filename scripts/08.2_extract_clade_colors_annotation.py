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
