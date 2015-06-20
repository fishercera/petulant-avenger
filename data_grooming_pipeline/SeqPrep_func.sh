#!/usr/bin/bash


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