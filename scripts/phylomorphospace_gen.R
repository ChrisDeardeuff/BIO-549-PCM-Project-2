#################################################################
# author: Chris Deardeuff
# R Script: Phylogenetic Continuous Character Mapping (contMap)   #
# Purpose: Visualize ln(Body Mass) evolution under OU assumption  #
#################################################################

library(ape)
library(phytools)

# --- 2. LOAD DATA AND TREE ----------------------------------------

tree_full <- read.tree("../data/penguin_mcc.tre")


# Log-transformed Body Mass Data (ln(g)) for 17 Taxa
# This named vector defines the tips we want to keep.
log_mass_data <- c(
    "Aptenodytes_patagonicus" = 9.3700,
    "Aptenodytes_forsteri" = 10.4214,
    "Pygoscelis_papua" = 8.6883,
    "Pygoscelis_adeliae" = 8.4863,
    "Pygoscelis_antarcticus" = 8.3299,
    "Eudyptes_chrysocome" = 7.7527,
    "Eudyptes_pachyrhynchus" = 8.2700,
    "Eudyptes_robustus" = 8.0190,
    "Eudyptes_sclateri" = 8.6808,
    "Eudyptes_chrysolophus" = 8.4085,
    "Eudyptes_schlegeli" = 8.3529,
    "Megadyptes_antipodes" = 8.5804,
    "Eudyptula_minor" = 7.0101,
    "Spheniscus_demersus" = 8.0488,
    "Spheniscus_humboldti" = 8.3817,
    "Spheniscus_magellanicus" = 8.3200,
    "Spheniscus_mendiculus" = 7.5610
)

# --- 2. DYNAMIC PRUNING STEP ---

# 2a. Get the list of all tip names from the full tree
all_tips <- tree_full$tip.label

# 2b. Get the list of tips that we HAVE data for (the 17 species)
tips_with_data <- names(log_mass_data)

# 2c. Identify the tips that are in the full tree but NOT in our data (the ones to drop)
tips_to_drop <- setdiff(all_tips, tips_with_data)

# 2d. Prune the tree using the 'drop.tip' function from the 'ape' package
# The result is the final 'tree' object containing only 17 taxa.
tree <- drop.tip(tree_full, tips_to_drop)

print(paste("Pruned Tree Tip Count:", Ntip(tree)))

log_mass_data <- log_mass_data[tree$tip.label]

# --- 3. CREATE AND PLOT CONTINUOUS CHARACTER MAP ------------------

map_object <- contMap(
    tree, 
    log_mass_data, 
    plot = TRUE, 
    res = 200 # Resolution for a smoother color gradient
)

map_object <- setMap(map_object, c("blue", "red"))


# Plot the final visual
png(
    filename = "penguin_bodymass_contmap.png", 
    width = 1000 , 
    height = 1000, 
    res = 120 # Sets resolution for better quality
)
plot(
    map_object,
    type = "phylogram", # 'fan' for circular plot, 'phylogram' for rectangular
    legend = 0.7, # Length of the legend bar
    lwd = 3, # Branch line width (making the color clearer)
    fsize = 1.0, # Tip label font size
    sig = 2, # Decimal places on the legend
    outline = TRUE 
)

dev.off()

cat("Continuous character map saved as 'penguin_bodymass_contmap.png'\n")