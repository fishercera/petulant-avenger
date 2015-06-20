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