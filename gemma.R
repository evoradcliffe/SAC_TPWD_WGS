library(qqman)
library(ggplot2)

# Load GEMMA output
ot_all <- read.table("chr_processed_allo_rb_assoc.txt", header = TRUE)

# Ensure chromosome is numeric
# Remove "chr" prefix if present, and convert to numeric
ot_all$chr <- as.numeric(gsub("chr", "", ot_all$chr))

# Filter out chr == 0
ot_all <- subset(ot_all, chr != 0)

# Create SNP index
SNP <- seq_len(nrow(ot_all))
ot_dat <- data.frame(SNP, ot_all)

# Clean data
ot_dat_clean <- ot_dat[is.finite(ot_dat$p_wald) & !is.na(ot_dat$p_wald), ]

# Manhattan plot with alternating colors
manhattan(ot_dat_clean,
          chr = "chr",
          bp = "ps",
          p = "p_wald",
          snp = "SNP",
          logp = TRUE,
          ylab = "-log10(p-value)",
          suggestiveline = FALSE,
          genomewideline = -log10(5e-08),
          ylim = c(0, 15),
          col = c("black", "grey"))  # Alternating colors
