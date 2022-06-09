# Draft Tutorial 

#### Trimming RNA-Seq Reads
Raw data is messy, with errors and left over adapters from sequencing that will cause spurious mapping results. Cleaning your data by trimming the reads for non-adaptor, high-quality score reads with reasonable lengths is important for downstream data processing steps and result interpretation. Stuart Davis has a really nice [data-centric blog](https://www.basepairtech.com/blog/trimming-for-rna-seq-data/#:~:text=Quality%20trimming%20decreases%20the%20overall,useful%20data%20for%20downstream%20analyses.&text=Too%20aggressive%20quality%20trimming%20can,%2C%20estimation%20of%20gene%20expression) on trimming RNA-seq reads (the why and when).    

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
