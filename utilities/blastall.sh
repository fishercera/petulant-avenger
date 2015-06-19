#$ -cwd
#$ -S /bin/bash
#$ -o blastall-out.txt
#$ -e blastall-err.txt
#$ -m ea
#$ -M rafael.medina@uconn.edu
#$ -N blastall

# This is just comment - you can change the above so that -M is whatever email address you want a notification of 
# the job being done sent to. 
# The -N is the "name" of the job, and -o and -e just specify output files and error files that the command will write to. 

# Enter your commands below -- the command you were submitting without the "qsub" beginning
# Run this script by typing at the prompt: qsub blastall.sh 

tblastn -query LungProteinsDB.fasta -db Trin57-031114.fasta -evalue 1e-20 -num_threads 2 -out LungGenes_tBlastn_2057.out -outfmt '6 qseqid qframe sseqid sframe pident length mismatch gapopen qstart qend sstart send qlen slen evalue'
tblastn -query LungProteinsDB.fasta -db Trin57-031114.fasta -evalue 1e-20 -num_threads 2 -out LungGenes_tBlastn_2057.headers.out -outfmt '7 qseqid qframe sseqid sframe pident length mismatch gapopen qstart qend sstart send qlen slen evalue'
tblastn -query LungProteinsDB.fasta -db Trin65-031514.fasta -evalue 1e-20 -num_threads 2 -out LungGenes_tBlastn_2065.out -outfmt '6 qseqid qframe sseqid sframe pident length mismatch gapopen qstart qend sstart send qlen slen evalue'
tblastn -query LungProteinsDB.fasta -db Trin65-031514.fasta -evalue 1e-20 -num_threads 2 -out LungGenes_tBlastn_2065.headers.out -outfmt '7 qseqid qframe sseqid sframe pident length mismatch gapopen qstart qend sstart send qlen slen evalue'