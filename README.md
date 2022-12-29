# Lineage assignments using phylogenetic placement/UShER is superior to machine learning methods

This repository contains the New York City Public Health Laboratory local datasets for the paper, "Lineage assignments using phylogenetic placement/UShER is superior to machine learning methods." COVID samples were collected between August 01, 2021 and November 30, 2021. 


## Files:

* nyc_failed_aug-nov2021.fasta - Fasta file containing 469 genome consensus sequences for SARS-CoV-2 that had N >10%. 
* nyc_passed_aug-nov2021.fasta.xz - Compressed fasta file containing genome consensus sequences for SARS-CoV-2 that had N <10%. 
  - To uncompress with the xz-utils package, the command is `unxz nyc_passed_aug-nov2021.fasta.xz`

This data can be directly inputted into any software that takes multi-fasta format such as [pangolin](https://github.com/cov-lineages/pangolin) or [Nextclade](https://clades.nextstrain.org/). This is not to be confused with multiple sequence alignment (MSA), which aligns the sequences against each other instead of just listing them.

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
