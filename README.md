# Assembly and Annotation Pipeline for *Arabidopsis thaliana*

This repository contains a pipeline for the assembly and annotation of the *Arabidopsis thaliana* genome accession ICE1 using Next-Generation Sequencing (NGS) technologies. The pipeline includes scripts for quality control, genome assembly, transcriptome assembly, TE annotation, phylogenetic analysis, gene annotation, functional validation, orthologous group analysis, and downstream analyses such as GENESPACE synteny.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Usage](#usage)
3. [Directory Structure](#directory-structure)
4. [Features](#features)
5. [Software Versions](#software-versions)
6. [Contributing](#contributing)
7. [Contact](#contact)

## Getting Started

### Prerequisites

- Access to an HPC system with SLURM workload manager
- Software tools installed, or access to Singularity/Apptainer containers

### Installation

Set up the environment by installing necessary dependencies using Conda or any other package manager:

```sh
conda create -n assembly_env python=3.8
conda activate assembly_env
conda install biopython
```

Alternatively, use the provided Singularity/Apptainer containers to run the tools.

## Usage

The pipeline consists of several scripts that should be executed in sequence. Below is an overview of each script and its purpose.

### 1. Quality Control of Reads

- **`01_fastqc.sh`**: Runs FastQC to assess the quality of raw sequencing reads from *Ice-1*.
- **`01_fastqc_rnaSha.sh`**: Runs FastQC on RNA sequencing data for *Sha*.

### 2. Preprocessing Reads

- **`02_fastp_illumina.sh`**: Uses Fastp to filter and trim Illumina reads.
- **`02_fastp_pacbio.sh`**: Uses Fastp to preprocess PacBio reads, focusing on adapter removal.

### 3. K-mer Counting

- **`03_best_k.sh`**: Calculates the optimal k-mer size for k-mer analysis, given the genome size and a tolerable collision rate.
- **`03_kmers.sh`**: Performs k-mer counting using Jellyfish to estimate genome size and complexity. Results can be further analyzed using GenomeScope.

### 4. Genome and Transcriptome Assembly

- **`04_flye.sh`**: Assembles the genome using Flye, targeting PacBio HiFi reads.
- **`04_hifiasm.sh`**: Assembles the genome using Hifiasm.
- **`04_lja.sh`**: Assembles the genome using LJA.
- **`04_trinity.sh`**: Assembles the transcriptome using Trinity with paired-end Illumina reads.

### 5. Quality Assessment

- **`05_busco.sh`**: Runs BUSCO to assess genome and transcriptome assembly completeness.
- **`05_merqury.sh`**: Runs Merqury to evaluate assembly quality using k-mer information.
- **`05_mummer_compare_to_group.sh`**: Runs MUMmer to compare assemblies against a reference genome and to compare assemblies with each other.
- **`05_nucmer_mummer.sh`**: Runs Nucmer to compare assemblies against a reference genome and for assembly comparisons.
- **`05_quast.sh`**: Uses QUAST to assess the quality of the assembled genomes, both with and without a reference.
- **`05_quast_tgt.sh`**: Runs a comparative analysis of all genome assemblies with and without reference using QUAST.


### 6. Transposable Element (TE) Annotation and Analysis

- **`06.1_edta.sh`**: Uses EDTA for transposable element annotation on the Flye assembly.
- **`06.2_TE_sorter.sh`**: Uses TEsorter to classify and refine TE annotations, extracting specific elements like Copia and Gypsy.
- **`06.3_full_length_LTRs_identity.R`**: R script for identifying full-length LTRs in the TE analysis.

### 7. Insertion Age Analysis

- **`07.1_insertion_age.sh`**: Analyzes the insertion age of annotated transposable elements by parsing RepeatMasker output.
- **`07.2_plot_div.R`**: R script to plot the insertion age distribution of transposable elements.

### 8. Phylogenetic TE Analysis

- **`08.1_phylogenetic_TE_analysis.sh`**: Extracts reverse transcriptase sequences from Copia and Gypsy elements for phylogenetic analysis, performs multiple sequence alignment, and builds phylogenetic trees.
- **`08.2_extract_clade_colors_annotation.py`**: Assigns colors to different TE clades for visualization.
- **`08.3_extract_abundance.py`**: Extracts abundance information of TE elements from EDTA summary files.

### 9. Gene Annotation with MAKER

- **`09.2_maker.sh`**: Runs the MAKER pipeline to annotate genes using RepeatMasker and other tools.
- **`09.3_finalize_maker_annotation.sh`**: Finalizes the gene annotation by performing InterProScan analysis, assigning clean IDs, filtering annotations, and generating final GFF and FASTA files.

### 10. Post-processing and Quality Assessment of Annotations

- **`10.1_BUSCO_prep_extract_longest_fasta.sh`**: Extracts the longest isoform from transcript and protein FASTA files for further analysis.
- **`10.2_BUSCO_on_MAKER.sh`**: Runs BUSCO analysis on the extracted longest protein and transcript isoforms to evaluate annotation completeness.

### 11. Functional Annotation

- **`11_functionally_validate_protein.sh`**: Performs functional annotation of protein sequences using BLASTp against the UniProt database, followed by functional annotation using MAKER tools.

### 12. Orthologous Group Analysis with OMArk

- **`12.1_omark_prep.sh`**: Prepares the necessary files and runs an OMAmmer search to identify orthologous groups.
- **`12.2_extract_isoforms.py`**: Extracts isoform information from protein files for use with OMArk.
- **`12.3_run_omark.sh`**: Runs OMArk to assess the quality of the coding-gene repertoire annotation.
- **`12.4_hog_refinement.sh`**: Uses Miniprot to refine conserved orthologous groups (HOGs) by aligning them against the genome assembly.
- **`12.5_omark_contextualize.py`**: Contextualizes OMArk results to assess assembly completeness and annotate fragmented or missing genes.

### 13. Genespace Analysis

- **`13.1_genespace_prep.sh`**: Prepares files for GENESPACE analysis, creating `.bed` and `.fai` files for selected contigs.
- **`13.1_get_contigs_genes.py`**: Extracts genes from the longest contigs for use in GENESPACE.
- **`13.2_genespace.sh`**: Runs GENESPACE to perform synteny analysis of the assemblies.
- **`13.3_parse_Orthofinder.R`**: R script for parsing Orthofinder results as part of the GENESPACE analysis.

## Directory Structure

```
├── scripts/                # Contains all SLURM job scripts for pipeline steps
├── data/                   # Contains input datasets (e.g., FASTQ files)
├── results/                # Directory for all output results from assemblies and QC
├── README.md               # Documentation for the project
└── environment.yml         # Conda environment setup file (optional)
```

## Features

- **Quality Control**: FastQC and Fastp for assessing and trimming raw sequencing reads.
- **K-mer Analysis**: Jellyfish for estimating genome characteristics.
- **Genome and Transcriptome Assembly**: Flye, Hifiasm, LJA for genomes, and Trinity for transcriptomes.
- **Quality Assessment**: BUSCO and QUAST to evaluate assembly quality.
- **Comparative Analysis**: MUMmer for comparing assemblies against reference and each other.
- **TE Annotation and Analysis**: EDTA for transposable element annotation, TEsorter for classification, phylogenetic analysis, and insertion age analysis using RepeatMasker.
- **Gene Annotation**: MAKER for annotating the genome, along with tools for ID mapping and filtering annotations.
- **Orthologous Group Analysis**: OMArk for identifying orthologous groups and assessing annotation quality.
- **Functional Annotation**: BLASTp and MAKER tools for functional annotation based on homology to UniProt.
- **Synteny Analysis**: GENESPACE for synteny analysis and identifying conserved genes across different accessions.

## Software Versions

- **FastQC**: v0.11.9
- **Fastp**: v0.23.2
- **Jellyfish**: v2.3.0
- **Flye**: v2.9.5
- **Hifiasm**: v0.19.8
- **LJA**: v0.2
- **Trinity**: v2.15.1
- **BUSCO**: v5.4.2
- **QUAST**: v5.2.0
- **Merqury**: v1.3
- **MUMmer**: v4.0.0
- **EDTA**: v1.9.6
- **TEsorter**: v1.4.10
- **BioPerl**: v1.7.8
- **MAKER**: v3.01.03
- **InterProScan**: v5.52-86.0
- **Clustal Omega**: v1.2.4
- **FastTree**: v2.1.10
- **BLAST+**: v2.15.0
- **OMArk**: v1.0.0
- **GENESPACE**: Latest available container

## Contributing

Contributions are welcome! Please fork this repository and submit a pull request. For major changes, please open an issue first to discuss what you would like to change.

## Contact

Maintained by Nam. For questions, contact me at [[nam.janjumratsang@gmail.com]].
