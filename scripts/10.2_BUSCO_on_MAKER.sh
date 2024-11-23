#!/bin/bash

#SBATCH --job-name=MAKER_BUSCO
#SBATCH --output=MAKER_BUSCO_%j.out
#SBATCH --error=MAKER_BUSCO_%j.err
#SBATCH --time=06:00:00
#SBATCH --partition=pibu_el8
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8  # Example to use 8 CPUs

cd /data/users/tjanjumratsang/assembly_annotation_course/final

module load BUSCO/5.4.2-foss-2021a 

busco -i longest_proteins.fasta -l brassicales_odb10 -o maker_busco_output_protein -m proteins -c 8
busco -i longest_transcripts.fasta -l brassicales_odb10 -o maker_busco_output_transcript -m transcriptome -c 8
