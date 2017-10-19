# petulant-avenger
Repository for my RNASeq scripts

repo name suggested by github, was too good to not use. 

=====
data grooming pipeline

SPECS: 
  - input: fastq.gz -- gzipped fastq files (raw reads!!)
  - filenames: should rename to <lib-base-name>.R1/2.fastq.gz
  - output: <lib-base-name>\_Trimmed.R(1/2).fastq.gz 
	    <lib-base-name>\_BEFORE.fastqc (QC report)
            <lib-base-name>\_AFTER.fastqc (QC report post trimming)


TODO: 
  - cleanup divergence between "pleths" data grooming and "bugs" data grooming; 
  - add in functions to test for adapter/flowcell contamination and report it prior to trimming

=====
assembly pipeline

Tools used: trinityRNAseq de novo assembler by Brian Haas et al., plus a custom assembly stats script that provides more information than the TrinityStats.pl script.
This part of the script is just a wrapper for Trinity, which hardly needs it, but does provide immediate assembly stats as part of the output. 

SPECS:
  - input: Trimmed fastq.gz files (output from data grooming pipeline)
  - script needs to know insert size and whether data is paired end or single end
  - filenames: <lib-base-name>\_Trimmed.R(1/2).fastq.gz
  - output: Your assembly! Plus stats about contig length, average #isoforms per contig, nucleotide percentage, etc. 

TODO: 
  - Finish implementing the stats script. 

=====
analysis pipeline

**Under construction**

_Transcript quantification_ 
SPECS: 
  - input: Assembly and trimmed reads
  - output: BAM file of aligned reads, counts matrix, and TPM matrix. 

TODO:
  - build wrapper to make this easy to call given a library base name. 

_Further analysis steps_

TBD
 
