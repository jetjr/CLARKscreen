#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=4:mem=15gb
#PBS -l pvmem=14gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M jamesthornton@email.arizona.edu
#PBS -m bea

set -u

source $CWD/functions.sh

module load bowtie2/2.2.5

TMP_FILES=$(mktemp)
get_lines $FASTA_LIST $TMP_FILES ${PBS_ARRAY_INDEX:-1} ${STEP_SIZE:-1}

i=0
while read FILE; do
  FILE_NAME=$(basename $FASTA | cut -d '.' -f 1)

  let i++
  printf "%3d: %s\n" $i $FILE_NAME

  bowtie2 -x $BT2_INDEX -U $FILE -f --very-sensitive-local -p 4 --un $BT2_OUT_DIR/$FILE_NAME.unmapped 
done < $TMP_FILES 

echo Done.
