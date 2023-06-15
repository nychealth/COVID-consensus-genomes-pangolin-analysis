##### NECESSARY FILES #####
# In order for the user to run this script, they will need to have 6 files in place:
# Two files with the sequence assignments for all versions, one for all four of pangolin v3 and one for pangolin v4 (which will be merged in the first step), labeled dataset_v3.csv and dataset_v4.csv.
# Four files indicating the expected changes accross different versions of pangolin, labeled expected.13.14.tsv; expected.14.15.tsv; expected.15.16.tsv and expected.2021-11-09_v1.2.133.tsv.

setwd("/summary_calls")

library(dplyr)
library(tidyverse)

# Load file with all assignments for all versions

### DATASET ###

myfile = read.csv("dataset_v3.csv", header = TRUE, sep=",")
nameofthefile = "name_of_dataset"
joinfile = read.csv("dataset_v4.csv", header = TRUE, sep=",")
myfile = merge(myfile, joinfile[, c("taxon","lineage")], by="taxon")
colnames(myfile)[6] <- c("V4")

# Extract individual counts for all versions in three separate files

v1v2 = myfile %>% count(myfile[,2], myfile[,3])
v2v3 = myfile %>% count(myfile[,3], myfile[,4])
v3v4 = myfile %>% count(myfile[,4], myfile[,5])
v4v5 = myfile %>% count(myfile[,5], myfile[,6])

# Rename column names to versions

colnames(v1v2) <- c("v1","v2","n")
colnames(v2v3) <- c("v2","v3","n")
colnames(v3v4) <- c("v3","v4","n")
colnames(v4v5) <- c("v4","v5","n")

# Create an index list for the sequences

index1 = as.list(0:((nrow(myfile %>% count(myfile[,2])))-1)) #Take -1 since it starts at 0.
index2 = as.list(last(index1)+1:nrow(myfile %>% count(myfile[,3])))
index3 = as.list(last(index2)+1:nrow(myfile %>% count(myfile[,4])))
index4 = as.list(last(index3)+1:nrow(myfile %>% count(myfile[,5])))
index5 = as.list(last(index4)+1:nrow(myfile %>% count(myfile[,6])))


index1 = unlist(index1)
list1 = as.tibble(unique(myfile[,2]))
v1_indexed = cbind(list1,index1)
colnames(v1_indexed)[1] <- c("v1")

index2 = unlist(index2)
list2 = as.tibble(unique(myfile[,3]))
v2_indexed = cbind(list2,index2)
colnames(v2_indexed)[1] <- c("v2")

index3 = unlist(index3)
list3 = as.tibble(unique(myfile[,4]))
v3_indexed = cbind(list3,index3)
colnames(v3_indexed)[1] <- c("v3")

index4 = unlist(index4)
list4 = as.tibble(unique(myfile[,5]))
v4_indexed = cbind(list4,index4)
colnames(v4_indexed)[1] <- c("v4")

index5 = unlist(index5)
list5 = as.tibble(unique(myfile[,6]))
v5_indexed = cbind(list5,index5)
colnames(v5_indexed)[1] <- c("v5")

# Merge indexes with individual pairs of v1/v2 v2/v3 and v3/v4

v1_table = merge(v1v2, v1_indexed[, c("v1","index1")], by="v1")
v1_table = merge(v1_table, v2_indexed[, c("v2","index2")], by="v2")

v2_table = merge(v2v3, v2_indexed[, c("v2","index2")], by="v2")
v2_table = merge(v2_table, v3_indexed[, c("v3","index3")], by="v3")

v3_table = merge(v3v4, v3_indexed[, c("v3","index3")], by="v3")
v3_table = merge(v3_table, v4_indexed[, c("v4","index4")], by="v4")

v4_table = merge(v4v5, v4_indexed[, c("v4","index4")], by="v4")
v4_table = merge(v4_table, v5_indexed[, c("v5","index5")], by="v5")

# Load lists of expected changes across versions

expected_v1_v2 = read.csv("expected.13.14.tsv", header = TRUE, sep="\t")
expected_v2_v3 = read.csv("expected.14.15.tsv", header = TRUE, sep="\t")
expected_v3_v4 = read.csv("expected.15.16.tsv", header = TRUE, sep="\t")
expected_v4_v5 = read.csv("expected.2021-11-09_v1.2.133.tsv", header = TRUE, sep="\t")

# if "none to none" print expected else, follow expected sheets.

## V1 ##
v1_table$v1 = as.character(v1_table$v1)
v1_table$v2 = as.character(v1_table$v2)
ifelse(v1_table$v1=="None","Expected","Unexpected")

v1_table$concat = paste(v1_table$v1,v1_table$v2)
expected_v1_v2$concat = paste(expected_v1_v2$source,expected_v1_v2$target)

## V2 ##
v2_table$v2 = as.character(v2_table$v2)
v2_table$v3 = as.character(v2_table$v3)
ifelse(v2_table$v2=="None","Expected","Unexpected")

