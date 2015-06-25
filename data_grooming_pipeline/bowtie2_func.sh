#!/usr/bin/bash

# This script runs libraries through the bowtie2 decontamination pathway. 
# USAGE: bowtie2_func.sh <lib-base-name> <path-to-indices> <List that is a name of indices>
# For example: bowtie2_func.sh ELJ1393 ~/mini/bt2 Greg_rRNA dmelan scerev



# filterContamsPE - this works on paired reads and filters out the pairs that align concordantly. We're being very generous
# with the definition of concordant, allowing dovetailed reads just in case we get readthrough. 
#USAGE: filterContamsPE <lib-base-name> <index> <index-path>
function filterContamsPE {
lib=$1 # The library base, ie ELJ1393
index=$2 # The index base, ie Greg_rRNA
indexPath=$3 # The path to the index, ie ~/mini/bt2

echo "Starting bowtie2 with parameters $lib, $index, $indexPath"

bowtie2 -q --phred33 --mm --sensitive -I 250 -X 1000 --dovetail --met-file bowtie2Metrics-$index.out --un input/scratch/$lib$index.U.filtered.fastq \
      --al input/scratch/$lib$index.U.contams.fastq --un-conc input/scratch/$lib$index.P%.filtered.fastq --al-conc input/scratch/$lib$index.P%.contams.fastq \
      -x $indexPath/$index -1 \
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
touch Pairedbowtie$index.done

}

# filterContams tinytest hg19 "/apps/bowtie2/1.0.0/indexes/hg19"
# Output of this function will be the output of the bowtie2 command

function filterContamsSE {
  lib=$1
  index=$2
  indexPath=$3
# Input files need to be in the form <lib-base-name>.U1/2.filtered.fastq 
  echo "Starting bowtie2 with parameters $pass, $index, $indexPath, $libbase"
echo "bowtie2 -q --phredd33 --mm --sensitive --met-file bowtie2SEMetrics-$index.out --un input/scratch/$lib$index.U1.filtered.fastq, input/scratch/$lib$index.U2.filtered.fastq \
    --al input/scratch/$lib$index.U1.contams.fastq, input/scratch/$lib$index.U2.contams.fastq -x $indexPath/$index -U input/scratch/$lib.U1.filtered.fastq, input/scratch/$lib.U2.filtered.fastq"

mv input/scratch/$lib$index.U1.filtered.fastq input/scratch/$lib.U1.filtered.fastq

mv input/scratch/$lib$index.U2.filtered.fastq input/scratch/$lib.U2.filtered.fastq

touch Unpairedbowtie$index.done



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

