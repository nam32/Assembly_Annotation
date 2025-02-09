# -------------------------------------------------------------------------
# Description:
# This script utilizes the GENESPACE package to perform synteny analysis 
# and visualize genomic relationships between species or accessions. 
# It performs the following steps:
# 1. Reads the working directory path from the command-line arguments.
# 2. Initializes GENESPACE parameters, including the path to the MCScanX 
#    executable, which is required for pairwise synteny comparisons.
# 3. Executes the GENESPACE workflow to identify and analyze syntenic 
#    regions across genomes.
#
# Key Functions:
# - Customizable working directory and MCScanX path allow flexible setups.
# - The `run_genespace` function ensures synteny analysis is performed with 
#   options for overwriting previous results.
#
# Required Libraries:
# - GENESPACE
#
# Inputs:
# - Command-line argument specifying the working directory (wd).
# - Properly formatted genome annotation and sequence files within the 
#   working directory.
#
# Outputs:
# - Synteny results and visualizations generated by GENESPACE.
#
# Notes:
# - Ensure the MCScanX executable path is correctly specified.
# - GENESPACE requires preprocessed genome files and annotations in the 
#   working directory.
# -------------------------------------------------------------------------


library(GENESPACE)

args <- commandArgs(trailingOnly = TRUE)
wd <- args[1]

# Set the path to the MCScanX executable
gpar <- init_genespace(wd = wd, path2mcscanx = "/usr/local/bin/MCScanX") 

# Run GENESPACE
out <- run_genespace(gpar, overwrite = TRUE)
