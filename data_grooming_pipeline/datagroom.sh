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

#!/usr/bin/basgh
# Functions for trimmomatic steps of data pipeline

# Removes first five bases from read 1, because they are from the ClontechSmarterOligo
# Only necessary for Clontech libs
# USAGE: cropR1 <lib-base> <path-to-trimmomatic>
# function cropR1 {
# java -jar $wheretrim/trimmomatic.jar SE -phred33 -trimlog headcrop.trimlog $lib.R1.fastq.gz $lib.R1crped.fastq.gz HEADCROP:5 > $lib.crp.log 
#}
function cropR1 {
  lib = $1
  wheretrim = $2

  echo "Performing clontech crop on $lib.R1.fastq.gz"
  
  java -jar $wheretrim/trimmomatic.jar SE -phred33 -trimlog headcrop.trimlog $lib.R1.fastq.gz $lib.R1crped.fastq.gz HEADCROP:5 > $lib.crp.log
}

# Drop the very short reads that (in clontech libs) are all NNN
# USAGE: dropTiny <lib-base> <path-to-trimmomatic> 
# function dropTiny {
# lib = $1
# wheretrim = $2
# java -jar trimmomatic/trimmomatic.jar PE -phred33 -trimlog lib.trimlog $lib.R1crped.fastq.gz $lib.R2.fastq.gz output/$lib.P1.step2.fastq.gz output/$lib.U1.step2.fastq.gz output/$lib.P2.step2.fastq.gz output/$lib.U2.step2.fastq.gz MINLEN:36
# }
function dropTiny {
  lib = $1
  wheretrim = $2 
  
  echo "Dropping tiny reads of $lib.R1crped.fastq.gz and $lib.R2.fastq.gz"
  
  java -jar $wheretrim/trimmomatic.jar PE -phred33 -trimlog $lib.trimlog $lib.R1crped.fastq.gz $lib.R2.fastq.gz output/$lib.P1.step2.fastq.gz output/$lib.U1.step2.fastq.gz output/$lib.P2.step2.fastq.gz output/$lib.U2.step2.fastq.gz MINLEN:36 > $lib.step2.log
}

# Full trimming with adapter removal
# Takes place in two steps - Paired end and SE from dropTiny
# Essentially just need a qualtrimPE and qualtrimSE function 
# qualtrimPE
# USAGE: qualtrimPE <lib-base> <path-to-trimmomatic>
# function qualtrimPE {
# lib = $1
# wheretrim = $2

# java -jar $wheretrim/trimmomatic.jar PE -phred33 -trimlog $lib.trimlog $lib.P1.step2.fastq.gz $lib.P2.step2.fastq.gz output/$lib.P1.step3.fastq.gz output/$lib.U1.step3.fastq.gz output/$lib.P2.step3.fastq.gz output/$lib.U2.step3.fastq.gz ILLUMINACLIP:adapters1.fasta:2:25:10:1:true LEADING:10 TRAILING:10 SLIDINGWINDOW:4:20 CROP:222  MINLEN:75


# }
function qualtrimPE {
lib = $1
wheretrim = $2

echo "Performing paired end quality trimming on $lib.P1.step2.fastq.gz and $lib.P2.step2.fastq.gz" 

java -jar $wheretrim/trimmomatic.jar PE -phred33 -trimlog $lib.trimlog $lib.P1.step2.fastq.gz $lib.P2.step2.fastq.gz output/$lib.P1.step3.fastq.gz output/$lib.U1.step3.fastq.gz output/$lib.P2.step3.fastq.gz output/$lib.U2.step3.fastq.gz ILLUMINACLIP:adapters1.fasta:2:25:10:1:true LEADING:10 TRAILING:10 SLIDINGWINDOW:4:20 CROP:222 MINLEN:75 >  $lib.step3.log

}


# qualtrimSE We have some unpaired files from the step2 that we need to take care of separately. 
# USAGE: qualtrimSE <lib.U1/2> <path-to-trimmomatic>
# function qualtrimSE {
# lib = $1
# wheretrim = $2
# java -jar $wheretrim/trimmomatic.jar SE -phred33 -trimlog $lib.trimlog $lib.step2.fastq.gz $lib.step3a.fastq.gz ILLUMINACLIP:adapters1.fasta:2:25:10:1:true LEADING:10 TRAILING:10 SLIDINGWINDOW:4:20 CROP:222 MINLEN:75
# }
function qualtrimSE {
  lib = $1
  wheretrim = $2
  
  echo "Single end quality trim on $lib.step2.fastq.gz"
  
  java -jar $wheretrim/trimmomatic.jar SE -phred33 -trimlog $lib.trimlog $lib.step2.fastq.gz $lib.step3a.fastq.gz ILLUMINACLIP:adapters1.fasta:2:25:10:1:true LEADING:10 TRAILING:10 SLIDINGWINDOW:4:20 CROP:222 MINLEN:75 > $lib.step3a.log
}
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


#SeqPrep -f $lib.P1.filtered.fastq -r $lib.P2.filtered.fastq -1 $lib.P1.SP.fastq -2 $lib.P2.SP.fastq -s $lib.merged.SP.fastq -g -E $lib.alignments.fasta -A -B 
#USAGE: sp <lib-base-name>
#function sp {
# lib = $1
# 
# SeqPrep -f $lib.P1.filtered.fastq -r $lib.P2.filtered.fastq -1 $lib.P1.SP.fastq -2 $lib.P2.SP.fastq -s $lib.merged.SP.fastq -g -E $lib.alignments.fasta -A -B 
#}
# TODO: add functionality to accept adapter strings
function sp {
  lib = $1
  
  echo "Performing SeqPrep on $lib.P1.filtered.fastq and $lib.P2.filtered.fastq"
  
  SeqPrep -f $lib.P1.filtered.fastq -r $lib.P2.filtered.fastq -1 $lib.P1.SP.fastq -2 $lib.P2.SP.fastq -s $lib.merged.SP.fastq -g -E $lib.alignments.fasta -A -B > $lib.sp.log
  cat $lib.sp.log
  
}
