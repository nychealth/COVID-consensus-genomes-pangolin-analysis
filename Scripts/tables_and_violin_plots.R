library(dplyr)
library(tidyverse)
library(ggplot2)
library(hrbrthemes)
library(viridis)
library(RColorBrewer)
library(patchwork)

# Load file with all assignments for all versions

### BELOW 90 ###

setwd("/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/02_CA_below90_ref_coverage/summary_calls_CA_NY_dataset_below90")

myfile = read.csv("CA_NY_plearn_nohash_below90.csv", header = TRUE, sep=",")
nameofthefile = "CA_NY_plearn_nohash_below90"
joinfile = read.csv("/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/02_CA_below90_ref_coverage/summary_calls_below90_with_v4/pango_v4_plearn-nohash-under90.csv", header = TRUE, sep=",")
plearn_nohash_below90 = merge(myfile, joinfile[, c("taxon","lineage")], by="taxon")
colnames(plearn_nohash_below90)[6] <- c("V4")

write.csv(plearn_nohash_below90,file="/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/Coverage_analyses/non_permissible_changes/merged_below_above_coverage/merged_plearn_below90.csv")


myfile = read.csv("CA_NY_usher_nohash_below90.csv", header = TRUE, sep=",")
nameofthefile = "CA_NY_usher_nohash_below90"
joinfile = read.csv("/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/02_CA_below90_ref_coverage/summary_calls_below90_with_v4/pango_v4_usher-nohash-under90.csv", header = TRUE, sep=",")
usher_nohash_below90 = merge(myfile, joinfile[, c("taxon","lineage")], by="taxon")
colnames(usher_nohash_below90)[6] <- c("V4")

write.csv(usher_nohash_below90,file="/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/Coverage_analyses/non_permissible_changes/merged_below_above_coverage/merged_usher_below90.csv")


### ABOVE 90 ###

setwd("/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/01_CA_NY_dataset/summary_calls_CA_NY_dataset_above90")

myfile = read.csv("CA_NY_plearn_nohash_above90.csv", header = TRUE, sep=",")
nameofthefile = "CA_NY_plearn_nohash_above90"
joinfile = read.csv("/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/01_CA_NY_dataset/summary_calls_above90_with_v4/pango_v4_plearn-nohash-90plus.csv", header = TRUE, sep=",")
plearn_nohash_above90 = merge(myfile, joinfile[, c("taxon","lineage")], by="taxon")
colnames(plearn_nohash_above90)[6] <- c("V4")

write.csv(plearn_nohash_above90,file="/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/Coverage_analyses/non_permissible_changes/merged_below_above_coverage/merged_plearn_above90.csv")


myfile = read.csv("CA_NY_usher_nohash_above90.csv", header = TRUE, sep=",")
nameofthefile = "CA_NY_usher_nohash_above90"
joinfile = read.csv("/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/01_CA_NY_dataset/summary_calls_above90_with_v4/pango_v4_usher-nohash-90plus.csv", header = TRUE, sep=",")
usher_nohash_above90 = merge(myfile, joinfile[, c("taxon","lineage")], by="taxon")
colnames(usher_nohash_above90)[6] <- c("V4")

write.csv(usher_nohash_above90,file="/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/Coverage_analyses/non_permissible_changes/merged_below_above_coverage/merged_usher_above90.csv")


### MERGE ABOVE AND BELOW 90 ###

setwd("/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/Coverage_analyses/non_permissible_changes/merged_below_above_coverage/")

myfile = read.csv("merged_usher_above90.csv", header = TRUE, sep=",")
joinfile = read.csv("merged_usher_below90.csv", header = TRUE, sep=",")
usher_nohash = full_join(myfile, joinfile)

write.csv(usher_nohash,file="/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/Coverage_analyses/non_permissible_changes/merged_below_above_coverage/merged_usher_all.csv")

myfile = read.csv("merged_plearn_above90.csv", header = TRUE, sep=",")
joinfile = read.csv("merged_plearn_below90.csv", header = TRUE, sep=",")
plearn_nohash = full_join(myfile, joinfile)

write.csv(plearn_nohash,file="/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/Coverage_analyses/non_permissible_changes/merged_below_above_coverage/merged_plearn_all.csv")


### METADATA ###

merged_metadata = read.csv("/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/Coverage_analyses/non_permissible_changes/merged_below_above_coverage/merged_metadata.csv",header=TRUE,sep=",")
colnames(merged_metadata)[1]="taxon"

