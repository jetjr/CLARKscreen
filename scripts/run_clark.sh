#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=4:mem=15gb
#PBS -l place=pack
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M jamesthornton@email.arizona.edu
#PBS -m bea

FILE_NAME=`basename $UNMAPPED | cut -d '.' -f 1`
BT2_OUT="$BT2_OUT_DIR/$UNMAPPED"

cd "$CLARK_DIR"
./classify_metagenome.sh -k $KMER_SIZE -O $BT2_OUT -R $CLARK_OUT_DIR/$FILE_NAME.results -m $MODE -n $NUM_THREAD

./estimate_abundance.sh -F $CLARK_OUT_DIR/$FILE_NAME.results.csv -D $CLARK_DB >> $CLARK_OUT_DIR/$FILE_NAME.abundance.csv  

