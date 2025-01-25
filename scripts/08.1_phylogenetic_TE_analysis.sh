#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --time=5:00:00
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=phylo_TE_analysis
#SBATCH --output=phylo_TE_analysis_%j.out
#SBATCH --error=phylo_TE_analysis_%j.err

# This script performs a phylogenetic analysis of retrotransposons (Copia and Gypsy) using sequences from 
# Arabidopsis and Brassicaceae transposable element (TE) libraries. It extracts, aligns, and constructs 
# phylogenetic trees for reverse transcriptase (RT) domains.
#
# Usage:
#   Designed to run on a Slurm-based cluster environment. It leverages SeqKit, Clustal Omega, 
#   and FastTree for TE sequence processing and analysis. TEsorter is used for domain classification.
#
# Output:
#   - Extracted RT sequences for Copia and Gypsy retrotransposons.
#   - Multiple sequence alignments for Copia and Gypsy RT domains.
#   - Phylogenetic trees for Copia and Gypsy retrotransposons.
#
# Requirements:
#   - SeqKit module must be loaded.
#   - Clustal Omega and FastTree must be available.
#   - TEsorter must be accessible via Singularity (Apptainer) container.
#   - Input TE libraries must be in FASTA format.
#
# References:
#   - SeqKit: https://bioinf.shenwei.me/seqkit
#   - TEsorter: https://github.com/zhangrengang/TEsorter
#   - Clustal Omega: https://www.ebi.ac.uk/Tools/msa/clustalo/
#   - FastTree: http://www.microbesonline.org/fasttree/

# Directories and file paths for input and output files
DIR_EDTA=/data/users/tjanjumratsang/assembly_annotation_course/edta_annotation
DIR_RT_DOMAIN_COPIA=$DIR_EDTA/Copia_sequences.fa.rexdb-plant.dom.faa
DIR_RT_DOMAIN_GYPSI=$DIR_EDTA/Gypsy_sequences.fa.rexdb-plant.dom.faa
RT_COPIA_PROTEIN=$DIR_EDTA/Copia_sequences.fa.rexdb-plant.cls.pep
RT_GYPSY_PROTEIN=$DIR_EDTA/Gypsy_sequences.fa.rexdb-plant.cls.pep

# Load modules
module load SeqKit/2.6.1
module load Clustal-Omega/1.2.4-GCC-10.3.0
module load FastTree/2.1.11-GCCcore-10.3.0

# Extract RT sequences for Copia (Ty1-RT)
grep Ty1-RT $DIR_RT_DOMAIN_COPIA >$DIR_EDTA/copia_list.txt
sed -i 's/>//' $DIR_EDTA/copia_list.txt
sed -i 's/ .\+//' $DIR_EDTA/copia_list.txt
seqkit grep -f $DIR_EDTA/copia_list.txt $DIR_RT_DOMAIN_COPIA -o $DIR_EDTA/Copia_RT.fasta

# Extract RT sequences for Gypsy (Ty3-RT)
grep Ty3-RT $DIR_RT_DOMAIN_GYPSI >$DIR_EDTA/gypsy_list.txt
sed -i 's/>//' $DIR_EDTA/gypsy_list.txt
sed -i 's/ .\+//' $DIR_EDTA/gypsy_list.txt
seqkit grep -f $DIR_EDTA/gypsy_list.txt $DIR_RT_DOMAIN_GYPSI -o $DIR_EDTA/Gypsy_RT.fasta

##################################################

Brassicaceae_TE_db=/data/courses/assembly-annotation-course/CDS_annotation/data/Brassicaceae_repbase_all_march2019.fasta

seqkit grep -r -p "Copia" $Brassicaceae_TE_db > $DIR_EDTA/Copia_sequences_Brassicaceae.fa
seqkit grep -r -p "Gypsy" $Brassicaceae_TE_db > $DIR_EDTA/Gypsy_sequences_Brassicaceae.fa

