#!/usr/bin/bash
# (c) Cera Fisher 2015
# data grooming pipeline for my NGS RNA-Seq libraries
# USAGE: Must hand this script the basename for the library. 
# This script expects:
# - The raw reads to be named <library-base>.R1/2.fastq.gz and to be gzipped
# - To be run from the parent directory of a tree with the following structure:
# parent:
#     >input :: Where the raw read files are located
#          >scratch :: A place for temporary files as they are being processed
#     >output
#          >fastqcBEFORE :: where fastqc puts its files pre-processing
#          >fastqcAFTER :: Where fastqc puts its files after post-processing
#	   >reads :: Where the final processed files go
#     >bt2 -- where the bowtie2 indices are, OR symbolic links to those indices!! 

################## SCRIPT OPTIONS #################
library=$1 #Pass the lib-base-name into the script
TRIMPATH=$2 #Pass the location of trimmomatic.jar to the script

#################### FUNCTIONS ####################

	  # Removes first five bases from read 1, because they are from the ClontechSmarterOligo
	  # Only necessary for Clontech libs
  # USAGE: cropR1 <lib-base> <path-to-trimmomatic>
  # /home/cera/apps/trimmomatic
function cropR1 {
  lib=$1
  wheretrim=$2

  echo "Performing clontech crop on $lib.R1.fastq.gz"
  echo $wheretrim
  
  java -jar $wheretrim/trimmomatic.jar SE -phred33 -trimlog headcrop.trimlog $lib.R1.fastq.gz $lib.R1crped.fastq.gz HEADCROP:5 > $lib.crp.log
  cp $lib.R1.fastq.gz $lib.R1.fastq.gz_ORIG
  mv $lib.R1crped.fastq.gz $lib.R1.fastq.gz
}

	  # Drop the very short reads that (in clontech libs) are all NNN
  # USAGE: dropTiny <lib-base> <path-to-trimmomatic> 
function dropTiny {
  lib=$1
  wheretrim=$2 
  
  echo "Dropping tiny reads of $lib.R1.fastq.gz and $lib.R2.fastq.gz"
  
  java -jar $wheretrim/trimmomatic.jar PE -phred33 -trimlog $lib.trimlog input/$lib.R1.fastq.gz input/$lib.R2.fastq.gz input/scratch/$lib.P1.step2.fastq.gz scratch/$lib.U1.step2.fastq.gz scratch/$lib.P2.step2.fastq.gz scratch/$lib.U2.step2.fastq.gz MINLEN:36 
  mv input/scratch/$lib.P1.step2.fastq.gz input/$lib.R1.fastq.gz
  mv input/scratch/$lib.P2.step2.fastq.gz input/$lib.R2.fastq.gz
  
  }


	  # Full trimming with adapter removal
	  # Takes place in two steps - Paired end and SE from dropTiny
  # USAGE: qualtrimPE <lib-base> <path-to-trimmomatic>
function qualtrimPE {
  lib=$1
  wheretrim=$2
  
  echo "Performing paired end quality trimming on $lib.P1.step2.fastq.gz and $lib.P2.step2.fastq.gz" 
  echo "\
  java -jar $wheretrim/trimmomatic.jar PE -phred33 -trimlog $lib.trimlog input/$lib.R1.fastq.gz input/$lib.R2.fastq.gz input/scratch/$lib.P1.fastq.gz \
  input/scratch/$lib.U1.fastq.gz input/scratch/$lib.P2.fastq.gz input/scratch/$lib.U2.fastq.gz ILLUMINACLIP:$wheretrim/adapters/TruSeq3-PE.fa:2:30:10 LEADING:10 \
  TRAILING:10 SLIDINGWINDOW:4:20 MINLEN:65 \
  "
  
  touch qualtrimPE.done
}



	  # qualtrimSE We have some unpaired files from the step2 that we need to take care of separately. 
  # USAGE: qualtrimSE <lib.U1/2> <path-to-trimmomatic>
function qualtrimSE {
  lib=$1
  wheretrim=$2
  
  echo "Single end quality trim on $lib.step2.fastq.gz"
  
  java -jar $wheretrim/trimmomatic.jar SE -phred33 -trimlog $lib.trimlog scratch/$lib.step2.fastq.gz scratch/$lib.step3a.fastq.gz ILLUMINACLIP:$wheretrim/adapters/TruSeq3-SE.fa:2:30:10 LEADING:10 TRAILING:10 SLIDINGWINDOW:4:20 MINLEN:65 > $lib.step3a.log
  cat $lib.step3a.log
}

	  # Run before snapshot of data quality
  # USAGE: fastqcB4 $lib 
function fastqcB4 {
  lib=$1
  echo "Running prelim fastqc on $lib.*.fastq.gz"

  fastqc -o output/fastqcBEFORE input/$lib.*.fastq.gz
}

	  # Run after snapshot of data quality
	  # Should be run from output directory
  # USAGE: fastqc <lib-base-name> 
function fastqcAFTER {
  lib=$1
  echo "Running fastqc on $lib files"
  
  fastqc -o output/fastqcAFTER output/$lib.*.fastq.gz
}


	  # SeqPrep to merge the reads that can be merged and do one more round of adapter filtering
	  # TODO: add functionality to accept adapter strings
  #USAGE: sp <lib-base-name>
function sp {
  lib=$1
  A=$2 # Adapter 1 - forward! for CLontech reads: GTGTAGATCTCGGTGGTCGC
  B=$3 # Adapter 2 - reverse complement! For Clontech reads: GTGTAGATCTCGGTGGTCGC
  echo "Performing SeqPrep on $lib.P1.filtered.fastq and $lib.P2.filtered.fastq"
  
  SeqPrep -f input/scratch/$lib.P1.filtered.fastq -r input/scratch/$lib.P2.filtered.fastq -1 output/$lib.P1.SP.fastq.gz -2 output/$lib.P2.SP.fastq.gz -s output/$lib.merged.SP.fastq.gz -A $A -B $B -E output/$lib.alignments.fasta    
  
}


#################### Script Starts Here ####################


echo "trying qualtrimPE $library"
#  echo "qualtrimPE - WORKS"
qualtrimPE "$library" $TRIMPATH

  echo "Post trimmomatic cleanup done. Time to run bowtie2."
# echo "Everything works up to this point!" 
echo "---- Unzipping the R1 and R2 files!"
gunzip $library.R*.fastq.gz

# bash ~/scripts/data_grooming_pipeline/bowtie2_func.sh $library bt2 amphibia.rRNA

echo "To run bowtie2: ~/scripts/data_grooming_pipeline/bowtie2_func.sh $library bt2 <indices>"


