#!/bin/bash

#Download DNA.fa sequence
wget https://raw.githubusercontent.com/HackBio-Internship/wale-home-tasks/main/DNA.fa

# Counting number of sequence in the DNA.fa
 grep ">" DNA.fa | wc -l

# Counting the total number of  A, T, G & C
grep -v ">" DNA.fa | -E -o "A|T|G|C" | wc -l

#Miniconda download
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh
chmod +x Miniconda3-py39_4.12.0-Linux-x86_64.sh-l
./Miniconda3-py39_4.12.0-Linux-x86_64.sh
ls
source ~/.bashrc

# Install the softwares(Fastp,Fastqc,BWA &SAMTOOLS)
sudo apt install fastqc
sudo apt install fastp
sudo apt install bwa
sudo apt install samtools

#install bbtools for repairing sequences
conda install -c agbiome bbtools

#Alternative download process for bbtools
#create new directory
#mkdir happy && cd $_
#curl -L https://sourceforge.net/projects/bbmap/files/latest/download -o bbtools.tar
#tar -xzvf bbtools.tar.gz
#cd bbmap/
#pwd - copy full path from output and past into the path description
#echo ‘export PATH=“$PATH:/Home/Tabitha_akande/happy_bin” ‘ >> ~/.bash_profile
#source ~/.bash_profile -open a new session
#cd ~/happybin
#check installation version
#bbduk.sh —version

#Download raw sequence
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/ACBarrie_R1.fastq.gz?raw=true/ -O ACBarrie_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Alsen_R1.fastq.gz?raw=true -O Alsen_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Baxter_R1.fastq.gz?raw=true -O Baxter_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Chara_R1.fastq.gz?raw=true -O Chara_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/ACBarrie_R2.fastq.gz?raw=true/ -O ACBarrie_R2.fastq
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Alsen_R2.fastq.gz?raw=true -O Alsen_R2.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Baxter_R2.fastq.gz?raw=true -O Baxter_R2.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Chara_R2.fastq.gz?raw=true -O Chara_R2.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/ACBarrie_R2.fastq.gz?raw=true -O ACBarrie_R2.fastq.gz

#create new directory to save all analysis
mkdir output

#Fastqc sequence analysis-quality 
mkdir fastqc_report
fastqc ACBarrie_R1.fastq.gz ACBarrie_R2.fastq.gz Alsen_R1.fastq.gz Alsen_R2.fastq.gz Chara_R1.fastq.gz Chara_R2.fastq.gz -o fastqc_report

#Preparing sh file to automate triming of sequence using fastp
#nano trim.sh
mkdir  fastp_trimmed
SAMPLES=(
  "ACBarrie"
  "Alsen"
  "Baxter"
  "Chara"
)

for SAMPLES in "${SAMPLES[@]}"; do

  fastp \
    -i "$PWD/${SAMPLES}_R1.fastq.gz" \
    -I "$PWD/${SAMPLES}_R2.fastq.gz" \
    -o "fastp_trimmed/${SAMPLES}_R1.fastq.gz" \
    -O "fastp_trimmed/${SAMPLES}_R2.fastq.qz" \
    --html "fastp_trimmed/${SAMPLES}_fastp.html"
done
#bash trim.sh
ls fastp_trimmed

#Download reference file for BWA 
mkdir reference && cd $_
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/references/reference.fasta

#creating script for automation of bwa and compression using samtools
#nano alignment.sh
SAMPLES=(
  "ACBarrie"
  "Alsen"
  "Baxter"
  "Chara"
)

bwa index reference/reference.fasta
mkdir repaired
mkdir genome_alignment

for sample in "${SAMPLES[@]}"; do

    repair.sh in1="fastp_trimmed/${sample}_R1.fastq.gz" in2="fasts_trimmed/${sample}_R2.fa>
    echo $PWD
    bwa mem -t 1 \
    reference/reference.fasta \
    "repaired/${sample}_R1_rep.fastq.gz" "repaired/$(sample)_R2_rep.fastq.gz" \
  | samtools view -b \
  > "genome_alignment/${sample}.bam"
done
#bash alignment.sh
ls -h genome_alignment/ -lh

#move files to output directory
mkdir raw-reads
mv ACBarrie_R1.fastq.gz ACBarrie_R2.fastq.gz Alsen_R1.fastq.gz Alsen_R2.fastq.gz Baxter_R1.fastq.gz Baxter_R2.fastq.gz Chara_R1.fastq.gz Chara_R2.fastq.gz raw-reads
mv raw-reads output
mv fastp_trimmed output
mv fastqc_report genome_alignment reference repaired
