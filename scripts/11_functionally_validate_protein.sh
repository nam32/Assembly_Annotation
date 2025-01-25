#!/bin/bash
#SBATCH --job-name=validate_protein
#SBATCH --output=validate_protein_%j.out
#SBATCH --error=validate_protein_%j.err
#SBATCH --time=12:00:00
#SBATCH --partition=pibu_el8
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G

# Performs functional annotation of protein sequences by first running a BLASTp homology search against the UniProt database. Then it uses MAKER's functional annotation tools to annotate both the protein sequences and their corresponding gene annotations (GFF file) based on the homology results. The outputs are saved with .Uniprot suffices.

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"

cd /data/users/tjanjumratsang/assembly_annotation_course/final

module load BLAST+/2.15.0-gompi-2021a  # Load the BLAST+ module
module load SAMtools/1.13-GCC-10.3.0

# Run the BLASTp command to check homology ( Align proteins against UniProt database (uniprot_viridiplantae_reviewed.fa))
blastp -query longest_proteins.fasta \
       -db /data/courses/assembly-annotation-course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa \
       -num_threads 10 \
       -outfmt 6 \
       -evalue 1e-10 \
       -out blastp_output

echo "BLASTp homology check completed. Results saved to blastp_output"

# Map protein putative functions to MAKER produced gff3 and fasta files
# Copy original files and annotate with UniProt homology
cp assembly.all.maker.proteins.fasta.renamed.fasta assembly.all.maker.proteins.fasta.renamed.fasta.Uniprot
cp filtered.genes.renamed.gff3 filtered.genes.renamed.gff3.Uniprot

$MAKERBIN/maker_functional_fasta /data/courses/assembly-annotation-course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa blastp_output assembly.all.maker.proteins.fasta.renamed.fasta > assembly.all.maker.proteins.fasta.renamed.fasta.Uniprot
$MAKERBIN/maker_functional_gff /data/courses/assembly-annotation-course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa blastp_output filtered.genes.renamed.gff3 > filtered.genes.renamed.gff3.Uniprot

samtools faidx /data/users/tjanjumratsang/assembly_annotation_course/final/assembly.all.maker.proteins.fasta.renamed.fasta.Uniprot

echo "Functional annotation with UniProt homology completed."
