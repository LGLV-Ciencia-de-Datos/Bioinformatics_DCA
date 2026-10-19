#RNASeq analysis in R

#Install BiocManager if not already installed
install.packages("BiocManager")

#Install DESEq2 and other packages

BiocManager::install("SummarizedExperiment")
BiocManager::install("DESeq2")
install.packages("gtable")
install.packages("stringi")
install.packages("tidyverse")
BiocManager::install("EnhancedVolcano")
BiocManager::install("apeglm")
install.packages("pheatmap")
install.packages("PoiClaClu")

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("EnhancedVolcano")

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("apeglm")

#Load required libraries
library(DESeq2)
library(tidyverse)
library(dplyr)
library(EnhancedVolcano)
library(pheatmap)
library(apeglm)
library(RColorBrewer)
library(ggplot2)

# setwd("C:/Users/hanzo/OneDrive/Desktop/New Courses/Bioinformatics Data analysis course/R/Course/deseq/")
setwd("C:/Users/lgerm/OneDrive/Desktop/R")

#Read Metadata
metadata <- read.delim("metadata.tsv")

# Import the gene raw counts
counts <- read.delim("counts.tsv")

#Analysis

#Create DESeq2 Object
dds = DESeqDataSetFromMatrix(counts,metadata,~type)

rld <- vst(dds)

#Visualize
head(assay(rld))

#Calculate Sample-to-Sample distances

sampleDists <- dist( t( assay(rld) ) )

#using normalized data

sampleDistMatrix <- as.matrix( sampleDists )
rownames(sampleDistMatrix) <- paste( rld$type, rld$id, sep="-" )
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(sampleDistMatrix,
         clustering_distance_rows=sampleDists,
         clustering_distance_cols=sampleDists,
         col=colors)

#PCA
#Simple
plotPCA(rld, intgroup = c("type"))

#Perform DESeq analysis

#Relevel to make "normal" appear first in the data

dds$type <- relevel(dds$type, "normal")

#Run DESeq2
dds <- DESeq(dds)

#Build results table
res <- results(dds)

#Observe important information from results
mcols(res, use.names=TRUE)

#baseMean = average of normalized counts

#log2FoldChange = Effect size estimate: how much gene's expression changed due to cancer
#This is reported on a logarithmic scale to base 2. This means a log2FC of 1.5 represents 
#change in gene expression by ~3x (2^1.5=2.82)

#lfcSE: LFC Standard Error

#stat: names the test used for testing significance

#pvalue: represents the p-value

#padj: corrected p-value or FDR

summary(res)

#FDR can be lowered
#res.05 <- results(dds, alpha=0.01)
#summary(res.05)


#LFC2 and alpha 0.02
#lfc2res.05 <- results(dds, alpha=0.01, lfcThreshold=2)
#summary(lfc2res.05)




#Filter the results to obtain genes with most significant change in expression
#Here, padj < 0.1 which is also the default
#You can lower this value to get only highly significant results

resSig <- subset(res, padj < 0.1)
summary(resSig)

#Observe in ascending order
head(resSig[ order( resSig$log2FoldChange ), ])

#Observe in descending order
head(resSig[ order( -resSig$log2FoldChange ), ])

#Quick visual of top gene
topGene <- rownames(res)[which.min(res$padj)]
plotCounts(dds, gene=topGene, intgroup=c("type"))

#ggplot2
data <- plotCounts(dds, gene=topGene, intgroup=c("type","id"), returnData=TRUE)
ggplot(data, aes(x=type, y=count, fill=type)) +
  scale_y_log10() + 
  geom_dotplot(binaxis="y", stackdir="center")


#MA Plot

plotMA(res, ylim=c(-5,5))
plotMA(res, ylim=c(-5,5))
with(res[topGene, ], {
  points(baseMean, log2FoldChange, col="dodgerblue", cex=2, lwd=2)
  text(baseMean, log2FoldChange, topGene, pos=2, col="dodgerblue")
})

#Create publication grade volcano plot with marked genes of interest
EnhancedVolcano(res,
                lab = rownames(counts),
                x = 'log2FoldChange',
                y = 'pvalue',
                pCutoff = 10e-5,
                FCcutoff = 1.333,
                xlim = c(-5.7, 5.7),
                ylim = c(0, -log10(10.2e-12)),
                pointSize = 1.3,
                labSize = 2.6,
                title = 'The results',
                subtitle = 'Differential expression analysis',
                caption = 'log2fc cutoff=1.333; p value cutof=10e-5',
                legendPosition = "right",
                legendLabSize = 14,
                col = c('lightblue', 'orange', 'blue', 'red2'),
                colAlpha = 0.6,
                drawConnectors = TRUE,
                hline = c(10e-8),
                widthConnectors = 0.5)

