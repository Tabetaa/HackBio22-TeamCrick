# HackBio22-TeamCrick
Genomics Bioinformatics Workshop(HackBIO)

This repository contains all the projects conducted during the 5 weeks intensive genomics workshop 

Week 1 :
Stage Zero - Introduction to Born Again Shell (BASh) Scripting
In this stage, we learnt the basics of the BASH script through hands on reverse learning application on the google shell linux terminal. We worked on two story in the workbook provided by HACKBIO. I created a simple bash script using commands such as mkdir to create directory , wget to download files into the linux terminal, grep command, figlet for graphical representation, changing directorys (cd ../../) and counting lines, and installing software using the sudo apt install command.

Week2 :

Stage One - Biological Data analysis using bash.
This stage involved analysis genome sequences from data collection to genome mapping using a reference sequence.
Firstly, the DNA file was downloaded on the google cloud shell using the wget command and sequence was counted using the grep ">"  and wc -command
The following software packages were used
-fastqc for quality control
-fastp - trimming poor reads
-samtools && bbtools
An automated scripted was created to preform both the trimming and genome_mapping. The full script can be found in HB_StageOne_Tasks.sh

Week 3

Stage 3: Reproducing a 