# Merge metadata with list of calls for all lineages and count number of unique calls (total number of unique columns minus 2 = taxon + ref coverage columns)

merged_metadata_usher = right_join(usher_nohash, merged_metadata[, c("taxon","ref_coverage")], by="taxon")
merged_metadata_usher$unique = apply(merged_metadata_usher,1,function(x) length(unique(x)))-3

merged_metadata_plearn = right_join(plearn_nohash, merged_metadata[, c("taxon","ref_coverage")], by="taxon")
merged_metadata_plearn$unique = apply(merged_metadata_plearn,1,function(x) length(unique(x)))-3




### Non-permissible vs genome coverage and vs parsimony

expected_v1_v2 = read.csv("/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/00_public_dataset_60k/Expected_calls_between_versions/expected.13.14.tsv", header = TRUE, sep="\t")
expected_v1_v2 = expected_v1_v2 %>% unite("merged", "source":"target", remove = FALSE)

expected_v2_v3 = read.csv("/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/00_public_dataset_60k/Expected_calls_between_versions/expected.14.15.tsv", header = TRUE, sep="\t")
expected_v2_v3 = expected_v2_v3 %>% unite("merged", "source":"target", remove = FALSE)

expected_v3_v4 = read.csv("/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/00_public_dataset_60k/Expected_calls_between_versions/expected.15.16.tsv", header = TRUE, sep="\t")
expected_v3_v4 = expected_v3_v4 %>% unite("merged", "source":"target", remove = FALSE)

expected_v4_v5 = read.csv("/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/00_public_dataset_60k/Expected_calls_between_versions/expected.2021-11-09_v1.2.133.tsv", header = TRUE, sep="\t")
expected_v4_v5 = expected_v4_v5 %>% unite("merged", "source":"target", remove = FALSE)


# select and merge columns v1 v2 / v2 v3 / v3 v4 and v4 v5
# count unique and add count to new column
# if value in list of expected add "expected" else add "unexpected"
plearn_nohash
usher_nohash

### Final table for pusher


usher_v1v2 = data.frame(usher_nohash$taxon,usher_nohash$PUSHER.v1.2.76,usher_nohash$PUSHER.v1.2.81)
usher_v1v2 = usher_v1v2 %>% unite("merged", "usher_nohash.PUSHER.v1.2.76":"usher_nohash.PUSHER.v1.2.81", remove = FALSE)
usher_v1v2$v1v2 = ifelse(as.character(usher_v1v2$usher_nohash.PUSHER.v1.2.76) == as.character(usher_v1v2$usher_nohash.PUSHER.v1.2.81), "expected", 
                               ifelse(as.character(usher_v1v2$merged) %in% as.character(expected_v1_v2$merged), "expected", "unexpected"))

usher_v2v3 = data.frame(usher_nohash$taxon,usher_nohash$PUSHER.v1.2.81, usher_nohash$PUSHER.v1.2.88)
usher_v2v3 = usher_v2v3 %>% unite("merged", "usher_nohash.PUSHER.v1.2.81":"usher_nohash.PUSHER.v1.2.88", remove = FALSE)
usher_v2v3$v2v3 = ifelse(as.character(usher_v2v3$usher_nohash.PUSHER.v1.2.81) == as.character(usher_v2v3$usher_nohash.PUSHER.v1.2.88), "expected", 
                               ifelse(as.character(usher_v2v3$merged) %in% as.character(expected_v2_v3$merged), "expected", "unexpected"))

usher_v3v4 = data.frame(usher_nohash$taxon,usher_nohash$PUSHER.v1.2.88,usher_nohash$PUSHER.v1.2.93)
usher_v3v4 = usher_v3v4 %>% unite("merged", "usher_nohash.PUSHER.v1.2.88":"usher_nohash.PUSHER.v1.2.93", remove = FALSE)
usher_v3v4$v3v4 = ifelse(as.character(usher_v3v4$usher_nohash.PUSHER.v1.2.88) == as.character(usher_v3v4$usher_nohash.PUSHER.v1.2.93), "expected", 
                               ifelse(as.character(usher_v3v4$merged) %in% as.character(expected_v3_v4$merged), "expected", "unexpected"))

usher_v4v5 = data.frame(usher_nohash$taxon,usher_nohash$PUSHER.v1.2.93,usher_nohash$V4)
usher_v4v5 = usher_v4v5 %>% unite("merged", "usher_nohash.PUSHER.v1.2.93":"usher_nohash.V4", remove = FALSE)
usher_v4v5$v4v5 = ifelse(as.character(usher_v4v5$usher_nohash.PUSHER.v1.2.93) == as.character(usher_v4v5$usher_nohash.V4), "expected", 
                               ifelse(as.character(usher_v4v5$merged) %in% as.character(expected_v4_v5$merged), "expected", "unexpected"))

