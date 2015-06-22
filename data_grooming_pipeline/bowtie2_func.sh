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
pass=$1
index=$2
indexPath=$3
libbase=$4

echo "Starting bowtie2 with parameters $pass, $index, $indexPath, $libbase"

echo "bowtie2 -q --phred33 --mm --very-fast -k 1 -I 250 -X 1000 --dovetail --met-file bowtie2Metrics-$index.out --un $libbase$index.Unpaired.filtered.fastq --al $libbase$index.Unpaired.contams.fastq --un-conc $libbase$index.P%.filtered.fastq --al-conc $libbase$index.P%.contams.fastq -x $indexPath/$index -1 $pass.P1.filtered.fastq -2 $pass.P2.filtered.fastq -S $pass.paired.$index.sam "
echo "### The outputs become the inputs: "
echo "### $libbase$index.Unpaired.filtered.fastq and "
echo "### $libbase$index.P%.filtered.fastq ###"

}

# filterContams tinytest hg19 "/apps/bowtie2/1.0.0/indexes/hg19"
# Output of this function will be the output of the bowtie2 command

function filterContamsSE {
  pass=$1
  index=$2
  indexPath=$3
  libbase=$4

  echo "Starting bowtie2 with parameters $pass, $index, $indexPath, $libbase"

  echo "bowtie2 -q --phred33 --mm --very-fast -k 1 -I 250 -X 1000 --met-file bowtie2Metrics-rRNA.out --un input/scratch/$libbase$index.Unpaired.filtered.fastq --al input/scratch/$libbase$index.Unpaired.contams.fastq -U input/scratch/$pass.Unpaired.filtered.fastq -x $indexPath/$index -S input/scratch/$pass.unpaired.$index.sam" 



}

args="$@"
numargs=$#
echo $args
echo $numargs
echo "libbase = $1"
libbase=$1
shift
echo "indexPath = $1"
indexPath=$1
shift
echo "indices = $@"
indices=$@
echo $indices
pass=$libbase
for i in $indices

do
  echo $i
  echo "----"
  filterContamsPE $pass $i $indexPath $libbase
  filterContamsSE $pass $i $indexPath $libbase
  pass=$libbase$i
  echo "-----"
  echo $pass
done



# filterContamsPE $libbase $index $indexPath
# filterContamsSE $libbase $index $indexPath

