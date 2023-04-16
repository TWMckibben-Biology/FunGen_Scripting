#Intro to Scripting Spring 2023: Final Project

## Background

RNA sequencing allows for the exploration of the "transcriptome," a snapshot of what mRNA was being produced at the moment of collection. These data show how the activation of transcription is being altered by experimental conditions. This analysis process starts off with fastq data just like gene sequencing and can be processed in much the same way. In contrast to gene sequencing, RNAseq produces a read count which can be associated with annotated genes and pathways to assess overall levels of expression.

## Project Purpose

This repository serves to test the various methods of assembly and their effects on downstream analysis. Sequences must either be aligned to a reference (genome or transcriptome) or assembled de novo. Both of these approaches have strengths, reference-based having a higher level of accuracy while de novo allows for the detection of isoforms and splice variants. Reference-based assembly is the preferred method as it is more stable and reproducible across studies, but requires a high-quality annotation; de novo assembly is particularly susceptible to low read counts biasing the models used in its alignment.


This project aims to provide the necessary scripts for testing a data set through both methods and comparing the differences caused by assembler choice.

## General Workflow:

### Aaw
