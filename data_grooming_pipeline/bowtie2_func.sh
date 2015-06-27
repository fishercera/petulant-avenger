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
      mv input/$lib.R1.fastq input/scratch/$lib.R1.fastq_pre$index
      mv input/$lib.R2.fastq input/scratch/$lib.R2.fastq_pre$index
      mv input/scratch/$lib$index.P1.filtered.fastq input/$lib.R1.fastq
      mv input/scratch/$lib$index.P2.filtered.fastq input/$lib.R2.fastq

# These lines will ensure that the next run through this is going to use the filtered files, and we'll keep filtering stuff out. 
# This seems to be ready to go.. need to just uncomment it and try it out with th genomes I've got on minidrive
touch Pairedbowtie$index.done

}

# filterContams tinytest hg19 "/apps/bowtie2/1.0.0/indexes/hg19"
# Output of this function will be the output of the bowtie2 command
# This is expecting its input files to be input/scratch/<libbase>.U1.fastq and <libbase>.U2.fastq
# TODO Is there a way to get paired end mode bowtie to output its unpaired reads into two files, one for each end
# NO, and there's no need to, EITHER. These are strand specific, and if you have unpaired reads you have lost your 
#pairing data anyway. These unpaired reads ALL go in as singletons. 

#So when we cat the unpaired reads... we should just go ahead and cat them to one file. 

#$lib.U.trimmed.fastq 

function filterContamsSE {
  lib=$1
  index=$2
  indexPath=$3
# Input files need to be in the form <lib-base-name>.U1/2.filtered.fastq 
  echo "Starting bowtie2 with parameters $lib, $index, $indexPath"
  cp input/$lib.U.trimmed.fastq input/scratch/$lib.U.filtered.fastq
  bowtie2 -q --phredd33 --p 4 --sensitive --met-file bowtie2SEMetrics-$index.out --un input/scratch/$lib$index.U.filtered.fastq --al input/scratch/$lib$index.U.contams.fastq -x $indexPath/$index -U input/scratch/$lib.U.filtered.fastq
  mv input/scratch/$lib$index.U.filtered.fastq input/scratch/$lib.U.filtered.fastq

  touch Unpairedbowtie$index.done
}

args="$@"
numargs=$#
echo $args
echo $numargs
echo "libbase = $1"
lib=$1
shift
echo "indexPath = $1"
indexPath=$1
shift
echo "indices = $@"
indices=$@
echo $indices


for i in $indices

do
  echo $i
  echo "----"
  filterContamsPE $lib $i $indexPath 
  echo "-----"
  echo $lib 
done

for i in $indices
do
  echo $i
  echo "-----"
  filterContamsSE $lib $i $indexPath
  echo "-----"
  echo $lib
done

