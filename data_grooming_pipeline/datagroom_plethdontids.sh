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
my_dir="$(dirname "$0")"
echo "$my_dir"

source $my_dir/datagroom_funcs.sh
#Functions are: cropR1 (crops Clontech libraries); dropTiny (drops all the reads less than 36 bp); qualtrimPE (trimmomatic with Illumina clip); qualtrimSE; sp (runs SeqPrep)
# And fastqcBEFORE and fastqcAFTER which do what they say on the tin


#################### Script Starts Here ####################

# Both unnecessary for our Nextera libs
# echo "trying cropR1 $library"
# cropR1 $library $TRIMPATH
# 
# echo "trying dropTiny"
# dropTiny $library $TRIMPATH

echo "trying qualtrimPE $library"
#  echo "qualtrimPE - WORKS"
qualtrimPE $library $TRIMPATH

qualtrimSE $library $TRIMPATH

concatenateUnpaired $library

echo "Post trimmomatic cleanup done. Time to run bowtie2."
# echo "Everything works up to this point!" 
echo "---- Unzipping the R1 and R2 files!"
gunzip input/$library.R*.fastq.gz


# bash ~/scripts/data_grooming_pipeline/bowtie2_func.sh $library bt2 amphibia.rRNA

echo "To run bowtie2: ~/scripts/data_grooming_pipeline/bowtie2_func.sh $library bt2 <indices>"

bash $my_dir/bowtie2_func.sh $library $INDEXPATH amphibia.rRNA dmelan hg19

A=GATCGGAAGAGCACACG
B=AGATCGGAAGAGCGTCGT

sp $library $A $B

fastqcAFTER $library

######### Let's Cleanup #########
rm -rf input/scratch/*



# This is all working up to this point!! 
# TODO -- Add SeqPrep. Use getsubstrings to double check to figure out what adapter we should tell SeqPrep about. 
# TODO -- add full cleanup -- remove everything from scratch and from input. 
# TODO -- Add a few lines to move raw reads from their resident directory, rename them appropriately.
# THEN -- run again on 11snp and IF IT ALL WORKS... 
# Set up a script to run this consecutively on each library.



