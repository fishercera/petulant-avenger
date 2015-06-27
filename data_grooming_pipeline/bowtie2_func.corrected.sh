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
un=input/scratch/$lib$index.U.filtered.fastq
al=input/scratch/$lib$index.U.contams.fastq
unconc=input/scratch/$lib$index.P%.filtered.fastq
alconc=input/scratch/$lib$index.P%.contams.fastq
bowtie2 -q --phred33  -p 8 --very-sensitive  --dovetail --met-file bowtie2Metrics-$index.out --un $un --al $al --al-conc $alconc --un-conc $unconc -x $indexPath/$index -1 input/$lib.R1.fastq -2 input/$lib.R2.fastq -S deleteme$lib.paired.$index.sam 

      cp input/$lib.R1.fastq input/scratch/$lib.R1.fastq_pre$index
      cp input/$lib.R2.fastq input/scratch/$lib.R2.fastq_pre$index
      cp input/scratch/$lib$index.P1.filtered.fastq input/$lib.R1.fastq
      cp input/scratch/$lib$index.P2.filtered.fastq input/$lib.R2.fastq

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
  input=input/scratch/$lib.U.filtered.fastq
  al=input/scratch/$lib$index.U.contams.fastq
  un=input/scratch/$lib$index.U.filtered.fastq
# Input files need to be in the form <lib-base-name>.U1/2.filtered.fastq 
  echo "Starting bowtie2 with parameters $lib, $index, $indexPath"
  bowtie2 -q --phred33 -p 8 --very-sensitive --met-file bowtie2SEMetrics-$index.out --un $un --al $al -x $indexPath/$index -U $input -S deleteme$lib$index.SE.sam
  cp $un $input 

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

cp input/$lib.U.trimmed.fastq input/scratch/$lib.U.filtered.fastq
for i in $indices
do
  echo $i
  echo "-----"
  filterContamsSE $lib $i $indexPath
  echo "-----"
  echo $lib
done

cp input/scratch/$lib.U.filtered.fastq output/.
cp input/$lib.R1.fastq output/.
cp input/$lib.R2.fastq output/.

