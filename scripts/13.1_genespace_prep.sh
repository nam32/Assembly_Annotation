# Preparing files for genespace
# Directory structure should be like so:
# /workingDirectory 
# ├─ peptide 
# │   ├─ Accession1.fa 
# │   ├─ Accession2.fa 
# │   └─ TAIR10.fa 
# ├─ bed 
# │   ├─ Accession1.bed 
# │   ├─ Accession2.bed 
# │   └─ TAIR10.bed 

module load SAMtools/1.13-GCC-10.3.0

# Generate .fai file
samtools faidx assembly.fasta

# Get 20 longest contigs
sort -k 2,2nr assembly.fasta.fai | head -20 > longest_contigs.fai

module load BEDTools/2.30.0-GCC-10.3.0

# Create .bed file extract positions of each gene in the selected 20 contigs from the filtered gff3 file content format: chr\tstart\tend\tgene_name
bedtools sort -i genes_in_longest_contigs.gff3 | \
awk '$3 == "gene" {
    split($9, attr, ";");
    for (i in attr) {
        if (attr[i] ~ /^ID=/) {
            gene_name = substr(attr[i], 4);
        }
    }
    print $1, $4-1, $5, gene_name
}' OFS='\t' > ice1.bed