# TEsorter for Copia retrotransposons
apptainer exec -C -H $DIR_EDTA \
 --writable-tmpfs -u /data/courses/assembly-annotation-course/containers2/TEsorter_1.3.0.sif TEsorter $DIR_EDTA/Copia_sequences_Brassicaceae.fa -db rexdb-plant

# TEsorter for Gypsy retrotransposons
apptainer exec -C -H $DIR_EDTA \
 --writable-tmpfs -u /data/courses/assembly-annotation-course/containers2/TEsorter_1.3.0.sif TEsorter $DIR_EDTA/Gypsy_sequences_Brassicaceae.fa -db rexdb-plant

 ##################################################

DIR_RT_DOMAIN_COPIA_BRA=$DIR_EDTA/Copia_sequences_Brassicaceae.fa.rexdb-plant.dom.faa
DIR_RT_DOMAIN_GYPSI_BRA=$DIR_EDTA/Gypsy_sequences_Brassicaceae.fa.rexdb-plant.dom.faa

# Extract RT sequences for Copia (Ty1-RT) from Brassicaceae
grep Ty1-RT $DIR_RT_DOMAIN_COPIA_BRA >$DIR_EDTA/Copia_list_Brassicaceae.txt
sed -i 's/>//' $DIR_EDTA/Copia_list_Brassicaceae.txt
sed -i 's/ .\+//' $DIR_EDTA/Copia_list_Brassicaceae.txt
seqkit grep -f $DIR_EDTA/Copia_list_Brassicaceae.txt $DIR_RT_DOMAIN_COPIA_BRA -o $DIR_EDTA/Copia_RT_Brassicaceae.fasta

# Extract RT sequences for Gypsy (Ty3-RT) from Brassicaceae
grep Ty3-RT $DIR_RT_DOMAIN_GYPSI_BRA >$DIR_EDTA/Gypsy_list_Brassicaceae.txt
sed -i 's/>//' $DIR_EDTA/Gypsy_list_Brassicaceae.txt
sed -i 's/ .\+//' $DIR_EDTA/Gypsy_list_Brassicaceae.txt
seqkit grep -f $DIR_EDTA/Gypsy_list_Brassicaceae.txt $DIR_RT_DOMAIN_GYPSI_BRA -o $DIR_EDTA/Gypsy_RT_Brassicaceae.fasta

# Concatenate RT Sequences from Both Brassicaceae and Arabidopsis
cat $DIR_EDTA/Copia_RT.fasta $DIR_EDTA/Copia_RT_Brassicaceae.fasta >$DIR_EDTA/Concatenated_Copia_RT.fasta
cat $DIR_EDTA/Gypsy_RT.fasta $DIR_EDTA/Gypsy_RT_Brassicaceae.fasta >$DIR_EDTA/Concatenated_Gypsy_RT.fasta

sed 's/^>\([^|#:; ]*\).*/>\1/' Concatenated_Copia_RT.fasta > Concatenated_header_truncated_Copia_RT.fasta
sed 's/^>\([^|#:; ]*\).*/>\1/' Concatenated_Gypsy_RT.fasta > Concatenated_header_truncated_Gypsy_RT.fasta

# Clustal Omega for multiple sequence alignment
clustalo -i $DIR_EDTA/Concatenated_header_truncated_Copia_RT.fasta -o $DIR_EDTA/Aligned_Copia_RT.fasta --outfmt=fasta --force
clustalo -i $DIR_EDTA/Concatenated_header_truncated_Gypsy_RT.fasta -o $DIR_EDTA/Aligned_Gypsy_RT.fasta --outfmt=fasta --force

# FastTree to build phylogenetic trees
FastTree -out $DIR_EDTA/Aligned_Copia_RT_tree.nwk $DIR_EDTA/Aligned_Copia_RT.fasta
FastTree -out $DIR_EDTA/Aligned_Gypsy_RT_tree.nwk $DIR_EDTA/Aligned_Gypsy_RT.fasta