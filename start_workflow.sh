#!/bin/sh

source ./config.sh

if [[ ! -d "$FASTA_DIR" ]]; then
    echo "$FASTA_DIR does not exist. Directory created, but make sure FASTA files are there before you continue. Job terminated."
    mkdir -p "$FASTA_DIR"
    exit 1
fi

if [[ ! -d "$CLARK_DIR" ]]; then
    echo "$CLARK_DIR does not exist. You must declare where CLARK scripts are located. Edit config.sh file before you continue. Job terminated."
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

if [[ ! -d "$STDERR_DIR" ]]; then
    echo "$STDERR_DIR does not exist. Directory created for standard error."
    mkdir -p "$STDERR_DIR"
fi

if [[ ! -d "$STDOUT_DIR" ]]; then
    echo "$STDOUT_DIR does not exist. Directory created for standard out."
    mkdir -p "$STDOUT_DIR"
fi

cd "$FASTA_DIR"
export FASTA_LIST="$FASTA_DIR/fasta-list"
pwd
ls *.fasta > $FASTA_LIST
echo "FASTA files to be processed:" `cat $FASTA_LIST`

while read FASTA; do
    export FASTA="$FASTA"
    NUM_FILES=`wc -l $FASTA_LIST | cut -d ' ' -f 1`

    JOB_ID1=`qsub -v SCRIPT_DIR,BT2_OUT_DIR,BT2_INDEX,FASTA,FASTA_DIR -N Bowtie2 -e "$STDERR_DIR" -o "$STDOUT_DIR" $SCRIPT_DIR/bt2_align.sh`

done < $FASTA_LIST

`cp $FASTA_LIST $BT2_OUT_DIR`
cd "$BT2_OUT_DIR"
export UNMAPPED_LIST="$BT2_OUT_DIR/unmapped-list"
`sed 's/.fasta/.unmapped/' fasta-list > $UNMAPPED_LIST`
#ls *.unmapped > $UNMAPPED_LIST

while read UNMAPPED; do
    export UNMAPPED="$UNMAPPED"
    
    JOB_ID2=`qsub -v SCRIPT_DIR,BT2_OUT_DIR,CLARK_OUT_DIR,CLARK_DIR,CLARK_DB,UNMAPPED,KMER_SIZE,MODE,NUM_THREAD -N CLARK -W depend=afterok:$JOB_ID1 -e "$STDERR_DIR" -o "$STDOUT_DIR" $SCRIPT_DIR/run_clark.sh`

done < $UNMAPPED_LIST
