# Load necessary libraries
library(ggplot2)
library(reshape2)
library(dplyr)
library(stringr)

# Set file names (update if needed)
file_prefix <- "filt3"  # Change to match your dataset
sample_file <- paste0(file_prefix, ".list")  # Sample names
q_files <- c(paste0(file_prefix, ".", 1:5, ".Q"))  # ADMIXTURE outputs
# Read sample names
samples <- read.table(sample_file, header = FALSE, stringsAsFactors = FALSE)
colnames(samples) <- c("Sample_ID")
# Function to process ADMIXTURE Q files
process_q_file <- function(q_file, k_value) {
  q_data <- read.table(q_file, header = FALSE)
  colnames(q_data) <- paste0("Cluster", 1:ncol(q_data))
  q_data$Sample <- samples$Sample  # Assign sample names
  q_data$K <- paste0("K=", k_value)
  return(q_data)
}

## SAMPLE CHECK ##
q <- read.table(q_files[1])
nrow(q)   # how many individuals ADMIXTURE has here

samples <- read.table("filt3.fam")
nrow(samples)   # how many individuals in metadata

## SAMPLE FIX ##
library(dplyr)

# List all your Q files
q_files <- list.files(pattern = "filt3.*\\.Q$")

# Function to process each Q file
process_q_file <- function(file, K) {
  q <- read.table(file, header = FALSE)
  fam <- read.table("filt3.fam")
  q$Sample <- fam$V2
  colnames(q)[1:K] <- paste0("Ancestry", 1:K)
  q$K <- K
  return(q)
}

# Apply to all files
q_list <- lapply(seq_along(q_files), function(i) {
  K <- as.numeric(sub(".*\\.(\\d+)\\.Q$", "\\1", q_files[i]))
  process_q_file(q_files[i], K)
})

# Combine into one data frame
q_all <- bind_rows(q_list)


# Read and combine results for all K
q_list <- lapply(1:length(q_files), function(i) process_q_file(q_files[i], i))
q_combined <- bind_rows(q_list)

# Load metadata
metadata <- read.table("metadata_all.txt", header = TRUE, stringsAsFactors = FALSE)

# Ensure column names match
colnames(metadata) <- c("Sample", "Population")

# Convert q_combined to long format for plotting
q_melted <- reshape2::melt(q_combined, id.vars = c("Sample", "K"), variable.name = "Cluster", value.name = "Ancestry")

# Merge with metadata
q_melted <- merge(q_melted, metadata, by = "Sample")

# Convert Population to a factor with the correct order
q_melted$Population <- factor(q_melted$Population, levels = c("SanMarcos","SanFelipe","Comal"))

# Melt Q matrix
q_melted <- reshape2::melt(q_combined,
                           id.vars = c("Sample", "K"),
                           variable.name = "Cluster",
                           value.name = "Ancestry")

# Merge with metadata
q_melted <- merge(q_melted, metadata, by = "Sample")

# Order samples by population
q_melted <- q_melted %>%
  group_by(Population) %>%
  mutate(Sample = factor(Sample, levels = unique(Sample))) %>%
  ungroup()

# Assign colors automatically by cluster count
n_clusters <- max(as.numeric(gsub("Ancestry", "", q_melted$Cluster)))
colors <- RColorBrewer::brewer.pal(max(3, n_clusters), "Set2")

# Keep only K = 1, 2, 3
q_melted_sub <- q_melted %>%
  filter(K %in% 1:3)
q_melted_sub$Population <- factor(q_melted_sub$Population, levels = c("SanMarcos","SanFelipe", "Comal"))


# Plot
p <- ggplot(q_melted_sub, aes(x = Sample, y = Ancestry, fill = Cluster)) +
  geom_bar(stat = "identity", width = 1) +
  facet_wrap(~ K, ncol = 1, scales = "free_x") +  # One row per K
  facet_grid(K ~ Population, scales = "free_x", space = "free_x") +  # Separate rows for K, group by Population
  scale_fill_manual(values = colors) +
  theme_minimal() +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        strip.text = element_text(size = 12, face = "bold"),
        panel.spacing = unit(0.5, "lines")) +
  labs(title = "ADMIXTURE results",
       x = "Individuals (grouped by population)",
       y = "Ancestry proportion",
       fill = "Cluster")
print(p)

