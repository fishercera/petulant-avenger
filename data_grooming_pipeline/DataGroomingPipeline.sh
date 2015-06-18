#!/usr/bin/bash
#### Outline:
# Step zero: Run FASTQC from the command line and save the report
# ~/apps/FastQC/fastqc  <readfile.fastq.gz>
# fastqc seqfile1 seqfile2 .. seqfileN
# use like this:
#       fastqc seqfile1.fastq.gz ... -o fastqcFiles --noextract 

# Step One:  Trimmomatic with Illumina Clip - give trimmomatic the Illumina adapters fasta
# ILLUMINACLIP:<fastaWithAdaptersEtc>:<seed mismatches>:<palindrome clip threshold>:<simple clip threshold>:<minAdapterLength>:<keepBothReads>
# so usage will be:
# First clip first three bases off of beginning of R1
#        java -jar trimmomatic.jar PE -phred33 -trimlog lib.trimlog rawreadR1.fastq.gz rawreadR2.fastq.gz \
# trimmedPairedR1.fastq.gz trimmedUnpairedR1.fastq.gz trimmedPairedR2.fastq.gz trimmedUnpairedR2.fastq.gz ILLUMINACLIP:$HOME/QCPipeline/adapters.fasta:2:25:10:1:true LEADING:10 \
# TRAILING:10 SLIDINGWINDOW:4:20 CROP:220  MINLEN:75

fastqc -o FastQCBEFORE/ $READSDIR/ELJ$libR1.fastq.gz $READSDIR/ELJ$libR2.fastq.gz

java -jar trimmomatic/trimmomatic.jar SE -phred33 -trimlog headcrop.trimlog $READSDIR/ELJ1393R1.fastq.gz $READSDIR/ELJ1393R1_cropped.fastq.gz HEADCROP:5

java -jar trimmomatic/trimmomatic.jar SE -phred33 -trimlog headcrop.trimlog $READSDIR/ELJ1387R1.fastq.gz O$READSDIR/ELJ1387R1_cropped.fastq.gz HEADCROP:5

java -jar trimmomatic/trimmomatic.jar PE -phred33 -trimlog lib.trimlog $READSDIR/ELJ1393R1.fastq.gz $READSDIR/ELJ1393R2.fastq.gz Output/1393_P1.fastq.gz Output/1393_U1.fastq.gz Output/1393_P2.fastq.gz Output/1393_U2.fastq.gz ILLUMINACLIP:adapters1.fasta:2:25:10:1:true LEADING:10 TRAILING:10 SLIDINGWINDOW:4:20 CROP:222  MINLEN:75




# Results in four files: two paired-end paired reads, and one left read unpaired, one right read unpaired 
# This will merge any read-through reads, but will keep both pairs so that bowtie2 doesn't freak out
# step two: bowtie2 to remove contaminants -- make an index using hg19, s.cerevisae, drosophila, and another for amphibian RNA
# run bowtie2 on the trimmed/adapter removed reads
# step three: SeqPrep just to merge any reads that can be merged after all this quality trimming - results in one extra file
# Step four: FASTQC from command line again

# Brian Bushnell's recommendation (though he recommends using BBMap/BBTools, his Java implementation of kmer-based aligning
#1. Initial quality control
#2. Quality and/or length-based reads discarding; trimming/discarding of N-containing reads
#3. Adapter removal
#4. phix/contaminant removal
#5. [optional] Error-correction
#6. [optional] Deduplication (depending on experiment)
#7. Merging of PE reads
#8. Quality trimming + phix/contaminant removal
#9. Contamination check
