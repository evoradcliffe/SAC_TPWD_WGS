module load GCC/13.2.0 VCFtools/0.1.16

vcftools --vcf combined_hypostomus_populations.vcf --out hypostomus_TRUE --plink
#load modules and dependencies
module load GCC/12.3.0 PLINK/2.00a3.7
#make .bed .bim .fam files
plink --file hypostomus_TRUE --pheno sex_pheno_hypo.txt --pheno-name Sex --make-bed --out hypostomus_TRUE
#
#check the output files: awk '{print $2, $6}' ot.fam
#male = 2 and female = 1
