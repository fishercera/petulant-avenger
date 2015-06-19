#!/bin/bash -l
# NOTE the -l flag!

# If you need any help, please email help@cse.ucdavis.edu

# Name of the job - You'll probably want to customize this.
#SBATCH -J bench

# Standard out and Standard Error output files with the job number in the name.
#SBATCH -o bench-%j.out
#SBATCH -e bench-%j.err
#SBATCH -partition=bigmem

# no -n here, the user is expected to provide that on the command line.

# The useful part of your job goes below

# run one thread for each one the user asks the queue for
# hostname is just for debugging
hostname




----------------
#!/bin/bash -l
# NOTE the -l flag!
#
#SBATCH -J test
#SBATCH -o test.output
#SBATCH -e test.output
# Default in slurm
#SBATCH --mail-user username@domain.tld
#SBATCH --mail-type=ALL
# Request 5 hours run time
#SBATCH -t 5:0:0
#SBATCH -A your_project_id_here
#
#SBATCH -p node -n 16
# NOTE Each Kalkyl node has eight cores
#
 
module load pgi openmpi
 
mpirun <put your app here>