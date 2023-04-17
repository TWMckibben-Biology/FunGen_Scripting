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

### Something Else