v2_table$concat = paste(v2_table$v2,v2_table$v3)
expected_v2_v3$concat = paste(expected_v2_v3$source,expected_v2_v3$target)

## V3 ##
v3_table$v3 = as.character(v3_table$v3)
v3_table$v4 = as.character(v3_table$v4)
ifelse(v3_table$v3=="None","Expected","Unexpected")

v3_table$concat = paste(v3_table$v3,v3_table$v4)
expected_v3_v4$concat = paste(expected_v3_v4$source,expected_v3_v4$target)

## V4 ##
v4_table$v4 = as.character(v4_table$v4)
v4_table$v5 = as.character(v4_table$v5)
ifelse(v4_table$v4=="None","Expected","Unexpected")

v4_table$concat = paste(v4_table$v4,v4_table$v5)
expected_v4_v5$concat = paste(expected_v4_v5$source,expected_v4_v5$target)

### Create empty matrix to build dataframe of expected and unexpected changes ###

## V1 ##

tempconcat <- data.frame(matrix(ncol = 2, nrow = 0))
x <- c("concat","expected")
colnames(tempconcat) <- x

# first loop creates table of all expected as everything that is equal, and everything that is unequal is called unexpected

for (i in 1:nrow(v1_table)) {
  if (v1_table$v1[i]==v1_table$v2[i]) {
  output <- data.frame(concat = v1_table$concat[i],expected="expected")
  tempconcat = rbind(tempconcat,output)}
  else
  {
    output <- data.frame(concat = v1_table$concat[i],expected="unexpected")
    tempconcat = rbind(tempconcat,output)}
}

# Create second empty matrix to fix unexpected changes that are actual expected changes due to version changes in the software

tempconcat2 <- data.frame(matrix(ncol = 2, nrow = 0))
x <- c("concat","expected")
colnames(tempconcat2) <- x

# Second loop creates matrix of expected changes between different versions

for (p in v1_table$concat) {
  for (i in expected_v1_v2$concat) {
    if (i==p)
    {
      output <- data.frame(concat = i,expected="expected")
      tempconcat2 = rbind(tempconcat2,output)}
    else
      next
  }}

# Merges expected changes of two previous dataframes and replaces "unexpected" values with "expected" for the valid ones (second dataframe)

tempconcat$expected[match(tempconcat2$concat, tempconcat$concat)] <- tempconcat2$expected

v1_table = merge(v1_table, tempconcat[, c("concat","expected")], by="concat")

## V2 ##

tempconcat <- data.frame(matrix(ncol = 2, nrow = 0))
x <- c("concat","expected")
colnames(tempconcat) <- x

# first loop creates table of all expected as everything that is equal, and everything that is unequal is called unexpected

for (i in 1:nrow(v2_table)) {
  if (v2_table$v2[i]==v2_table$v3[i]) {
    output <- data.frame(concat = v2_table$concat[i],expected="expected")
    tempconcat = rbind(tempconcat,output)}
  else
  {
    output <- data.frame(concat = v2_table$concat[i],expected="unexpected")
    tempconcat = rbind(tempconcat,output)}
}

# Create second empty matrix to fix unexpected changes that are actual expected changes due to version changes in the software

tempconcat2 <- data.frame(matrix(ncol = 2, nrow = 0))
x <- c("concat","expected")
colnames(tempconcat2) <- x

# Second loop creates matrix of expected changes between different versions

for (p in v2_table$concat) {
  for (i in expected_v2_v3$concat) {
    if (i==p)
    {
      output <- data.frame(concat = i,expected="expected")
      tempconcat2 = rbind(tempconcat2,output)}
    else
      next
  }}

# Merges expected changes of two previous dataframes and replaces "unexpected" values with "expected" for the valid ones (second dataframe)

tempconcat$expected[match(tempconcat2$concat, tempconcat$concat)] <- tempconcat2$expected

v2_table = merge(v2_table, tempconcat[, c("concat","expected")], by="concat")

## V3 ##

tempconcat <- data.frame(matrix(ncol = 2, nrow = 0))
x <- c("concat","expected")
colnames(tempconcat) <- x

# first loop creates table of all expected as everything that is equal, and everything that is unequal is called unexpected

for (i in 1:nrow(v3_table)) {
  if (v3_table$v3[i]==v3_table$v4[i]) {
    output <- data.frame(concat = v3_table$concat[i],expected="expected")
    tempconcat = rbind(tempconcat,output)}
  else
  {
    output <- data.frame(concat = v3_table$concat[i],expected="unexpected")
    tempconcat = rbind(tempconcat,output)}
}

# Create second empty matrix to fix unexpected changes that are actual expected changes due to version changes in the software

tempconcat2 <- data.frame(matrix(ncol = 2, nrow = 0))
x <- c("concat","expected")
colnames(tempconcat2) <- x

# Second loop creates matrix of expected changes between different versions

