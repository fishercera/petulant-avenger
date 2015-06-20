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

fastqc -o output/fastqcBEFORE input/$lib.*.fastq.gz
}

# USAGE: fastqc <lib-base-name> 
# function fastqcAFTER {
# 
# fastqc -o output/fastqcAFTER $lib.*.fastq.gz
# }
function fastqcAFTER {
  echo "Running fastqc on $lib files"
  
  fastqc -o output/fastqcAFTER output/$lib.*.fastq.gz
}