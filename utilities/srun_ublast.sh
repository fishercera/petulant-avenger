#!/bin/bash -l
# NOTE the -l flag!

# If you need any help, please email help@cse.ucdavis.edu

# Name of the job - You'll probably want to customize this.
#SBATCH -J bench

# Standard out and Standard Error output files with the job number in the name.
#SBATCH -o bench-%j.out
#SBATCH -e bench-%j.err
#SBATCH -partition=bigmem
#SBATCH -mail-user=cera.fisher@uconn.edu
# no -n here, the user is expected to provide that on the command line.

# The useful part of your job goes below

# run one thread for each one the user asks the queue for
# hostname is just for debugging
hostname

#ublast nr db
srun -o ublast_nr.out -e ublast_nr.err -s -n 24 usearch -ublast Trin65-031514.fasta -strand both -db /share/nealedata/databases/udb/nr.udb -evalue 1e9 -weak_evalue 0.01 -maxaccepts 10 -top_hits_only -blast6out results.out -threads 24


#ublast refseq db
srun -o ublast_refseq.out -e ublast_refseq.err -s -n 24 usearch -ublast Trin65-031514.fasta -strand both -db share/nealedata/databases/udb/refseq_protein.udb -evalue 1e9 -weak_evalue 0.01 -maxaccepts 10 -top_hits_only -blast6out results.out -threads 24

#ublast full length refseq
srun -o ublast_full.out -e ublast_full.err -s -n 24 usearch -ublast Trin65-031514.fasta -strand both -db /share/nealedata/databases/udb/refseq_protein.full.udb -evalue 1e9 -weak_evalue 0.01 -maxaccepts 10 -top_hits_only -blast6out results.out -threads 24
