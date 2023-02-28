####  Preparing DGE result for Functional Enrichment Analysis ###
      # Functional Genomics BIOL: 6850
      # This file uses the dds object produced by the DGEseq2, and the statistical results file that was written.
  
############ Preparing Data for GSEA and Cytoscape.  #############

### Merge 'gene names' with DGE results by Gene Model (gene_id)

## Import Annotation file with results from Blast to databases
Anno <- read.csv("Daphnia_pulex.annotations_Name.csv", stringsAsFactors = FALSE, na.strings=c(""))
summary(Anno)
dim(Anno)
  
## Import the DGE results file make sure the gene model name is 'gene_id' to match annotation file
DGEresults <- read.csv("DGESeq_results.csv", stringsAsFactors = FALSE)
summary(DGEresults)
dim(DGEresults)

## Merge anno with DGE results. Merging by gene_id (the first column). 
# The all.y=FALSE will result in only the rows that are in common between the two files
DGE_Anno <- merge(Anno,DGEresults,by="gene_id",all.y = FALSE)
dim(DGE_Anno)
summary(DGE_Anno)

write.csv(as.data.frame(DGE_Anno), file="DGE_results_GeneName.csv", row.names=FALSE)  

############################# Make ranked list for GSEA ####################
## Here we are calculating a rank for each gene, and adding that column
## The rank is based on the log2fold change (how up or down regulated they are) and the pvalue (significance) 
DGE_Anno_Rank <-  within(DGE_Anno, rank <- sign(log2FoldChange) * -log10(pvalue))
DGE_Anno_Rank 
 
 #subset the results so only Gene Name and rank
DGErank = subset(DGE_Anno_Rank, select = c(Name,rank) )
DGErank

#subset the results so only rows with a Name and rank
DGErank_withName <- na.omit(DGErank)
DGErank_withName
dim(DGErank_withName)

#write.csv(as.data.frame(DGErank_withName), file="DGErankName.csv", row.names=FALSE) 
## for use in GSEA preranked analysis, the file must be tab delimitied and end in .rnk
write.table(DGErank_withName, file="DGErankName.rnk", sep = "\t", row.names=FALSE)  

####  We also need the normalized count data. Here we are going back to the dds object
nt <- normTransform(dds) # defaults to log2(x+1)
head(assay(nt))
# compare to original count data
head(countdata)

# make it a new dataframe
NormTransExp<-assay(nt)
summary(NormTransExp)
head(NormTransExp)

gene_id <-gsub("^[^-]+-", "", rownames(NormTransExp))
NormTransExpIDs  <-cbind(gene_id,NormTransExp)
head(NormTransExpIDs)

#merge with name
Name_NormTransExp <- merge(Anno,NormTransExpIDs,by="gene_id",all.y = FALSE)
dim(Name_NormTransExp )
summary(Name_NormTransExp)

write.csv(as.data.frame(Name_NormTransExp), file="NormTransExpressionData.csv", row.names=FALSE)  

