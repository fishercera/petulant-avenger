#!/usr/bin/bash

# This function filters out the contaminants from 
# quality trimmed reads. 

# USAGE: filterContams <lib-base-name> <index-name> <path/to/index>
# 
# function filterContams {
# lib=$1 
# index=$2
# indexPath=$3
# }
function filterContamsPE {
lib=$1
index=$2
indexPath=$3

echo "Starting bowtie2 with parameters $lib, $index, $indexPath"

bowtie2 -q --phred33 --mm --very-fast -k 1 -I 250 -X 1000 --dovetail --met-file bowtie2Metrics-rRNA.out --un $lib.Unpaired%.filtered.fastq --al $lib.Unpaired%.contams.fastq --un-conc $lib.P%.filtered.fastq --al-conc $lib.P%.contams.fastq -x $indexPath -1 $lib.P1.step3.fastq -2 $lib.P2.step3.fastq -S $lib.paired.$index.sam > $lib.$index.log

cat $lib.$index.log

}

# filterContams tinytest hg19 "/apps/bowtie2/1.0.0/indexes/hg19"
# Output of this function will be the output of the bowtie2 command

