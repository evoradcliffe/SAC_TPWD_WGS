# Load necessary libraries
library(ggplot2)
library(reshape2)
library(dplyr)
library(stringr)

# Set file names (update if needed)
file_prefix <- "hypo_all_25_filtered"  # Change to match your dataset
sample_file <- paste0(file_prefix, ".list")  # Sample names
q_files <- c(paste0(file_prefix, ".", 1:3, ".Q"))  # ADMIXTURE outputs
#q_files <- c(paste0(file_prefix, ".3.Q"))
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

# Read and combine results for all K
q_list <- lapply(1:length(q_files), function(i) process_q_file(q_files[i], i))
q_combined <- bind_rows(q_list)

# Load metadata
metadata <- read.table("metadata (1).txt", header = TRUE, stringsAsFactors = FALSE)

# Ensure column names match
colnames(metadata) <- c("Sample", "Population")

# Convert q_combined to long format for plotting
q_melted <- reshape2::melt(q_combined, id.vars = c("Sample", "K"), variable.name = "Cluster", value.name = "Ancestry")

# Merge with metadata
q_melted <- merge(q_melted, metadata, by = "Sample")

# Convert Population to a factor with the correct order
q_melted$Population <- factor(q_melted$Population, levels = c("SanMarcos","SanFelipe","Comal"))

# Compute individual positions for vertical lines
sample_positions <- unique(q_melted$Sample)
line_positions <- seq(1.5, length(sample_positions) + 0.5, by = 1)

# Plot with grouped populations
p <- ggplot(q_melted, aes(x = Sample, y = Ancestry, fill = Cluster)) +
  geom_bar(stat = "identity", width = 1) +
  facet_grid(K ~ Population, scales = "free_x", space = "free_x") +  # Separate rows for K, group by Population
  scale_fill_manual(values = c("darkblue" ,"#21b0fe","lightgreen")) + 
  geom_vline(xintercept = line_positions, color = "black", size = 0.3) +  # Vertical lines
  theme_minimal() +
  theme(axis.text.x = element_blank(),  # Hide sample labels for clarity
        axis.ticks.x = element_blank(),
        strip.text = element_text(size = 12, face = "bold"),
        panel.spacing.x = unit(0.5, "lines")) +  # Adjust spacing between populations
  labs(title = "ADMIXTURE", x = "Population", y = "Ancestry Proportion", fill = "Cluster")
print(p)
