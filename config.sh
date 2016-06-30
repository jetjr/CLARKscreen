#!/bin/bash

#Establish current working directory
export CWD=$PWD

#Directory where scripts are located
export SCRIPT_DIR="$CWD/scripts"

#Directory containing FASTA/FASTQ files contaminated with human reads
export FASTA_DIR="$CWD/fastq/fixed"

#Directory AND basename of Bowtie2 index files
export BT2_INDEX="$CWD/human-index/human_index"

#Directory to place UNMAPPED reads 
export BT2_OUT_DIR="$CWD/bt2_unmapped_reads"

#Directory where CLARK scripts
export CLARK_DIR="/rsgrps/bhurwitz/hurwitzlab/bin/CLARK"

#CLARK Database directory location AND name
export CLARK_DB="$CLARK_DIR/Database"

#CLARK Parameters
export KMER_SIZE="31"
export MODE="1"
export NUM_THREAD="8"

#Directory for CLARK results
export CLARK_OUT_DIR="$CWD/CLARK-workflow"

#Standard Error/Out Directory 
export STDERR_DIR="$CWD/std-err"
export STDOUT_DIR="$CWD/std-out"