#changed with log2fold change of 2
EnhancedVolcano(res,
                lab = rownames(counts),
                x = 'log2FoldChange',
                y = 'pvalue',
                pCutoff = 10e-5,
                FCcutoff = 2,
                xlim = c(-5.7, 5.7),
                ylim = c(0, -log10(10.2e-12)),
                pointSize = 1.3,
                labSize = 2.6,
                title = 'The results',
                subtitle = 'Differential expression analysis',
                caption = 'log2fc cutoff=2; p value cutof=10e-5',
                legendPosition = "right",
                legendLabSize = 14,
                col = c('lightblue', 'orange', 'blue', 'red2'),
                colAlpha = 0.6,
                drawConnectors = TRUE,
                hline = c(10e-8),
                widthConnectors = 0.5)

#Create publication grade volcanoplot with marked genes of interest
EnhancedVolcano(res,
                lab = rownames(counts),
                x = 'log2FoldChange',
                y = 'padj',
                pCutoff = 10e-7,
                FCcutoff = 2.5,
                xlim = c(-5.7, 5.7),
                ylim = c(0, -log10(10.2e-12)),
                pointSize = 1.3,
                labSize = 2.6,
                title = 'The results',
                subtitle = 'Differential expression analysis',
                caption = 'log2fc cutoff=1.333; p value cutof=10e-6',
                legendPosition = "right",
                legendLabSize = 14,
                col = c('lightblue', 'orange', 'blue', 'red2'),
                colAlpha = 0.6,
                drawConnectors = TRUE,
                hline = c(10e-8),
                widthConnectors = 0.5)

#Create the final dataframe consisting of ordered deseq results based on log2fc
resord=as.data.frame(res)
finaltable1=resord[order(resord$padj),]
write.table(finaltable1, file = 'finaltable.csv', sep = "\t",
            col.names = NA, quote = F)




#2nd part of analysis
####
#BiocManager::install("genefilter")

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("genefilter")

library("genefilter")

topVarGenes <- head(order(-rowVars(assay(rld))),20)
mat <- assay(rld)[ topVarGenes, ]
mat <- mat - rowMeans(mat)
df <- as.data.frame(colData(rld)[,c("type","id")])
pheatmap(mat, annotation_col=df)

#########################
#Some advance analyses###
#########################

######## Part 2 #########

#view(resord)

#Our results are currently using Ensembl IDs.
#Gene names are not included in the table.
#We begin by adding gene names in the results

#Additional library from Bioconductor is needed.

#First, install the library.
#BiocManager::install("org.Hs.eg.db")

#This library allows conversion between various ID types
#Our major goal is to add Gene symbols corresponding to Ensembl IDs

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("org.Hs.eg.db")

library("org.Hs.eg.db")

#Load the other library
library("AnnotationDbi")

#Look at the information available in org.Hs.eg.db
columns(org.Hs.eg.db)

#Actually add gene symbols and Entrez IDs to the existing results

res$symbol <- mapIds(org.Hs.eg.db, 
                     keys=row.names(res), 
                     column="SYMBOL", 
                     keytype="ENSEMBL",
                     multiVals="first")

res$entrez <- mapIds(org.Hs.eg.db, 
                     keys=row.names(res), 
                     column="ENTREZID", 
                     keytype="ENSEMBL",
                     multiVals="first")

resOrdered <- res[order(res$padj),]

#Preview the results
head(resOrdered)

#If you observe the last to two columns, you will see symbol and entrez have 
#been added to the results (res) object.

#You can save this to a file
write.csv(as.data.frame(resOrdered), file="results.csv")


##########################################
####Geneset Enrichment Analysis (GSEA)####
##########################################

#Create a new directory named GSEA in your current working directory

results_dir <- "GSEA" 

# Create the results folder if it doesn't exist
if (!dir.exists(results_dir)) {
  dir.create(results_dir)
}

#Some more packages to be installed

#BiocManager::install("clusterProfiler")

#BiocManager::install("msigdbr")

#Some additional steps

finaltable2 <- finaltable1
finaltable2$Gene <- row.names(finaltable2)
row.names(finaltable2)<-NULL

#Rearrange the columns
finaltable2<-finaltable2[,c(7, 1:6)]


dge_mapped_df <- data.frame(
  gene_symbol = mapIds(
    org.Hs.eg.db,
    keys = finaltable2$Gene,
    # Replace with the type of gene identifiers contained in the data
    #Our table had Ensembl IDs, thus we use Ensembl as Keytype
    keytype = "ENSEMBL",
    # Replace with the type of gene identifiers you would like to map to
    #We want to get gene symbols, thus, we use Symbol here, as shown in the above example as well
    column = "SYMBOL",
    # This will keep only the first mapped value for each Ensembl ID
    multiVals = "first"
  )
)%>%
  # If an Ensembl gene identifier doesn't map to a gene symbol, drop that
  # from the data frame
  dplyr::filter(!is.na(gene_symbol)) %>%
  # Make an `Ensembl` column to store the rownames
  tibble::rownames_to_column("Ensembl") %>%
  # Now join the rest of the expression data
  dplyr::inner_join(finaltable2, by = c("Ensembl" = "Gene"))

