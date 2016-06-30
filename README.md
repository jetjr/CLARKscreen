# CLARKscreen

This workflow is two part:
1)  Utilize Bowtie2 to extract UNMAPPED reads from a FASTA file. 
2)  Run CLARK on the UNMAPPED reads to classify the metagenome and relative abundance.

________________________________________________________________________________

Tutorial

1) Clone this repository 
    
    [user@host]$ git clone https://github.com/jetjr/CLARKscreen

2) Edit config.sh script to update environmental variables and parameters

    [user@host]$ vi config.sh
   
* Important: FASTA_DIR, BT2_INDEX, CLARK_DB, and CLARK_DIR must exist prior to executing job and must contain relevent files. For example FASTA_DIR should point to the directory that contains the FASTA files you wish you analyze. BT2_INDEX points to the directory containing the Bowtie2 index files you wish to screen against. CLARK_DIR points to the directory containing the CLARK scripts and CLARK_DB points to the database used for CLARK.

All other directories such as results and standard out/error will be created for you if they do not exist.

3) Execute start_workflow.sh script

    [user@host]$ ./start_workflow.sh

Each FASTA file found in FASTA_DIR will be analyzed in this workflow. The UNMAPPED reads will be stored in the directory designated as BT2_OUT_DIR and the CLARK abundance results will be stored in the directory designated as CLARK_OUT_DIR.

AUTHOR: James Thornton, University of Arizona
