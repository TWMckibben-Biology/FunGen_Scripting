# Scripting Final Project

This repository aims to show every step from receiving sequencing data to producing a counts table for differential gene expression analysis, processing on both command line and Rstudio

## Overview

1. Pull accessioned fastq data and filter for quality

2. Trim sequence adaptors and refilter

3. Map sequence data against a reference genome

4. Generate, filter, and transform a gene expression count table

## Packages used

CLI: sra, fastQC, trimmomatic, hisat2, stringtie, samtools, gffread, and gffcompare

Rstudio: DESeq2

## Script Purpose and Walkthrough

CLI Scripts:
  
  *All scripts are formatted to run on the Alabama SuperComputer (ASC). To reproduce, request an account. Each script contains the variable $MyID which will need to be altered to your unique ASC ID in order to set file paths correctly
  
  *Reference data is provided by the Schwartz-Lab-at-Auburn/FunctionalGenomicsCourse. Fork and clone this repo on the ASC https://github.com/Schwartz-Lab-at-Auburn/FunctionalGenomicsCourse
  
  0_1_DownloadSRA_QualityCheck.sh: Run Time ~ 5 hours
  
    This script downloads the accessioned RNAseq data and passes it through fastQC. In doing so, it filters the sequence data individually and then sees if both reads (forward and back) still pass the quality cut-offs. If so, a "paired" read file is created. It also creates the file structure used with the rest of the scripts.

  2_cleanTrimmomatic_QualityFastQC.sh: Run Time ~ 3 hours
  
    This script runs trimmomatic to remova illumina-based sequencing adaptors and then re-runs fastQC, pushing new paired read files.

  mapper_hisat2: Run Time ~ 3 hours
  
    This script runs hisat2, using the paired read sequence files generated by step 2, to map reads against the reference genome and annotation. It converts this information into a SAM file as an input for downstream analyses programs. It also generates a count matrix describing the number of times an aligned sequence occurred within each sample. This is the data fed into DESeq2
    
Rstudio Scripts:

  *a phenotype data sheet (PHENO_DATA.txt) was provided from the Functional Genomics repo, but has been locally stored within this repo. It is not data generated by a program, rather from the researcher doing the study. It describes sample type and treatment allocation.

  Scripting_FinalProject.R: Run Time <10 minutes

    This script downloads, installs, and libraries DESeq2. It then loads the gene count matrix generated by our mapper and the phenotype data. It combines them to allow for by treatment analysis of differential gene expression.
