#!/bin/sh

source ./config.sh
source ./functions.sh

if [[ ! -d "$FASTA_DIR" ]]; then
    echo "$FASTA_DIR does not exist. Directory created, but make sure FASTA files are there before you continue. Job terminated."
    mkdir -p "$FASTA_DIR"
    exit 1
fi

if [[ ! -d "$CLARK_DIR" ]]; then
    echo "$CLARK_DIR does not exist. You must declare where CLARK scripts are located. Edit config.sh file before you continue. Job terminated."
    exit 1
fi

if [[ ! -d "$CLARK_DB" ]]; then
    echo "$CLARK_DB does not exist. You must declare where the CLARK database is  located. Edit config.sh file before you continue. Job terminated."
    exit 1
fi

if [[ ! -d "$BT2_INDEX" ]]; then
    echo "$BT2_INDEX does not exist. You must declare where the Bowtie2 index files are located. Edit config.sh file before you continue. Job terminated."
    exit 1
fi

if [[ ! -d "$BT2_OUT_DIR" ]]; then
    echo "$BT2_OUT_DIR does not exist. Directory created for Bowtie2 ouput."
    mkdir -p "$BT2_OUT_DIR"
fi

if [[ ! -d "$CLARK_OUT_DIR" ]]; then
    echo "$CLARK_OUT_DIR does not exist. Directory created for CLARK output."
    mkdir -p "$CLARK_OUT_DIR"
fi

if [[ ! -d "$STDOUT_DIR" ]]; then
    echo "$STDOUT_DIR does not exist. Directory created for standard out."
    mkdir -p "$STDOUT_DIR"
fi

export CWD=$(cd $(dirname "$0") && pwd)
export STEP_SIZE=1

echo "Finding FASTA files in \"$FASTA_DIR\""
export FASTA_LIST=$(mktemp)
find $FASTA_DIR -type f -name \*.fasta > $FASTA_LIST
echo "FASTA files to be processed:" `cat -n $FASTA_LIST`
NUM_FILES=$(lc $FASTA_LIST)

JOBS_ARG=""
if [[ $NUM_FILES -gt 1 ]]; then
  JOBS_ARG="-J 1-$NUM_FILES"
  if [[ $STEP_SIZE -gt 1 ]]; then
    $JOBS_ARG="$JOBS_ARG:$STEP_SIZE"
  fi
fi

JOB_ID1=`qsub $JOBS_ARGS -v CWD,SCRIPT_DIR,BT2_OUT_DIR,BT2_INDEX,FASTA_LIST,FASTA_DIR,STEP_SIZE -N Bowtie2 -j -oe -o "$STDOUT_DIR" $SCRIPT_DIR/bt2_align.sh`

export UNMAPPED_LIST=$(mktemp)
sed 's/.fasta/.unmapped/' $FASTA_LIST > $UNMAPPED_LIST

JOB_ID2=$(qsub $JOBS_ARG -v UNMAPPED_LIST,SCRIPT_DIR,BT2_OUT_DIR,CLARK_OUT_DIR,CLARK_DIR,CLARK_DB,UNMAPPED,KMER_SIZE,MODE,NUM_THREAD,STEP_SIZE -N CLARK -W depend=afterok:$JOB_ID1 -j -oe "$STDOUT_DIR" $SCRIPT_DIR/run_clark.sh)

rm $UNMAPPED_LIST
