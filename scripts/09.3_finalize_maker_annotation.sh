#! /bin/bash

# This script finalizes the gene annotation process by:
# 1. Running InterProScan on the MAKER-generated protein file to annotate functional domains.
# 2. Updating the GFF and FASTA files with clean, prefix-based IDs.
# 3. Filtering GFF annotations based on AED values and InterProScan results for quality.
# 4. Extracting high-quality mRNA, transcript, and protein sequences for downstream analyses.
#
# **Workflow**:
# - Copies necessary MAKER output files (GFF, protein, transcript) into a dedicated "final" directory.
# - Updates IDs in the GFF and FASTA files using `maker_map_ids`, ensuring a clean naming convention.
# - Annotates protein sequences with InterProScan to identify functional domains and GO terms.
# - Updates the GFF file with InterProScan annotations and filters annotations for quality.
# - Extracts high-confidence mRNA entries and filters the corresponding transcript and protein FASTA files.
#
# **Inputs**:
# - Protein FASTA (`assembly.all.maker.proteins.fasta`)
# - Transcript FASTA (`assembly.all.maker.transcripts.fasta`)
# - GFF3 file (`assembly.all.maker.noseq.gff`)
#
# **Outputs**:
# - Updated and filtered GFF file with InterProScan annotations.
# - Filtered transcript and protein FASTA files containing high-quality mRNA entries.
#
# **Requirements**:
# - Modules: UCSC-Utils, BioPerl, MariaDB
# - Tools: MAKER utilities (e.g., `maker_map_ids`, `ipr_update_gff`, etc.), InterProScan, `faSomeRecords`
# - Proper paths and permissions for the input and output directories.
#
# Reference:
# - MAKER documentation: http://www.yandell-lab.org/software/maker.html
# - InterProScan: https://www.ebi.ac.uk/interpro/interproscan/

#SBATCH --job-name=final_maker_annotation
#SBATCH --output=final_maker_annotation_%j.out
#SBATCH --error=final_maker_annotation_%j.err
#SBATCH --ntasks=1
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=5:00:00

#protein=$1 # assembly.all.maker.proteins.fasta
#transcript=$2 # assembly.all.maker.transcripts.fasta
#gff=$3 # assembly.all.maker.noseq.gff
#prefix=$4 # ACCESSION ID 3-4 letter code
#maker_bin=$5 # $COURSEDIR/softwares/Maker_v3.01.03/src/bin
# This script finalizes the annotation process by performing several steps:
# 1. Runs InterProScan on the provided protein file.
# 2. Uses Maker tools to map IDs and update GFF and FASTA files with the new, clean IDs.
# 3. Updates the GFF file with InterProScan results and filters it for quality.
# 4. Extracts mRNA entries from the filtered GFF file and generates a list of IDs.
# 5. Uses the list of IDs to filter the transcript and protein FASTA files, creating new filtered FASTA files.
# Usage: finalize.sh <protein> <transcript> <gff> <prefix> <maker_bin>

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin" 
WORKDIR=/data/users/tjanjumratsang/assembly_annotation_course/final
protein="assembly.all.maker.proteins.fasta" 
transcript="assembly.all.maker.transcripts.fasta" 
gff="assembly.all.maker.noseq.gff"

module load UCSC-Utils/448-foss-2021a
module load BioPerl/1.7.8-GCCcore-10.3.0
module load MariaDB/10.6.4-GCC-10.3.0

# Create a directory to store the final files after filtering them based on AED values and InterProScan annotations
mkdir -p /data/users/tjanjumratsang/assembly_annotation_course/gene_annotation_directory/final

cd $WORKDIR

cp /data/users/tjanjumratsang/assembly_annotation_course/gene_annotation_directory/$gff /data/users/tjanjumratsang/assembly_annotation_course/final/${gff}.renamed.gff
cp /data/users/tjanjumratsang/assembly_annotation_course/gene_annotation_directory/$protein /data/users/tjanjumratsang/assembly_annotation_course/final/${protein}.renamed.fasta 
cp /data/users/tjanjumratsang/assembly_annotation_course/gene_annotation_directory/$transcript "/data/users/tjanjumratsang/assembly_annotation_course/final/assembly.all.maker.noseq.gff.renamed.fasta"

prefix="ice1"

# Give clean gene names, update the gff and fasta files
$MAKERBIN/maker_map_ids --prefix $prefix --justify 7 $gff.renamed.gff > id.map
$MAKERBIN/map_gff_ids id.map $gff.renamed.gff
$MAKERBIN/map_fasta_ids id.map ${protein}.renamed.fasta
$MAKERBIN/map_fasta_ids id.map ${transcript}.renamed.fasta


cd $WORKDIR

apptainer exec \
 --bind $COURSEDIR/data/interproscan-5.70-102.0/data:/opt/interproscan/data \
 --bind $WORKDIR \
 --bind $COURSEDIR \
 --bind $SCRATCH:/temp \
 $COURSEDIR/containers/interproscan_latest.sif \
 /opt/interproscan/interproscan.sh \
 -appl pfam --disable-precalc -f TSV \
 --goterms --iprlookup --seqtype p \
 -i ${protein}.renamed.fasta -o output.iprscan

# Update the gff file with InterProScan results and filter it for quality
$MAKERBIN/ipr_update_gff ${gff}.renamed.gff output.iprscan > ${gff}.renamed.iprscan.gff

perl $MAKERBIN/AED_cdf_generator.pl -b 0.025 ${gff}.renamed.gff >assembly.all.maker.renamed.gff.AED.txt

# Filter the gff file based on AED values and Pfam domains
perl $MAKERBIN/quality_filter.pl -a 0.5 ${gff}.renamed.iprscan.gff > ${gff}_iprscan_quality_filtered.gff

cut -f3 ${gff}_iprscan_quality_filtered.gff | sort | uniq

# Keep gene features in the third column of the gff file
grep -P "\tgene\t|\tCDS\t|\texon\t|\tfive_prime_UTR\t|\tthree_prime_UTR\t|\tmRNA\t" ${gff}_iprscan_quality_filtered.gff > filtered.genes.renamed.gff3
cut -f3 filtered.genes.renamed.gff3 | sort | uniq

# Add back the gff3 header to the filtered gff file so that it can be used by other tools
grep "^#" ${gff}_iprscan_quality_filtered.gff > header.txt
cat header.txt filtered.genes.renamed.gff3 > filtered.genes.renamed.final.gff3

# Get the names of remaining mRNAs and extract them from the transcript and and their proteins from the protein files
grep -P "\tmRNA\t" filtered.genes.renamed.final.gff3 | awk '{print $9}' | cut -d ';' -f1 | sed 's/ID=//g' >mRNA_list.txt
faSomeRecords ${transcript}.renamed.fasta mRNA_list.txt ${transcript}.renamed.filtered.fasta
faSomeRecords ${protein}.renamed.fasta mRNA_list.txt ${protein}.renamed.filtered.fasta
