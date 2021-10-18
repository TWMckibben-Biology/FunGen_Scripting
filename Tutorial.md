# Draft Tutorial 

#### Trimming RNA-Seq Reads

#### Library Quality

#### Stranded RNA-Seq Data
ECSeq has a [really nice post](https://www.ecseq.com/support/ngs/how-do-strand-specific-sequencing-protocols-work) on how stranded sequence library protocols work and what information they provide.

![from ECSeq Figure 2](https://www.ecseq.com/support/ngs/img/Strand-Specific-Protocols-1.jpg)

The figure above depicts two overlapping genes on opposite strands of DNA. How can you tell if sequencing reads from this region belong to the gene on located on the sense strand vs the gene on the antisense strand?  
**The short answer: if the library isn't stranded (or you aren't using software that incorporates that information) YOU CAN'T!**

It's important to know if your libraries are stranded or unstranded to take advantage of that level of information from your dataset. 
Check out [this blog](https://www.cnblogs.com/emanlee/p/10296378.html) that has compiled information on strandedness and library preparations, 
how to determine how it is stranded based on the library preparation kit, and settings to indicate strandedness in different programs used in
RNA-seq analyses.  


Here is another [helpful blog](https://darencard.net/blog/2019-09-13-determining-stranded-rnaseq/) that demonstrates how to empirically check the strandedness of your library. 
This is useful when you don't have information about library preparation or you want to validate that the library was prepared correctly. You will need
to download the [integrated genome viewer (IGV)](https://software.broadinstitute.org/software/igv/download) from the [Broad Institute](https://www.broadinstitute.org/). 
