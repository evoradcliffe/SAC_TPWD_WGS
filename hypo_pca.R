# load tidyverse package
library(tidyverse)

# read in data
pca <- read_table("hypo_all_25.eigenvec", col_names=FALSE)
eigenval <- scan("hypo_all_25.eigenval")
percent_var <- round(100 * eigenval / sum(eigenval), 2)

# sort out the pca data
# remove nuisaence column
pca <- pca[,-1]
# set names
names(pca)[1] <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))

# Extract population names (e.g., "SanFelipe" or "SanMarcos")
pop <- rep(NA, length(pca$ind))
pop[grep("SanMarcos", pca$ind)] <- "SanMarcos"
pop[grep("SanFelipe", pca$ind)] <- "SanFelipe"
pop[grep("Comal", pca$ind)] <- "Comal"

# Extract sex (Male/Female)
sex <- rep(NA, length(pca$ind))
sex[grep("-m[0-9]+$", pca$ind)] <- "Male"
sex[grep("-f[0-9]+$", pca$ind)] <- "Female"

sex <- gsub("fu", "Female", sex)  # Replace "fu" with "Female"
sex <- as.factor(sex)  # Ensure it's a factor again

# Convert to factors for ggplot aesthetics
pop <- as.factor(pop)
sex <- as.factor(sex)
## Add pop and sex to PCA dataframe
pca$pop <- pop
pca$sex <- sex

# Create combined Population × Sex group
pca$group <- paste(pca$pop, pca$sex, sep = "_")

# Define custom shades for Pop × Sex
color_map <- c(
  "Comal_Male"       = "#6A3D9A",   # darker purple
  "Comal_Female"     = "#CAB2D6",   # lighter purple
  "SanFelipe_Male"   = "#33A02C",   # darker green
  "SanFelipe_Female" = "#B2DF8A",   # lighter green
  "SanMarcos_Male"   = "#FE7F9C",   # darker red-pink
  "SanMarcos_Female" = "#FCBACB"    # lighter pink
)

ggplot(pca, aes(x = PC1, y = PC2, color = group, shape = sex)) +
  geom_point(size = 5) +
  theme_minimal() +
  labs(
    x = paste0("PC1 (", percent_var[1], "%)"),
    y = paste0("PC2 (", percent_var[2], "%)"),
    color = "Population × Sex",
    shape = "Sex"
  ) +
  scale_color_manual(values = color_map) +
  scale_shape_manual(values = c("Male" = 16, "Female" = 17)) +
  theme(
    axis.text.x = element_text(size = 14),  # increase x-axis numbers
    axis.text.y = element_text(size = 14)   # increase y-axis numbers
  )


## STATS ##
library(vegan)

# Combine PCA data with population info
pca$pop <- pop

# Test using the first 5 PCs (adjust as needed)
adonis_result <- adonis2(pca[,1:2] ~ pop, data = pca, method = "euclidean")
print(adonis_result)

summary(aov(PC1 ~ pop, data = pca))
summary(aov(PC2 ~ pop, data = pca))
library(vegan)

# Make sure PC1 and PC2 are numeric
pca$PC1 <- as.numeric(pca$PC1)
pca$PC2 <- as.numeric(pca$PC2)

# Remove any rows with NA
pca_clean <- pca[complete.cases(pca[, c("PC1", "PC2", "pop")]), ]

# Run PERMANOVA using adonis2 (the new version)
adonis2_result <- adonis2(cbind(pca$PC1, pca$PC2) ~ pop, data = pca_clean, method = "euclidean")
print(adonis2_result)
