module load GCC/12.3.0 PLINK/2.00a3.7

VCF="merged_all_hypo.vcf.gz"

# perform linkage pruning - i.e. identify prune sites
plink --vcf $VCF --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--indep-pairwise 50 10 0.1 --out hypostomus_all

# prune and create pca
plink --vcf $VCF --double-id --allow-extra-chr --set-missing-var-ids @:# \
--extract hypostomus_TRUE.prune.in \
--make-bed --pca --out hypostomus_TRUE

## if issues arise with missing data, use this:
plink --bfile hypo_all_25 \
      --pca \
      --mind 1 \
      --out hypo_all_25_pca
