#!/bin/bash
#SBATCH --mail-type=END
#SBATCH --mail-user=cera.fisher@uconn.edu
#SBATCH -n 4
#SBATCH -e 2029.log
#SBATCH -o 2029_out.log
#SBATCH -J 2029
#SBATCH -p Westmere

Trinity --JM 40G --seqType fq --left 2029_left.fastq --right 2029_right.fastq --CPU 4 --full_cleanup --output Out/

