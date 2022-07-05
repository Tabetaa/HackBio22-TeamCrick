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

# install figlet
sudo apt-get install figlet

#create figlet at the right
figlet -r Oreoluwa

#create file
mkdir compare && cd $_

#Download new file into compare directory
wget https://www.bioinformatics.babraham.ac.uk/training/Introduction%20to%20Unix/unix_intro_data.tar.gz

#Unzip .gz file
gunzip unix_intro_data.tar.gz

#Untar .tar file
tar -xvf unix_intro_data.tar

#Get into seqmonk_genomes/Saccharomyces cerevisiae/EF4 and identify the rRNAs present in Mito.dat.
cd seqmonk_genomes/Saccharomyces\ cerevisiae/EF4
grep 'rRNA' Mito.dat

#copy Mito.dat into the compare directory and move into compare directory
cp Mito.dat ../../../
cd ../../../

#Open Mito.dat and edit file
nano Mito.dat

#Rename the file from Mito.dat to Mitochondrion.txt
mv Mito.dat Mitochondrion.txt

#move into FastQ_Data and calculate of total number of lines in lane8_DD_P4_TTAGGC_L008_R1.fastq.gz
cd FastQ_Data
wc -l lane8_DD_P4_TTAGGC_L008_R1.fastq.gz

#Print the total number of lines in all fastq.gz files and save it as a new file
wc -l *.gz > fastqcount.txt
cat fastqcount.txt

# github repo link
echo https://github.com/Tabetaa/HackBio22-TeamCrick.git
