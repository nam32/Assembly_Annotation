#!/usr/bin/env bash

# This script calculates the optimal k-mer size for genome analysis based on genome size 
# and a tolerable collision rate. It optionally supports evaluation on homopolymer-compressed genomes.
# The calculation is based on the method described by Fofanov et al., Bioinformatics (2004).
#
# Usage:
#   ./best_k.sh [-c] <genome_size> [tolerable_collision_rate]
#
# Arguments:
#   -c                      [OPTIONAL] Evaluate on a homopolymer-compressed genome. EXPERIMENTAL.
#   <genome_size>           Haploid or diploid genome size in base pairs (bp).
#   [tolerable_collision_rate] [OPTIONAL] Error rate in the read set. Default: 0.001 for Illumina WGS.
#
# Outputs:
#   - Prints the genome size, tolerable collision rate, and the calculated optimal k-mer size.
#
# Prerequisites:
#   - The script requires `awk` for calculations.
#
# Reference:
#   Fofanov et al., Bioinformatics (2004)

if [ -z $1 ]; then
  echo "Usage: ./best_k.sh [-c] <genome_size> [tolerable_collision_rate]"
  echo -e "  -c         : [OPTIONAL] evaluation will be on homopolymer compressed genome. EXPERIMENTAL"
  echo -e "  genome_size: Haploid genome size or diploid genome size, depending on what we evaluate. In bp."
  echo -e "  tolerable_collision_rate: [OPTIONAL] Error rate in the read set. DEFAULT=0.001 for illumina WGS"
  echo -e "See Fofanov et al. Bioinformatics, 2004 for more details."
  echo
  exit -1
fi

if [ "x$1" = "x-c" ]; then
  compress="1"
  shift
fi

if [ ! -z $2 ]; then
	e=$2
else
	e=0.001
fi

g=$1

echo "genome: $g"
echo "tolerable collision rate: $e"
if [[ -z $compress ]]; then
  n=4;
else
  n=3;
fi
k=`echo $g $e | awk '{print $1"\t"(1-$2)/$2}' | awk -v n=$n '{print log($1*$2)/log(n)}'`
echo $k
