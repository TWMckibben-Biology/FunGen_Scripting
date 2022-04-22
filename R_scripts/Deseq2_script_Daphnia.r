dir()
library(DESeq2)

countData<- read.csv("HH.csv", header= F, sep = ",", row.names = 1 )
countData <- as.matrix(countData)
head(countData)

(condition <- factor(c(rep("FoodRestricted", 5), rep("Control", 5))))

(coldata <- data.frame(row.names=colnames(countData), condition))

# Merge conditions with counts
dds <- DESeqDataSetFromMatrix(countData=countData, colData=coldata, design=~condition)
dds

# Model
dds <- DESeq(dds, minReplicatesForReplace=Inf)
res <- results(dds, independentFiltering=FALSE,cooksCutoff=FALSE, pAdjustMethod = "fdr")
head(res)
summary(res)

resOrdered <- res[order(res$padj),]
head (resOrdered)
summary(resOrdered)

write.csv(as.data.frame(resOrdered),file='HH_DEseq2.csv')

###################################
resSig <- subset(resOrdered, padj < 0.05)
resSig
summary(resSig)

#optional steps to count Up and downregulated genes because summary(resSig) gives the same thing
sum(resSig$log2FoldChange <0, na.rm = TRUE) # Downregulated -> SS 2230, K 2230, SH 2230, HS 2092, HH 2116
sum(resSig$log2FoldChange >0, na.rm = TRUE) # Upregulated -> SS 2685, K 2685, SH 2823, HS 2543, HH 2688

################################




