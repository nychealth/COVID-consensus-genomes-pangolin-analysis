# Lineage assignments using phylogenetic placement/UShER is superior to machine learning methods

This repository contains the New York City Public Health Laboratory local datasets for the paper, "Lineage assignments using phylogenetic placement/UShER is superior to machine learning methods." COVID samples were collected between August 01, 2021 and November 30, 2021. 


## Files:

* pipeline.txt - Overview of pipeline and associated scripts

Data files:


Fasta files can be directly inputted into any software that takes multi-fasta format such as [pangolin](https://github.com/cov-lineages/pangolin) or [Nextclade](https://clades.nextstrain.org/). This is not to be confused with multiple sequence alignment (MSA), which aligns the sequences against each other instead of just listing them.
* nyc_failed_aug-nov2021.fasta - Fasta file containing 469 genome consensus sequences for SARS-CoV-2 that had N >10%. 
* nyc_passed_aug-nov2021.fasta.xz - Compressed fasta file containing genome consensus sequences for SARS-CoV-2 that had N <10%. 
  - To uncompress with the xz-utils package, the command is `unxz nyc_passed_aug-nov2021.fasta.xz`
* 60k_public_meta.tsv - NCBI metadata for 2021 global dataset
* 2022-global-episet.pdf - GISAID supplemental table to access 2022 global dataset

Script files:
* adjusted_rand.R - R script to compute Adjusted Rand Index
* compareLineages.py - Python script to compare pangolin lineages to MAPLE tree
* snp_scorpio-comparisons.sh - Bash script to preprocess SNP distance matrix
* snp_scorpio-comparisons.Rmd - Script to analyze SNP distance matrix data and scorpio
* violin_plots.R - R script to create visualization to compare genome coverage to reassignment
* sankey_plots.R - R script to create visualization to look at lineage stability


# Authors

* Adriano de Bernardi Schneider
* Michelle Su
* Angie S. Hinrichs
* Jade Wang
* Helly Amin
* John Bell
* Debra A. Wadford
* Ainde O'Toole
* Emily Scher
* Marc D. Perry
* Yatish Turakhia
* Nicola De Maio
* Andrew Rambaut
* Scott Hughes
* Russ Corbett-Detig
