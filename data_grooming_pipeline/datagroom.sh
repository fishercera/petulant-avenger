#!/usr/bin/bash
# (c) Cera Fisher 2015
# data grooming pipeline for my NGS RNA-Seq libraries


#################### FUNCTIONS ####################
	    # This function filters out the contaminants from 
	    # quality trimmed reads. 
  # USAGE: filterContams <lib-base-name> <index-name> <path/to/index>
  
  library=$1
  
function filterContamsPE {
  lib=$1
  index=$2
  indexPath=$3

  echo "Starting bowtie2 with parameters $lib, $index, $indexPath"

  bowtie2 -q --phred33 --mm --very-fast -k 1 -I 250 -X 1000 --dovetail --met-file bowtie2Metrics-rRNA.out --un input/scratch/$lib.Unpaired.filtered.fastq --al input/scratch/$lib.Unpaired.contams.fastq --un-conc input/scratch/$lib.P%.filtered.fastq --al-conc input/scratch/$lib.P%.contams.fastq -x $indexPath/$index -1 input/scratch/$lib.P1.step3.fastq -2 input/scratch/$lib.P2.step3.fastq -S input/scratch/$lib.paired.$index.sam > $lib.$index.log

  cat $lib.$index.log

}

	    # This function filters out the contaminants from 
	    # quality trimmed reads.
  #USAGE: filterContamsSE <lib-base-name> <index-name> <path/to/index>
function filterContamsSE {
  lib=$1
  index=$2
  indexPath=$3

  echo "Starting bowtie2 with parameters $lib, $index, $indexPath"

  bowtie2 -q --phred33 --mm --very-fast -k 1 -I 250 -X 1000 --met-file bowtie2Metrics-rRNA.out --un input/scratch/$lib.filtered.fastq --al input/scratch/$lib.contams.fastq -U input/scratch/$lib.step3.fastq -x $indexPath/$index -S input/scratch/$lib.unpaired.$index.sam > $lib.$index.unpaired.log

  cat $lib.$index.log

}

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
  
  java -jar $wheretrim/trimmomatic.jar PE -phred33 -trimlog $lib.trimlog $lib.R1.fastq.gz $lib.R2.fastq.gz scratch/$lib.P1.step2.fastq.gz scratch/$lib.U1.step2.fastq.gz scratch/$lib.P2.step2.fastq.gz scratch/$lib.U2.step2.fastq.gz MINLEN:36 > $lib.step2.log
}


	  # Full trimming with adapter removal
	  # Takes place in two steps - Paired end and SE from dropTiny
  # USAGE: qualtrimPE <lib-base> <path-to-trimmomatic>
function qualtrimPE {
  lib=$1
  wheretrim=$2
  
  echo "Performing paired end quality trimming on $lib.P1.step2.fastq.gz and $lib.P2.step2.fastq.gz" 
  
  java -jar $wheretrim/trimmomatic.jar PE -phred33 -trimlog $lib.trimlog scratch/$lib.P1.step2.fastq.gz scratch/$lib.P2.step2.fastq.gz scratch/$lib.P1.step3.fastq.gz scratch/$lib.U1.step3.fastq.gz scratch/$lib.P2.step3.fastq.gz scratch/$lib.U2.step3.fastq.gz ILLUMINACLIP:$wheretrim/adapters/adapters1.fasta:2:25:10:1:true LEADING:10 TRAILING:10 SLIDINGWINDOW:4:20 CROP:222 MINLEN:75 >  $lib.step3.log
  cat $lib.step3.log
}


	  # qualtrimSE We have some unpaired files from the step2 that we need to take care of separately. 
  # USAGE: qualtrimSE <lib.U1/2> <path-to-trimmomatic>
function qualtrimSE {
  lib=$1
  wheretrim=$2
  
  echo "Single end quality trim on $lib.step2.fastq.gz"
  
  java -jar $wheretrim/trimmomatic.jar SE -phred33 -trimlog $lib.trimlog scratch/$lib.step2.fastq.gz scratch/$lib.step3a.fastq.gz LEADING:10 TRAILING:10 SLIDINGWINDOW:4:20 CROP:222 MINLEN:75 > $lib.step3a.log
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

echo "fastqcB4 $library - WORKS"

 fastqcB4 "$library"

echo "Changed working directory"
cd "input/"
pwd

echo "crop1 $library - WORKS"
cropR1 "$library" "/home/cera/apps/trimmomatic"

 echo "dropTiny - WORKS"
dropTiny "$library" "/home/cera/apps/trimmomatic"

 echo "qualtrimPE - WORKS"
 qualtrimPE "$library" "/home/cera/apps/trimmomatic"

#  USAGE: qualtrimSE <lib.U1/2> <path-to-trimmomatic>
 echo "qualtrimSE - WORKS"
qualtrimSE "$library.U1" "/home/cera/apps/trimmomatic" 
qualtrimSE "$library.U2" "/home/cera/apps/trimmomatic" 

gunzip scratch/$library.U1.step3*
gunzip scratch/$library.U2.step3*

cat scratch/$library.U1.step3* > scratch/$library.U1.step3b.fastq
 rm -f scratch/$library.U1.step3.fastq
rm -f scratch/$library.U1.step3a.fastq
 
 mv scratch/$library.U1.step3b.fastq scratch/$library.U1.step3.fastq

 cat scratch/$library.U2.step3* > scratch/$library.U2.step3b.fastq
 rm -f scratch/$library.U2.step3.fastq
 rm -f scratch/$library.U2.step3a.fastq
 
 mv scratch/$library.U2.step3b.fastq scratch/$library.U2.step3.fastq


 gzip scratch/$library.U*step3*
 rm -f scratch/$library.*step2*

 echo "Post trimmomatic cleanup done. Time to run bowtie2."
echo "Everything works up to this point!" 

# # cd ../
# pwd
# 
# gunzip input/scratch/*fastq.gz
# # filterContamsPE "$library" "Greg_rRNA" "bt2"
# echo "filterContamsPE works"
# # filterContamsSE "$library.U1" "Greg_rRNA" "bt2"
# echo "filterContamsSE WORKS"
# # filterContamsSE "$library.U2" "Greg_rRNA" "bt2"
# 
# echo "SeqPrep function WORKS"
# # sp "$library"
# 
# # gzip input/scratch/$library.U*.fastq
# # mv input/scratch/$library.U*.filtered.fastq.gz output/
# 
# # TODO test to see if there's a fastqcAFTER directory, if not make it
# 
# # fastqcAFTER "$library"
# 
# echo "rm -rf input/scratch/"
# echo "rm -rf input/*log"
# 
# # gunzip output/*.fastq.gz
# echo "Cleaning up read files"
# echo "cat output/$library.P1.SP.fastq output/$library.U1.filtered.fastq output/$library.merged.SP.fastq > output/$library.left.fastq"
# echo "cat output/$library.P2.SP.fastq output/$library.U2.filtered.fastq > output/$library.right.fastq"
# 
# # gzip output/$library.left.fastq output/$library.right.fastq