#Compare finaltable2 with dge_mapped_df to see how many hits were excluded

#See if there are duplicate gene symbols

any(duplicated(dge_mapped_df$gene_symbol))

#select duplicate genes in a list
dup_gene_symbols <- dge_mapped_df %>%
  dplyr::filter(duplicated(gene_symbol)) %>%
  dplyr::pull(gene_symbol)

#View which gene
dge_mapped_df %>%
  dplyr::filter(gene_symbol %in% dup_gene_symbols) %>%
  dplyr::arrange(gene_symbol)

#Remove duplicates
filtered_dge_mapped_df <- dge_mapped_df %>%
  # Sort so that the highest absolute values of the log2 fold 
  #change are at the top
  dplyr::arrange(dplyr::desc(abs(log2FoldChange))) %>%
  # Filter out the duplicated rows using `dplyr::distinct()`
  dplyr::distinct(gene_symbol, .keep_all = TRUE)

#Double check if duplicates were removed

any(duplicated(filtered_dge_mapped_df$gene_symbol))

#Create vector for gene-level L2FC values. This is needed in GSEA
lfc_vector <- filtered_dge_mapped_df$log2FoldChange
names(lfc_vector) <- filtered_dge_mapped_df$gene_symbol

#Sort the log2 fold change values in descending order here
#This gives us the ranked gene list

lfc_vector <- sort(lfc_vector, decreasing = TRUE)

# Look at first entries of the ranked log2 fold change vector
head(lfc_vector)

#Time for performing GSEA
# Set the seed so our results are reproducible:
set.seed(2020)

#Load more libraries
#Install any missing ones

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("clusterProfiler")

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("enrichplot")
BiocManager::install("msigdbr_species")
BiocManager::install("msigdbr")

library(clusterProfiler)
library(msigdbr)
library(magrittr)

#Getting familiar with msigdbr

msigdbr_species()

#Obtain hallmark gene sets for humans
#Hallmarks are collections of genes with similar functions

hs_hallmark_sets <- msigdbr(
  species = "Homo sapiens", 
  category = "H")


#Preview hallmark gene set
head(hs_hallmark_sets)

#Running GSEA
gsea_results <- GSEA(
  geneList = lfc_vector, 
  minGSSize = 25, # Minimum gene set size
  maxGSSize = 500, # Maximum gene set set
  pvalueCutoff = 0.05, # p-value cutoff
  eps = 0, # Boundary for calculating the p value
  seed = TRUE, # Set seed to make results reproducible
  pAdjustMethod = "BH", # Benjamini-Hochberg correction
  TERM2GENE = dplyr::select(
    hs_hallmark_sets,
    gs_name,
    gene_symbol))

#Preview gsea results

head(gsea_results@result)

#Convert results to dataframe

gsea_result_df <- data.frame(gsea_results@result)

gseaResTidy <- gsea_result_df %>%
  as_tibble() %>%
  arrange(desc(NES))

# Show in a nice table:
gseaResTidy 
#View the output carefully

#Visualize all Hallmark pathways with significant up/downregulations
ggplot(gseaResTidy, aes(reorder(ID, NES), NES)) +
  geom_col(aes(fill=p.adjust<0.01)) +
  coord_flip() +
  labs(x="Pathway", y="Normalized Enrichment Score",
       title="Hallmark pathways from GSEA")

#Visualize results

highest3<- gsea_result_df %>%
  # This returns the 3 rows with the largest NES values
  dplyr::slice_max(NES, n = 3)


#HALLMARK_E2F_TARGETS

most_positive_nes_plot <- enrichplot::gseaplot(
  gsea_results,
  geneSetID = "HALLMARK_E2F_TARGETS",
  title = "HALLMARK_E2F_TARGETS",
  color.line = "#0d76ff")

most_positive_nes_plot


#Most negative NES
negative3<- gsea_result_df %>%
  # Return the 3 rows with the smallest (most negative) NES values
  dplyr::slice_min(NES, n = 3)


#HALLMARK_FATTY_ACID_METABOLISM
most_negative_nes_plot <- enrichplot::gseaplot(
  gsea_results,
  geneSetID = "HALLMARK_FATTY_ACID_METABOLISM",
  title = "HALLMARK_FATTY_ACID_METABOLISM",
  color.line = "#0d76ff")

most_negative_nes_plot

#Export results to file

readr::write_tsv(
  gsea_result_df,
  file.path(
    results_dir,
    "GSEA_results.tsv"))

#dim(gsea_result_df)

#Dotplot using GO
#GO requires using Subontologies: 
#Biological Process (BP), Molecular Function (MF) and Cellular Component (CC).

ego<-enrichGO(gene     = dge_mapped_df$Ensembl,
              OrgDb         = org.Hs.eg.db,
              keyType       = 'ENSEMBL',
              ont           = "CC",
              pAdjustMethod = "BH",
              pvalueCutoff  = 0.01,
              qvalueCutoff  = 0.05)

dotplot(ego, showCategory=15)

#

