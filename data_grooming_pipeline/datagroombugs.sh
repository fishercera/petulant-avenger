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
INDEXPATH=$3 #Pass the location of the indices to the script

#################### FUNCTIONS ####################
# Remember when we were trying to not have to have the functions in the same file as the script?
 my_dir="$(dirname "$0")"
 echo "$my_dir"
# 
# source $my_dir/datagroom_funcs.sh

#################### FUNCTIONS ####################

	  # Removes first five bases from read 1, because they are from the ClontechSmarterOligo
	  # Only necessary for Clontech libs
  # USAGE: cropR1 <lib-base> <path-to-trimmomatic>
  # /home/cera/apps/trimmomatic


	  # Full trimming with adapter removal
	  # Takes place in two steps - Paired end and SE from dropTiny
  # USAGE: qualtrimPE <lib-base> <path-to-trimmomatic>
function qualtrimPE {
  lib=$1
  wheretrim=$2
  
  echo "Performing paired end quality trimming on $lib.R1.fastq.gz and $lib.R2.fastq.gz" 
  
  java -jar $wheretrim/trimmomatic.jar PE -phred33 -trimlog $lib.trimlog input/$lib.R1.fastq.gz input/$lib.R2.fastq.gz input/scratch/$lib.P1.trimmed.fastq.gz input/scratch/$lib.U1.step3.fastq.gz input/scratch/$lib.P2.trimmed.fastq.gz input/scratch/$lib.U2.step3.fastq.gz ILLUMINACLIP:$wheretrim/adapters/Illumina.fa:2:30:10 LEADING:10 TRAILING:10 SLIDINGWINDOW:4:15 MINLEN:40 
  
  mv input/$lib.R1.fastq.gz input/scratch/$lib.R1.fastq.gz_preTrim
  mv input/$lib.R2.fastq.gz input/scratch/$lib.R2.fastq.gz_preTrim
  mv input/scratch/$lib.P1.trimmed.fastq.gz input/$lib.R1.fastq.gz
  mv input/scratch/$lib.P2.trimmed.fastq.gz input/$lib.R2.fastq.gz
 
  
}


	  # qualtrimSE We have some unpaired files from the step2 that we need to take care of separately. 
  # USAGE: qualtrimSE <lib.U1/2> <path-to-trimmomatic>
function qualtrimSE {
  lib=$1
  wheretrim=$2
  
  echo "Single end quality trim on $lib.step2.fastq.gz"
  
  java -jar $wheretrim/trimmomatic.jar SE -phred33 -trimlog $lib.trimlog input/scratch/$lib.U1.step2.fastq.gz input/scratch/$lib.U1.step2.trimmed.fastq.gz ILLUMINACLIP:$wheretrim/adapters/Illumina.fa:2:30:10 LEADING:10 TRAILING:10 SLIDINGWINDOW:4:15 MINLEN:60 

  java -jar $wheretrim/trimmomatic.jar SE -phred33 -trimlog $lib.trimlog input/scratch/$lib.U2.step2.fastq.gz input/scratch/$lib.U2.step2.trimmed.fastq.gz ILLUMINACLIP:$wheretrim/adapters/Illumina.fa:2:30:10 LEADING:10 TRAILING:10 SLIDINGWINDOW:4:15 MINLEN:60 
  
}

      #concatenateUnpaired cleans up the multiple U1/2 trimmed files that trimmomatic may have produced. 
function concatenateUnpaired {
  lib=$1
# Catting all unpaired reads to one unpaired.trimmed file, because bowtie will output them that way anyway, 
# and because they'll all have to go into trinity as singletons. 
# They CAN be separated out again with a fairly simple 
# Perl script that looks at the /1 or /2 at the end of the read name. 
  gunzip input/scratch/$lib.U1.step2.trimmed.fastq.gz
  gunzip input/scratch/$lib.U2.step2.trimmed.fastq.gz
  gunzip input/scratch/$lib.U1.step3.fastq.gz
  gunzip input/scratch/$lib.U2.step3.fastq.gz
  cat input/scratch/$lib.U1.step2.trimmed.fastq input/scratch/$lib.U1.step3.fastq input/scratch/$lib.U2.step2.trimmed.fastq input/scratch/$lib.U2.step3.fastq > input/$lib.U.trimmed.fastq # Just one file from the unpaired reads. 
  echo "ls input/$lib.U.trimmed.fastq"
  ls input/$lib.U.trimmed.fastq
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
  
  SeqPrep -f input/$lib.R1.filtered.fastq -r input/$lib.R2.filtered.fastq -1 output/$lib.P1.SP.fastq.gz -2 output/$lib.P2.SP.fastq.gz -s output/$lib.merged.SP.fastq.gz -A $A -B $B -E output/$lib.alignments.fasta    
 touch SeqPrep.done 
}


#Functions are: cropR1 (crops Clontech libraries); dropTiny (drops all the reads less than 36 bp); qualtrimPE (trimmomatic with Illumina clip); qualtrimSE; sp (runs SeqPrep)
# And fastqcBEFORE and fastqcAFTER which do what they say on the tin


#################### Script Starts Here ####################


echo "trying qualtrimPE $library"
#  echo "qualtrimPE - WORKS"
qualtrimPE $library $TRIMPATH

# qualtrimSE $library $TRIMPATH

concatenateUnpaired $library

echo "Post trimmomatic cleanup done. Time to run bowtie2."
# echo "Everything works up to this point!" 
echo "---- Unzipping the R1 and R2 files!"
gunzip input/$library.R*.fastq.gz


# bash ~/scripts/data_grooming_pipeline/bowtie2_func.sh $library bt2 amphibia.rRNA

echo "To run bowtie2: ~/scripts/data_grooming_pipeline/bowtie2_func.sh $library bt2 <indices>"
echo "#bash $my_dir/bowtie2_func.sh $library $INDEXPATH e_coli scerev hg19"
echo "Then try running cutadapt or SeqPrep"

# A=forwardadapter
# B=reverseadapter
# 
# sp $library $A $B

fastqcAFTER $library

######### Let's Cleanup #########
# rm -rf input/scratch/*



# This is all working up to this point!! 
# TODO -- Add SeqPrep. Use getsubstrings to double check to figure out what adapter we should tell SeqPrep about. 
# TODO -- add full cleanup -- remove everything from scratch and from input. 
# TODO -- Add a few lines to move raw reads from their resident directory, rename them appropriately.
# THEN -- run again on 11snp and IF IT ALL WORKS... 
# Set up a script to run this consecutively on each library.



