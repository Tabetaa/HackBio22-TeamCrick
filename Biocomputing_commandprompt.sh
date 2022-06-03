#!/bin/bash

#Command Prompt for story one: Biocomputing

    1  mkdir oreoluwa
    2  mkdir biocomputing && cd $_
    3  wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.fna 
    4  wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk
    5  ls
    6  mv wildtype.fna ../oreoluwa/
    7  rm wildtype.gbk.1
    8  ls
    9  cd ../oreoluwa/
   10  ls
   11  grep 'tatatata' wildtype.fna
   12  grep 'tatatata' wildtype.fna > mutant
   13  clear
   14  history
   15  ls && ls ../biocomputing


# Command Prompt for story 2 

   16  sudo apt install figlet
   17  figlet -r Tabitha
   18  wget https://www.bioinformatics.babraham.ac.uk/training/Introduction%20to%20Unix/unix_intro_data.tar.gz 
   19  ls
   21  mkdir compare
   22  cd compare
   23  wget https://www.bioinformatics.babraham.ac.uk/training/Introduction%20to%20Unix/unix_intro_data.tar.gz
   24  gunzip unix_intro_data.tar.gz 
   25  tar -xvf unix_intro_data.tar
   26  cd seqmonk_genomes/Saccharomyces\ cerevisiae/EF4
   27  grep 'rRNA' Mito.dat
   28  cp Mito.dat compare
   29  nano Mito.dat
   30  mv Mito.dat Mitochondrion.txt
   31  ls
   34  cd
   36  cd compare
   37  cd FastQ_Data
   38  ls
   39  wc lane8_DD_P4_TTAGGC_L008_R1.fastq.gz
   40  wc -l lane8_DD_P4_TTAGGC_L008_R1.fastq.gz
   41  wc -l *.gz >> Totalines
   42  history
   43  clear
  
