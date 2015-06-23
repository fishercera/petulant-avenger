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
lib=$1 # The library base, ie ELJ1393
index=$2 # The index base, ie Greg_rRNA
indexPath=$3 # The path to the index, ie ~/mini/bt2

echo "Starting bowtie2 with parameters $lib, $index, $indexPath"

bowtie2 -q --phred33 --mm --no-mixed --very-fast -k 1 -I 250 -X 1000 --dovetail --met-file bowtie2Metrics-$index.out --un-conc \
      input/scratch/$lib$index.P%.filtered.fastq --al-conc input/scratch/$lib$index.P%.contams.fastq -x $indexPath/$index -1 \
      input/$lib.R1.fastq -2 input/$lib.R2.fastq -S $lib.paired.$index.sam 
#       touch input/scratch/$lib$index.P1.filtered.fastq
#       touch input/scratch/$lib$index.P2.filtered.fastq
#       touch input/scratch/$lib$index.P1.contams.fastq
#       touch input/scratch/$lib$index.P2.contams.fastq
      mv input/$lib.R1.fastq input/scratch/$lib.R1.fastq_pre
      mv input/$lib.R2.fastq input/scratch/$lib.R2.fastq_pre
      mv input/scratch/$lib$index.P1.filtered.fastq input/$lib.R1.fastq
      mv input/scratch/$lib$index.P2.filtered.fastq input/$lib.R2.fastq

# These lines will ensure that the next run through this is going to use the filtered files, and we'll keep filtering stuff out. 
# This seems to be ready to go.. need to just uncomment it and try it out with th genomes I've got on minidrive

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
lib=$libbase
for i in $indices

do
  echo $i
  echo "----"
  filterContamsPE $lib $i $indexPath 
#   filterContamsSE $lib $i $indexPath 
  echo "-----"
  echo $lib 
done



# filterContamsPE $libbase $index $indexPath
# filterContamsSE $libbase $index $indexPath

