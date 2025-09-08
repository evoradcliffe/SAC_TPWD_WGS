module load GCC/12.3.0 PLINK/2.00a3.7

plink --bfile /home/wrad07/moranlab/shared/SAC_TPWD/gvcfs/hypo_all_25_filtered --geno 0.05 --mind 1 --maf 0.01 --make-bed --out filt3

## removes any data with 100% missing data ##

plink --bfile filt3 --freq --missing --out filt3_qc_check

## can check how many variants remain, which individuals, etc.
