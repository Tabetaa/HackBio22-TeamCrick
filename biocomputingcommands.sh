#!/bin/bash

#Command Prompt for story one: Biocomputing

mkdir oreoluwa
mkdir biocomputing && cd biocomputing
wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.fna 
wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk
wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk
ls
mv wildtype.fna ../oreoluwa/
rm wildtype.gbk.1
ls
cd ../oreoluwa/
ls
grep 'tatatata' wildtype.fna
grep 'tatatata' wildtype.fna > mutant
clear
history



# Command Prompt for story 2 

sudo apt install figlet
figlet -r Tabitha
ls
mkdir compare
cd compare
wget https://www.bioinformatics.babraham.ac.uk/training/Introduction%20to%20Unix/unix_intro_data.tar.gz
gunzip unix_intro_data.tar.gz 
tar -xvf unix_intro_data.tar
cd seqmonk_genomes/Saccharomyces\ cerevisiae/EF4
grep 'rRNA' Mito.dat
cp Mito.dat compare
nano Mito.dat
mv Mito.dat Mitochondrion.txt
ls
cd
cd compare
cd FastQ_Data
ls
wc -l lane8_DD_P4_TTAGGC_L008_R1.fastq.gz
wc -l *.gz >> Totalines

# github repo link
echo https://github.com/Tabetaa/HackBio22-TeamCrick.git

  
