# Intro to Scripting Spring 2023: Final Project

## Background

RNA sequencing allows for the exploration of the "transcriptome," a snapshot of what mRNA was being produced at the moment of collection. These data show how the activation of transcription is being altered by experimental conditions. This analysis process starts off with fastq data just like gene sequencing and can be processed in much the same way. In contrast to gene sequencing, RNAseq produces a read count which can be associated with annotated genes and pathways to assess overall levels of expression.

## Project Purpose

This repository serves to test the various methods of assembly and their effects on downstream analysis. Sequences must either be aligned to a reference (genome or transcriptome) or assembled de novo. The choice of assembler is made by the data at hand. Reference-based mappers require a reference genome or transcriptome with a high quality annotation, requiring lower read depth to achieve reliable results. De novo requires no pre-existing library, but does suffer from reliability issues without proper read depth and sample size.


This project aims to provide the necessary scripts for testing a data set through both methods and comparing the differences caused by assembler choice. Hopefully this would allow a researcher to assess if their bioinformatics pipeline choice had a significant effect on their analysis and choose the results appropriately.

## General Workflow:

Step 1: Perform a quality check on your fastq files using fastQC
- 0_1_DownloadSRA_QualityCheck.sh

Step 2: Trim adapter sequences and clean with fastQC (specific to illumina adapters)
- 2_cleanTrimmomatic_QaulityFasstQC.sh

Step 3: Alignment/Assembly and file compression
- mapper_hisat2.sh OR
- mapper_salmon.sh

Step 4: Post-CLI Analysis
- Differential Gene Expression
- Functional Enrichment
      
## Required materials

- All processes run on the Alabama Supercomputer (ASC) using a student account; this gives access to a higher performance cluster with reduced traffic
- Reference genome provided within Dr. Tonia Schwartz's Functional Genomics class github repository
    - Relative filepaths are dependent on having access to this repo. Create your own fork and clone it onto your ASC account
- Sequence data is being downloaded by accession via NCBI; current run time is greater than 12 hours for all samples
    - To reduce run time for reproducibility, delete all but 3 "SRR" numbers from script 0_1_DownloadSRA_QualityCheck.sh
- All filepaths are currently set to my own account, but are referenced as the variable $MyID when possible. Simply change that variable to match your own account
    - If you encounter problems, check further down the script to ensure that there arent any hardcoded references that need to be changed

## Description of Scripts

### 0_1_DownloadSRA_QualityCheck.sh
This script downloads RNAseq accessions, converts them to fastq, and performs a quality check on them; uses fastQC package

### 2_cleanTrimmomatic_QualityFastQC.sh
This script takes the fastq output from script 1 and uses trimmomatic to remove illumina adaptors and then filters data again based on quality; uses Trimmomatic and fastQC packages

### mapper_hisat2
This script performs a reference-based alignment/mapping of the transcript sequences and then converts the output as a read count table csv

### mapper_salmon
This script performs a de novo assmebly (or pseudoassembly) using the transcript sequences and converts the output as a read count table csv
