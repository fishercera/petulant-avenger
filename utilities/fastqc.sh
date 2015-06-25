#$ -cwd
#$ -S /bin/bash
#$ -o fastqcout.txt
#$ -e fastqcerr.txt
#$ -m besa
#$ -M cera.fishera@uconn.edu
#$ -N fastqcBEFORE

# This is just comment - you can change the above so that -M is whatever email address you want a notification of 
# the job being done sent to. 
# The -N is the "name" of the job, and -o and -e just specify output files and error files that the command will write to. 

# Enter your commands below -- the command you were submitting without the "qsub" beginning
# Run this script by typing at the prompt: qsub fastqc.sh 

fastqc --noextract -o /scratch/crfisher/PEData/fastqcReports/ /scratch/crfisher/PEData/*.fastq.gz
