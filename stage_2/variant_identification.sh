#!/bin/bash

#create directory for genome analysis
mkdir Linux_Pipeline  && cd $_
mkdir raw_data && cd $

#Downloading genome (Tumor & Normal) sample dataset
wget https://zenodo.org/record/2582555/files/SLGFSK-N_231335_r1_chr5_12_17.fastq.gz
wget https://zenodo.org/record/2582555/files/SLGFSK-N_231335_r2_chr5_12_17.fastq.gz
wget https://zenodo.org/record/2582555/files/SLGFSK-T_231336_r1_chr5_12_17.fastq.gz
wget https://zenodo.org/record/2582555/files/SLGFSK-T_231336_r2_chr5_12_17.fastq.gz

#change directory to Linux_Pipeline
cd ..

#Download reference sample data
mkdir reference  && cd $_
wget https://zenodo.org/record/2582555/files/hg19.chr5_12_17

#Unzip reference sample using gunzip
gunzip hg19.chr5_12_17

#change directory
cd ..

#create new directory & Check quality of sample sequence
mkdir Fastqc_Reports
fastqc *.fastq.gz -o Fastqc_Reports
multiqc Fastqc_Reports -o Fastqc_Reports

#Trim: remove low quality sequence using fastp
#create script
#nano trim.sh 
#!/bin/bash

mkdir -p  trimmed_reads

SAMPLES=(
  "SLGFSK-N_231335"
  "SLGFSK-T_231336"
)

for SAMPLES in "${SAMPLES[@]}"; do

  fastp \
    -i "$PWD/${SAMPLES}_r1_chr5_12_17.fastq.gz" \
    -I "$PWD/${SAMPLES}_r2_chr5_12_17.fastq.gz" \
    -o "trimmed_reads/${SAMPLES}_r1_chr5_12_17.fastq.gz" \
    -O "trimmed_reads/${SAMPLES}_r2_chr5_12_17.fastq.gz" \
    --html "trimmed_reads/${SAMPLES}_fastp.html"

done

#bash trim.sh

#mapping sample against the reference sample
#download software BWA SAMTOOLS & BAMTOOLS
conda install -y -c bioconda bwa
conda install -c bioconda samtools
conda install -c bioconda bamtools

#Index reference sample using BWA
bwa index reference/hg19.chr5_12_17.fa

#Align sequence
mkdir genome_mapping

bwa mem -t 8 reference/hg19.chr5_12_17.fa \
trimmed_reads/SLGFSK-N_231335_r1_chr5_12_17.fastq.gz trimmed_reads/SLGFSK-N_231335_r2_chr5_12_17.fastq.gz \
| samtools view -b > genome_mapping/SLGFSK-N.bam

bwa mem -t 8 reference/hg19.chr5_12_17.fa \
trimmed_reads/SLGFSK-T_231336_r1_chr5_12_17.fastq.gz  trimmed_reads/SLGFSK-T_231336_r2_chr5_12_17.fastq.gz \
| samtools view -b > genome_mapping/SLGFSK-T.bam

#Sort by reads and index
#create file to include names of the sequence
nano cat 'list.txt'
SLGFSK-N
SLGFSK-T

for sample in `cat list.txt`
do
      
        samtools sort -@ 32  genome_mapping/${sample}.bam  > genome_mapping/${sample}.sorted.bam
        
        samtools index  genome_mapping/${sample}.sorted.bam
done

cd genome_mapping

#Mapped read filter
samtools view -q 1 -f 0x2 -F 0x8 -b SLGFSK-N.sorted.bam > SLGFSK-N.filtered1.bam
samtools view -q 1 -f 0x2 -F 0x8 -b SLGFSK-T.sorted.bam > SLGFSK-T.filtered1.bam

#check output of the results
samtools flagstat  SLGFSK-T.filtered1.bam
samtools flagstat  SLGFSK-N.filtered1.bam

cd ../raw_reads/

#Remove PCR duplicates
samtools rmdup  genome_mapping/SLGFSK-T.sorted.bam  genome_mapping/SLGFSK-T.clean.bam
samtools rmdup  genome_mapping/SLGFSK-N.sorted.bam genome_mapping/SLGFSK-N.clean.bam 

cd ..

#Left align bam

for sample in `cat list.txt`
do      
        cat genome_mapping/${sample}.clean.bam  | bamleftalign -f reference/hg19.chr5_12_17.fa -m 5 -c  > genome_mapping/${sample}.leftAlign.bam

done

#Recalibrate read mapping qualities

for sample in `cat list.txt`
do
        samtools calmd -@ 32 -b genome_mapping/${sample}.leftAlign.bam reference/hg19.chr5_12_17.fa > genome_mapping/${sample}.recalibrate.bam

done

#Refilter read mapping qualities

for sample in `cat list.txt`’” 
do
        bamtools filter -in genome_mapping/${sample}.recalibrate.bam -mapQuality "<=254"  > genome_mapping/${sample}.refilter.bam
done

#Variant Calling and Classification
#download VarScan tools
wget https://sourceforge.net/projects/varscan/files/VarScan.v2.3.9.jar

#convert data to pileup
mkdir Variants

for sample in `cat list.txt`
do
        samtools mpileup -f reference/hg19.chr5_12_17.fa genome_mapping/${sample}.refilter.bam --min-MQ 1 --min-BQ 28 \
                > Variants/${sample}.pileup
done

#Call variant
java -jar VarScan.v2.3.9.jar somatic Variants/SLGFSK-N.pileup \
        Variants/SLGFSK-T.pileup Variants/SLGFSK \
        --normal-purity 1  --tumor-purity 0.5 --output-vcf 1

#Merge VCF files
bgzip Variants/SLGFSK.snp.vcf > Variants/SLGFSK.snp.vcf.gz
bgzip Variants/SLGFSK.indel.vcf > Variants/SLGFSK.indel.vcf.gz
tabix Variants/SLGFSK.snp.vcf.gz
tabix Variants/SLGFSK.indel.vcf.gz
bcftools merge Variants/SLGFSK.snp.vcf.gz Variants/SLGFSK.indel.vcf.gz > Variants/SLGFSK.vcf  --force-samples

#Functional Annotation
snpEff hg19 Variants/SLGFSK.vcf > Variants/SLGFSK.ann.vcf

#Moved to Galaxy to complete Clinical annotation, Querying and Reporting using Gemini
#https://usegalaxy.eu/