genome_coverage = read.csv("/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/Coverage_analyses/non_permissible_changes/merged_below_above_coverage/merged_metadata.csv",header=TRUE,sep=",")
colnames(genome_coverage)[1] = "usher_nohash.taxon"

pusher_combined = merge(usher_v1v2,usher_v2v3[,c("usher_nohash.taxon","v2v3")], by="usher_nohash.taxon")
pusher_combined = merge(pusher_combined,usher_v3v4[,c("usher_nohash.taxon","v3v4")], by="usher_nohash.taxon")
pusher_combined = merge(pusher_combined,usher_v4v5[,c("usher_nohash.taxon","v4v5")], by="usher_nohash.taxon")
pusher_combined = merge(pusher_combined,genome_coverage[,c("usher_nohash.taxon","ref_coverage")])
pusher_combined = merge(pusher_combined,genome_coverage[,c("usher_nohash.taxon","ref_coverage")])
pusher_combined = pusher_combined %>% select("usher_nohash.taxon", "ref_coverage", "v1v2", "v2v3", "v3v4","v4v5")
pusher_combined$no_unexpected <- rowSums(pusher_combined == "unexpected")

colnames(merged_metadata_usher)[1] = "index"
colnames(merged_metadata_usher)[2] = "usher_nohash.taxon"

pusher_combined = merge(pusher_combined,merged_metadata_usher[,c("usher_nohash.taxon","unique")], by="usher_nohash.taxon")
table(pusher_combined$no_unexpected)
table(pusher_combined$unique)

### Final table for plearn

plearn_v1v2 = data.frame(plearn_nohash$taxon,plearn_nohash$PLEARN.v1.2.76,plearn_nohash$PLEARN.v1.2.81)
plearn_v1v2 = plearn_v1v2 %>% unite("merged", "plearn_nohash.PLEARN.v1.2.76":"plearn_nohash.PLEARN.v1.2.81", remove = FALSE)
plearn_v1v2$v1v2 = ifelse(as.character(plearn_v1v2$plearn_nohash.PLEARN.v1.2.76) == as.character(plearn_v1v2$plearn_nohash.PLEARN.v1.2.81), "expected", 
                         ifelse(as.character(plearn_v1v2$merged) %in% as.character(expected_v1_v2$merged), "expected", "unexpected"))

plearn_v2v3 = data.frame(plearn_nohash$taxon,plearn_nohash$PLEARN.v1.2.81, plearn_nohash$PLEARN.v1.2.88)
plearn_v2v3 = plearn_v2v3 %>% unite("merged", "plearn_nohash.PLEARN.v1.2.81":"plearn_nohash.PLEARN.v1.2.88", remove = FALSE)
plearn_v2v3$v2v3 = ifelse(as.character(plearn_v2v3$plearn_nohash.PLEARN.v1.2.81) == as.character(plearn_v2v3$plearn_nohash.PLEARN.v1.2.88), "expected", 
                         ifelse(as.character(plearn_v2v3$merged) %in% as.character(expected_v2_v3$merged), "expected", "unexpected"))

plearn_v3v4 = data.frame(plearn_nohash$taxon,plearn_nohash$PLEARN.v1.2.88,plearn_nohash$PLEARN.v1.2.93)
plearn_v3v4 = plearn_v3v4 %>% unite("merged", "plearn_nohash.PLEARN.v1.2.88":"plearn_nohash.PLEARN.v1.2.93", remove = FALSE)
plearn_v3v4$v3v4 = ifelse(as.character(plearn_v3v4$plearn_nohash.PLEARN.v1.2.88) == as.character(plearn_v3v4$plearn_nohash.PLEARN.v1.2.93), "expected", 
                         ifelse(as.character(plearn_v3v4$merged) %in% as.character(expected_v3_v4$merged), "expected", "unexpected"))

plearn_v4v5 = data.frame(plearn_nohash$taxon,plearn_nohash$PLEARN.v1.2.93,plearn_nohash$V4)
plearn_v4v5 = plearn_v4v5 %>% unite("merged", "plearn_nohash.PLEARN.v1.2.93":"plearn_nohash.V4", remove = FALSE)
plearn_v4v5$v4v5 = ifelse(as.character(plearn_v4v5$plearn_nohash.PLEARN.v1.2.93) == as.character(plearn_v4v5$plearn_nohash.V4), "expected", 
                         ifelse(as.character(plearn_v4v5$merged) %in% as.character(expected_v4_v5$merged), "expected", "unexpected"))

