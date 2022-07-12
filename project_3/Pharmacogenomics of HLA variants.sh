#!/bin/bash

#Title : Pharmacogenomics of HLA variants in 4 Asian populations


 script
# make new directory HLA_project
mkdir HLA_project && cd $_
#download complete_1000_genomes_samples
wget https://github.com/HackBio-Internship/public_datasets/blob/main/Asia_HLA_Distribution/complete_1000_genomes_sample_list_.tsv 

#download dataset for the asia population

wget https://github.com/HackBio-Internship/public_datasets/blob/main/Asia_HLA_Distribution/binary_plink_file/asia.bed.gz?raw=true  -O  asia.bed.gz

wget https://github.com/HackBio-Internship/public_datasets/blob/main/Asia_HLA_Distribution/binary_plink_file/asia.bim?raw=true -O asia.bim

wget https://github.com/HackBio-Internship/public_datasets/blob/main/Asia_HLA_Distribution/binary_plink_file/asia.fam -O asia.fam

#gunzip the binary ped file asia.bed.gz 
gunzip asia.bed.gz

#perform PCA analysis on the sample
#generate eigenvalues on the asia files using the plink tool
plink —file asia —pca 

#download file from linux terminal to Rstudio for further analysis
#print working directory and copy
#pwd
#open local directory terminal and download file from server
#scp -P port_id -r serverloginid://workingdirectory  $PWD

#Generating PCA plot in R
#check working directory
getwd()

#load plink.eigenvec file
pca1 <- read.table("/Users/project3/plink.eigenvec", sep= "", header = F)
#check the first 5 lines of the file
head(pca1)

#preliminary plot using pca1
library("ggplot2")
ggplot(data=pca1, aes(V3,V4)) + geom_point()

#load 1000_genome_sample list
metadata <- read.table("/Users/project3/complete_1000_genomes_sample_list_.tsv", sep= "\t", header = TRUE)

#merge pca1 and metadata data by using the common column in both samples
merge_data <- merge(x= pca1, y= metadata, by.x = "V2", by.y = "Sample.name", all = F)

#load ggplot to do the PCA plot, change title and labels 
PCA <- ggplot(data=merge_data, aes(V3,V4, color = Population.code)) + geom_point()
          +xlab("Principal Component 1 (PC1)")
          +ylab("Principal Component 2 (PC2)")
          +ggtitle("PCA of selected Asain Populations")


#Multidimensional Scaling Analysis
#Create a pruned set of markers that are not highly correlated

plink --bfile asia --indep-pairwise 1000 10 0.01— out prune1

#Calculate identity by descent score on the pruned marker list
plink bfile —extract prune1.prunein —genome —out ibs1

#POPULATION STRATIFICATION
plink --bfile asia --read-genome ibs1.genome --cluster --ppc 1e-3 --cc --mds-plot 2 --out strat1

#MDS VISUALISATION
mdsdata <- read.table("strat1.mds", header = TRUE)
merged_mds <- merge(x=msdata, y=metadata, by.x= "FID", by.y= "Sample.name", all = F)

#Scatterplot 

ggplot(data=merged_mds, aes(C1,C2, color = Population.code)) + geom_point()
        +ggtitle("Multidimensional Scaling Analysis")

#download link for R & R-studio(macOS)
#https://cran.r-project.org/bin/macosx/
#https://www.rstudio.com/products/rstudio/download/

