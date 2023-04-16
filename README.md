# Intro to Scripting Spring 2023: Final Project

## Background

RNA sequencing allows for the exploration of the "transcriptome," a snapshot of what mRNA was being produced at the moment of collection. These data show how the activation of transcription is being altered by experimental conditions. This analysis process starts off with fastq data just like gene sequencing and can be processed in much the same way. In contrast to gene sequencing, RNAseq produces a read count which can be associated with annotated genes and pathways to assess overall levels of expression.

## Project Purpose

This repository serves to test the various methods of assembly and their effects on downstream analysis. Sequences must either be aligned to a reference (genome or transcriptome) or assembled de novo. The choice of assembler is made by the data at hand. Reference-based mappers require a reference genome or transcriptome with a high quality annotation, requiring lower read depth to achieve reliable results. De novo requires no pre-existing library, but does suffer from reliability issues without proper read depth and sample size.


This project aims to provide the necessary scripts for testing a data set through both methods and comparing the differences caused by assembler choice. Hopefully this would allow a researcher to assess if their bioinformatics pipeline choice had a significant effect on their analysis and choose the results appropriately.

## General Workflow:

Step 1: Perform a quality check on your fastq files using fastQC

Step 2: Trim adapter sequences (specific to illumina adapters)

Step 3: Alignment/Assembly and file compression

Step 4: Differential gene expression

Step 5: Post-CLI analysis
