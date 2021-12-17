# load in required packages
library(limma)
library(edgeR)
library(tools)

# function to get DGE, write to .csv, & store counts
get.DGE.counts <- function(x) {
  # sanity check
  cat("The file I am currently in is: ", x,"\n")
  
  #read in DGE count data
  data <- data.frame(read.csv(x, header=TRUE, row.names=1))
  
  # set colnames to something more informative (i.e. sample ID)
  colnames(data) <- c("FoodRestricted1", "FoodRestricted2", "FoodRestricted3", "FoodRestricted4", "FoodRestricted5", 
                    "AdLib1", "AdLib2", "AdLib3", "AdLib4", "AdLib5")
  
  # create DGEList object with read counts & to hold associated metadata 
  dge <- DGEList(data, group=df$Treatment)
  
  # normalize within/btwn samples using trimmed mean of M-values (TMM) method
  dge <- calcNormFactors(dge, method = "TMM")

  # est common & tagwise dispersion
  dge <- estimateCommonDisp(dge)
  dge <- estimateTagwiseDisp(dge)
  
  # perform exact test btwn caloric restriction & ad lib groups, store as 'res'
  dgeTest <- exactTest(dge)
  res <- topTags(dgeTest, n=nrow(dgeTest$table))
  
  # extract significantly differentially expressed genes, sort, & write to csv
  sigDEG <- res$table[res$table$FDR<0.05,]
  sortedDEG <- sigDEG[order(sigDEG$logFC),]
  
  filename <- tools::file_path_sans_ext(basename(x))
  write.csv(sortedDEG, file=paste("results/", filename, "_EdgeR.csv", sep=""))
  
  # sanity check
  cat("The number of sig DE genes is: ", nrow(sortedDEG),"\n")

  # count number of upregulated & downregulated genes & append to table "results/EdgeR_counts.csv"
  numUp <- sum(sortedDEG$logFC > 0)
  numDown <- sum(sortedDEG$logFC < 0)
  tot <- sum(res$table$FDR < 0.05)
  
  # sanity check
  if (numUp + numDown == tot) {
    print("Everything is okay")
  }
  else {
    print("Problem, boss")
  }
  
  counts <- matrix(c(filename, numUp, numDown, tot),nrow=1,ncol=4)
  
  write.table(counts, append=TRUE, file="results/EdgeR_counts.csv", sep=",", col.names=FALSE, row.names = FALSE)
}

# create a dataframe outlining experimental design
df <- data.frame(matrix(ncol = 2, nrow = 10))
colnames(df) <- c("Sample","Treatment")
df[,1] <- c("FoodRestricted1", "FoodRestricted2", "FoodRestricted3", "FoodRestricted4", "FoodRestricted5", 
            "AdLib1", "AdLib2", "AdLib3", "AdLib4", "AdLib5")
df[,2] <- c("FoodRestricted","FoodRestricted","FoodRestricted","FoodRestricted","FoodRestricted",
            "AdLib","AdLib","AdLib","AdLib","AdLib")

# initialize an empty table for sig dif expressed counts
matrix <- matrix(c("","up","down","total"),ncol=4,nrow=1)
write.table(matrix, "results/EdgeR_counts.csv", row.names=FALSE, col.names = FALSE)

# for all files in dir ending in .csv, get the DGE, etc
files <- list.files(path="data", pattern="*.csv", full.names=TRUE, recursive=FALSE)
for (x in files) {
  get.DGE.counts(x)
}