genome_coverage = read.csv("/Users/schneider/Documents/Projects/UCSC_Postdoc/01_Pusher_vs_Pangolearn/Peer_Review/Coverage_analyses/non_permissible_changes/merged_below_above_coverage/merged_metadata.csv",header=TRUE,sep=",")
colnames(genome_coverage)[1] = "plearn_nohash.taxon"

plearn_combined = merge(plearn_v1v2,plearn_v2v3[,c("plearn_nohash.taxon","v2v3")], by="plearn_nohash.taxon")
plearn_combined = merge(plearn_combined,plearn_v3v4[,c("plearn_nohash.taxon","v3v4")], by="plearn_nohash.taxon")
plearn_combined = merge(plearn_combined,plearn_v4v5[,c("plearn_nohash.taxon","v4v5")], by="plearn_nohash.taxon")
plearn_combined = merge(plearn_combined,genome_coverage[,c("plearn_nohash.taxon","ref_coverage")])
plearn_combined = merge(plearn_combined,genome_coverage[,c("plearn_nohash.taxon","ref_coverage")])
plearn_combined = plearn_combined %>% select("plearn_nohash.taxon", "ref_coverage", "v1v2", "v2v3", "v3v4","v4v5")
plearn_combined$no_unexpected <- rowSums(plearn_combined == "unexpected")

colnames(merged_metadata_plearn)[1] = "index"
colnames(merged_metadata_plearn)[2] = "plearn_nohash.taxon"

plearn_combined = merge(plearn_combined,merged_metadata_plearn[,c("plearn_nohash.taxon","unique")], by="plearn_nohash.taxon")
table(plearn_combined$no_unexpected)
table(plearn_combined$unique)

cor.test(plearn_combined$ref_coverage,plearn_combined$no_unexpected,method="pearson")

### Final plots

violin_pusher = pusher_combined %>% select("usher_nohash.taxon","ref_coverage","unique","no_unexpected")
violin_pusher$unique = as.factor(violin_pusher$unique)
violin_pusher$no_unexpected = as.factor(violin_pusher$no_unexpected)
violin_plearn = plearn_combined %>% select("plearn_nohash.taxon","ref_coverage","unique","no_unexpected")
violin_plearn$unique = as.factor(violin_plearn$unique)
violin_plearn$no_unexpected = as.factor(violin_plearn$no_unexpected)

violin_pusher <- subset(violin_pusher, ref_coverage<0.90)
violin_plearn <- subset(violin_plearn, ref_coverage<0.90)

violin_pusher <- subset(violin_pusher, ref_coverage>0.89999)
violin_plearn <- subset(violin_plearn, ref_coverage>0.89999)


box_A <- ggplot(violin_pusher, aes(x=unique, y=ref_coverage)) + 
  geom_violin(fill=c("#999999")) + labs(title = "pUShER", x = "Lineage assignments", y = "Genome coverage (%)")
box_A = box_A + geom_boxplot(width=0.1,outlier.size = 0) + theme_classic(base_size = 16)

box_B <- ggplot(violin_pusher, aes(x=no_unexpected, y=ref_coverage)) + 
  geom_violin(fill=c("#999999")) + labs(title = "pUShER", x = "Non-permitted lineage changes", y = "Genome coverage (%)")
box_B = box_B + geom_boxplot(width=0.1,outlier.size = 0) + theme_classic(base_size = 16)

box_C <- ggplot(violin_plearn, aes(x=unique, y=ref_coverage)) + 
  geom_violin(fill=c("#999999")) + labs(title = "pangoLEARN", x = "Lineage assignments", y = "Genome coverage (%)")
box_C = box_C + geom_boxplot(width=0.1,outlier.size = 0) + theme_classic(base_size = 16)

box_D <- ggplot(violin_plearn, aes(x=no_unexpected, y=ref_coverage)) + 
  geom_violin(fill=c("#999999")) + labs(title = "pangoLEARN", x = "Non-permitted lineage changes", y = "Genome coverage (%)")
box_D = box_D + geom_boxplot(width=0.1,outlier.size = 0) + theme_classic(base_size = 16)

patched <- (box_A + box_B) / (box_C + box_D)
patched

ppatched + plot_annotation(tag_levels = 'A')