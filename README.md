# SAC_TPWD_WGS

This is a repository for scripts used by Wynne V. Radcliffe to process raw suckermouth armoured catfish genomic data. Primary goals of the project were identifying sex-determining regions and characterizing population genetic structure. 

########################################################################################################

Step 1: Raw reads concatenated, quality checked with FastQC, and processed with CutAdapt and Trimmomatic. 

*files should end in _R1.fastq.gz and _R2.fastq.gz*

########################################################################################################

*ALL STEPS CAN BE AND WERE REPLICATED WITH OTHER SAMPLE SETS, JUST REPLACE NAMES*

########################################################################################################

Step 2: Reads were aligned to either a *Pterygoplichthys* pardalis reference genome or a de novo hifiasm *Hypostomus* sp. assembly. 

The script make_align.sh will generate jobs (a list of commands, one for each sample) that can be specified in the array script array_map.sh. Run the following command to get the list of commands which will be used for alignment:

./make_align_comal.sh > raw_comal_commands.txt

Run alignment using align_array.sh

*files should end in _raw.bam*

########################################################################################################

Step 3: Mark duplicates and add read groups

For each raw bam file generated in Step 2, use picard to mark duplicates and add read group (i.e. sample name).

Again need to generate a list of commands to feed into an array script:

a) ./make_picard_jobs_rgadd.sh > rgadd_commands.txt

b) ./make_picard_jobs_dups.sh > dups_commands.txt

Run commands files using run_picard.sh

*files should end in _rgadd.bam for (a) and _dupsmarked.bam for (b)*
########################################################################################################

Step 4: Split bams into mapped and unmapped reads >> split_reads.sh

Use samtools view to split bams from Step 3 (dups marked and read groups added)into mapped and unmapped reads. We will use the bams with mapped reads only in the next step.

*all mapped-reads-only bam files will end in _mapped.bam and all unmapped-reads-only bam files will end in _unmapped.bam*
########################################################################################################

Step 5: Step 5: Haplotype calling >> haplotype_caller.sh

Used mapped bams for gatk haplotype caller.

*will create a series of files, one per individual, ending in .g.vcf*
########################################################################################################

Step 6: Combine individual .g.vcf files into one "cohort" gvcf for genotyping >> combine_gvcfs.sh

########################################################################################################

Step 7: GenotypeGVCFs 

Run genotype_gvcf.sh on cohort_combined.g.vcf . 

*OPTIONAL GENOTYPING FOR INDIVIDUAL G.VCF IF ABOVE DOES NOT WORK*

genotype_single.sh >> change intervals in .fof file each time

########################################################################################################

Step 8: VCF processing

Subset for MONOMORPHIC SITES, SNPS, and MIXED/INDELS LOCI >> subset.sh

*files will end in _mono_subset.vcf, _snps_subset.vcf, and _mixed_indels_subset.vcf*

Apply hard-filter flags to sites from subset files >> filter.sh

*files will end in _mono_filtered.vcf, _snps_filtered.vcf, and _mixed_indels_filtered.vcf*

Keep only biallelic variants and remove those with MAF < 0.01  >> biallelic_maf.sh (loops through all vcf files in a given directory)

*files will end in _snps_filtered_PASS_ONLY_biallelic.vcf and _snps_filtered_PASS_ONLY_biallelic_nolowmaf.vcf*

########################################################################################################

*OPTIONAL VERSION OF STEP 8 IF RUNNING INTO ISSUES*

concat_filter_thin.sh >> concatenates all raw vcf files into one large VCF file, runs command to keep only biallelic SNPs, then thins to 1kb 

########################################################################################################

Step 9: Combine all processed VCF files into one large VCF.

########################################################################################################

Step 10: Sex Association and Population Genomics 

*SEX ASSOCIATION*

a) make_input_step1.sh >> produces .map and .ped files

b) make_input_step2.sh >> produces .bam, .bed, and .fam files

c) sex_association.sh >> output file is .assoc.txt, which is what will be used to plot

*POPGEN*

a) Create input files (can do in another directory to prevent confusion with Sex Association files) >> make_admix_inputs.sh 

*produces .fam, .bed, .bim*

PCA: 

a) Calculate matrices >> hypo_pca.sh

b) Plot PCA results >> hypo_pca.R (if running in cluster, see run_script.sh)

ADMIXTURE:

a) Install ADMIXTURE >> newest cluster we used did not have it as module

b) Filter for any individuals with missing data >> filter_admix.sh

c) Run ADMIXTURE >> run_admix.sh 

*one line of run_admix.sh per K value - i.e., if you want to do from K=1 to K=10, must have 10 lines in run-admix.sh*

d) Plot results >> admixture.R (if running in cluster, see run_script.sh)
