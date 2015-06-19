#!/usr/bin/bash
#fastqc command function

# USAGE: fastqcB4 $lib 
# function fastqcB4 {
# lib=$1
# 
# fastqc -o output/fastqcBEFORE $lib.*.fastq.gz
# }
function fastqcB4 {
lib=$1
echo "Running fastqc on $lib.*.fastq.gz"

fastqc -o output/fastqcBEFORE $lib.*.fastq.gz
}