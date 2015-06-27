#!/bin/bash

#############################################################
##### TEMPLATE SGE SCRIPT - BLAST EXAMPLE ###################
#############################################################

# Specify the name of the data file to be used

LIB=$1

SCRIPTS="petulant-avenger"

# Name the directory (assumed to be a direct subdir of $HOME) from which the file
# listed in DATA_FILE is located and into which the output files will be deposited

PROJECT_SUBDIR="QCPipeline"
TRIMPATH="$HOME/bio/apps/trimmomatic"
INDEXPATH="bt2"

INPUTFILE1="$HOME/bio/QCPipeline/input/$lib.R1.fastq.gz"
INPUTFILE2="$HOME/bio/QCPipeline/input/$lib.R2.fastq.gz"

# Specify name to be used to identify this run
#$ -N QCReads

# Email address (change to yours)
#$ -M cera.fisher@uconn.edu

# Specify mailing options: b=beginning, e=end, s=suspended, n=never, a=abortion
#$ -m besa

# Specify that bash shell should be used to process this script
#$ -S /bin/bash

# To utilize multiple CPU on the same node (cd-hit clustering application)
#$ -pe smp 4

# Specify working directory (created on compute node used to do the work)
WORKING_DIR="/scratch/$USER/$PROJECT_SUBDIR"

# If working directory does not exist, create it
# The -p means "create parent directories as needed"
if [ ! -d "$WORKING_DIR" ]; then
mkdir -p $WORKING_DIR
fi

if [ ! -d "$WORKING_DIR/input/scratch" ]; then
mkdir -p $WORKING_DIR/input/scratch
fi

if [ ! -d "$WORKING_DIR/output/fastqcBEFORE" ]; then
mkdir -p $WORKING_DIR/output/fastqcBEFORE
fi

# Specify destination directory (this will be subdirectory of your home directory)
DESTINATION_DIR="$WORKING_DIR/output"

# If destination directory does not exist, create it
# The -p in mkdir means "create parent directories as needed"
if [ ! -d "$DESTINATION_DIR" ]; then
mkdir -p $DESTINATION_DIR
fi

cp $PROJECT_SUBDIR/$SCRIPTS/data_grooming_pipeline/datagroom_funcs.sh .
cp $PROJECT_SUBDIR/$SCRIPTS/data_grooming_pipeline/datagroom_plethodontids.sh .
cp $PROJECT_SUBDIR/$SCRIPTS/data_grooming_pipeline/bowtie2_funcs.sh .

# navigate to the working directory
cd $WORKING_DIR

# Get script and input data from home directory and copy to the working directory
cp $INPUTFILE1 input/.
cp $INPUTFILE2 input/.

cp $PROJECT_SUBDIR/$SCRIPTS/data_grooming_pipeline/datagroom_funcs.sh .
cp $PROJECT_SUBDIR/$SCRIPTS/data_grooming_pipeline/datagroom_plethodontids.sh .
cp $PROJECT_SUBDIR/$SCRIPTS/data_grooming_pipeline/bowtie2_funcs.sh .

# Specify the output file
#$ -o $JOB_ID.out

# Specify the error file
#$ -e $JOB_ID.err

#Run the program
bash datagroom_plethodontids.sh $LIB $TRIMPATH $INDEXPATH 

cd
# copy output files back to your home directory
cp * $DESTINATION_DIR $HOME/.


# clear scratch directory
#rm -rf $WORKING_DIR