for (p in v3_table$concat) {
  for (i in expected_v3_v4$concat) {
    if (i==p)
    {
      output <- data.frame(concat = i,expected="expected")
      tempconcat2 = rbind(tempconcat2,output)}
    else
      next
  }}

# Merges expected changes of two previous dataframes and replaces "unexpected" values with "expected" for the valid ones (second dataframe)

tempconcat$expected[match(tempconcat2$concat, tempconcat$concat)] <- tempconcat2$expected

v3_table = merge(v3_table, tempconcat[, c("concat","expected")], by="concat")

## V4 ##

tempconcat <- data.frame(matrix(ncol = 2, nrow = 0))
x <- c("concat","expected")
colnames(tempconcat) <- x

# first loop creates table of all expected as everything that is equal, and everything that is unequal is called unexpected

for (i in 1:nrow(v4_table)) {
  if (v4_table$v4[i]==v4_table$v5[i]) {
    output <- data.frame(concat = v4_table$concat[i],expected="expected")
    tempconcat = rbind(tempconcat,output)}
  else
  {
    output <- data.frame(concat = v4_table$concat[i],expected="unexpected")
    tempconcat = rbind(tempconcat,output)}
}

# Create second empty matrix to fix unexpected changes that are actual expected changes due to version changes in the software

tempconcat2 <- data.frame(matrix(ncol = 2, nrow = 0))
x <- c("concat","expected")
colnames(tempconcat2) <- x

# Second loop creates matrix of expected changes between different versions

for (p in v4_table$concat) {
  for (i in expected_v4_v5$concat) {
    if (i==p)
    {
      output <- data.frame(concat = i,expected="expected")
      tempconcat2 = rbind(tempconcat2,output)}
    else
      next
  }}

# Merges expected changes of two previous dataframes and replaces "unexpected" values with "expected" for the valid ones (second dataframe)

tempconcat$expected[match(tempconcat2$concat, tempconcat$concat)] <- tempconcat2$expected

v4_table = merge(v4_table, tempconcat[, c("concat","expected")], by="concat")

## Prep and merge files ##

# To-do's here: figure out index order to match to index dataframe. 

link_v1_table = v1_table %>% select(index1,index2,n,expected)
link_v2_table = v2_table %>% select(index2,index3,n,expected)
link_v3_table = v3_table %>% select(index3,index4,n,expected)
link_v4_table = v4_table %>% select(index4,index5,n,expected)

names(link_v1_table) = c("source", "target", "value","group")
names(link_v2_table) = c("source", "target", "value","group")
names(link_v3_table) = c("source", "target", "value","group")
names(link_v4_table) = c("source", "target", "value","group")

combined <- rbind(link_v1_table,link_v2_table)
#links <- rbind(combined,link_v3_table)
combined <- rbind(combined,link_v3_table)
links <- rbind(combined,link_v4_table)


nodes_v1_table = v1_table %>% select(v1,v2)
nodes_v1_table = rbind(nodes_v1_table$v1,nodes_v1_table$v2)

nodes_v2_table = v2_table %>% select(v2,v3)
nodes_v2_table = rbind(nodes_v2_table$v2,nodes_v2_table$v3)

nodes_v3_table = v3_table %>% select(v3,v4)
nodes_v3_table = rbind(nodes_v3_table$v3,nodes_v3_table$v4)

nodes_v4_table = v4_table %>% select(v4,v5)
nodes_v4_table = rbind(nodes_v4_table$v4,nodes_v4_table$v5)

nodes_v1_indexed = v1_indexed
nodes_v2_indexed = v2_indexed
nodes_v3_indexed = v3_indexed
nodes_v4_indexed = v4_indexed
nodes_v5_indexed = v5_indexed

colnames(nodes_v1_indexed)[1] <- c("name")
colnames(nodes_v2_indexed)[1] <- c("name")
colnames(nodes_v3_indexed)[1] <- c("name")
colnames(nodes_v4_indexed)[1] <- c("name")
colnames(nodes_v5_indexed)[1] <- c("name")

test1 = as_tibble(nodes_v1_indexed$name)
test2 = as_tibble(nodes_v2_indexed$name)
test3 = as_tibble(nodes_v3_indexed$name)
test4 = as_tibble(nodes_v4_indexed$name)
test5 = as_tibble(nodes_v5_indexed$name)
test6 = rbind(test1,test2)
test6 = rbind(test6,test3)
test6 = rbind(test6,test4)
test6 = rbind(test6,test5)
nodes = test6
colnames(nodes)[1] <- c("name")

### Plot Sankey ###

library(networkD3)

nodes$group <- as.factor(c("my_unique_group"))

# Give a color for each group:
my_color <- 'd3.scaleOrdinal() .domain(["expected", "unexpected"]) .range(["grey", "red"])'

sankeyNetwork(Links = links, Nodes = nodes,
              Source = "source", Target = "target",
              Value = "value", NodeID = "name",
              fontSize= 10, nodeWidth = 50,nodePadding = 2,colourScale=my_color, LinkGroup="group", NodeGroup="group")

print(nameofthefile)