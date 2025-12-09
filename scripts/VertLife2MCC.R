#################################################################
# R Script: Converts vert life trees into a single MCC  #
# Provided by TA for BIO549 Ryan  #
#################################################################
.libPaths(c("~/R_libs", .libPaths()))

library(ape)
library(phangorn)
library(phytools)

# Set outgroup 
out <- "Macronectes_giganteus" # Change this line to outgroup species with underscore, e.g. "Mus_musculus"!!!

# Read in VertLife output 
trees <- read.nexus("output.nex")

# Generate maximum clade credibility tree
mcc <- maxCladeCred(trees) 
mcc <- root(mcc, outgroup = out)
mcc$node.label[is.na(mcc$node.label)] <- 1

# Visualize tree
png("mcc.png", width = 1280, height = 900)
plotTree(mcc)
dev.off()

# Export tree
write.tree(mcc, "mcc.tre")
