#!/bin/bash

#Find all lineages present in output files
pango_files=$(ls *nohash.csv) 
for result in ${pango_files}; do
	lineage_list=$(cut -f2 -d, ${result} | sort | uniq)
	result_name=$(echo $result | sed 's/.csv//')
	for lineage in ${lineage_list}; do
		ids=$(grep -F ",${lineage}," ${result} | cut -f1 -d,)
		lineage_num=$(grep -F ",${lineage}," ${result} | cut -f2 -d, | sort | uniq | wc -l)
		if [[ ${lineage_num} -ne 1 ]]; then
			echo -e "${result}\t${lineage}" >> script_fails.txt
		elif [[ ${lineage} != "lineage" ]] && [[ ${lineage} != "None" ]]; then
			echo ${lineage},${ids} >> ${result_name}_lineage.txt
		fi 
	done
done

#Extract all samples of a particular lineage from snpmatrix output
mkdir sub_snpmatrix-intermediate
mkdir sub_snpmatrix

lineage_files=$(ls *lineage.txt) 
for lfile in ${lineage_files}; do
	basename=$(echo ${lfile} | sed 's/_nohash.*//')
	while read -r line; do
		group=$(echo ${line} | cut -f2 -d,)
		lineage=$(echo ${line} | cut -f1 -d,)
		cat <(head -n4 ../snp-dists.tsv | tail -n+4) > sub_snpmatrix-intermediate/${basename}_${lineage}-intermediate.txt
		for x in $group; do grep $x ../snp-dists.tsv | tail -n+2 >> sub_snpmatrix-intermediate/${basename}_${lineage}-intermediate.txt; done
		col_num=$(for x in $group; do grep $x -n snp_names.txt | sed 's/:.*//' ; done)
		col_list=$(echo $col_num | sed 's/ /,/g' | sed 's/^/1,/')
		cut -f $col_list sub_snpmatrix-intermediate/${basename}_${lineage}-intermediate.txt > sub_snpmatrix/${basename}_${lineage}.txt
	done < ${lfile}
done

#Average all the samples from those lineages
mkdir snpmatrix_avg

for x in $(ls sub_snpmatrix); do
	out=$(echo $x | sed 's/.txt//')
	awk 'NR!=1{for(i=2; i<=NF; i++) {a[i]+=$i; if($i!="") b[i]++}}; END {for(i=2; i<=NF; i++) printf "%s%s", a[i]/b[i], (i==NF?ORS:OFS)}' sub_snpmatrix/${x} > snpmatrix_avg/${out}_colavg.txt
	awk '{sum = 0; for (i = 1; i <= NF; i++) sum += $i; sum /= NF; print sum}' snpmatrix_avg/${out}_colavg.txt > snpmatrix_avg/${out}_avg.txt 
done

#Summarize results
cd snpmatrix_avg
echo -e "Run\tLineage\tAverage\tNumber_of_isolates" > pango_summary.txt
samples=$(ls *colavg.txt | sed 's/colavg.txt//')

for samp in ${samples}; do
	sampnum=$(head -n 1 ${samp}_colavg.txt | awk '{print NF}')
	run=$(echo ${samp} | sed 's/_[A-Z].*//')
	lineage=$(echo ${samp} | sed 's/.*_[0-9]*_//')
	avg=$(cat ${samp}_avg.txt)
	echo -e "${run}\t${lineage}\t${avg}\t${sampnum}" >> pango_summary.txt
done
cd ..

#Scorpio results
samples=$(ls *.csv)
echo "File,Number_overridden,Lineages,Samples" > scorpio_summary.txt

for samp in ${samples}; do
	lineages=$(grep "not supported by scorpio\|replaced" ${samp} | sed 's/.*assignment //' | sed 's/was.*//'| sed 's/;.*//')
        ids=$(grep "not supported by scorpio\|replaced" ${samp} | cut -f1 -d,)
	numsamp=$(grep "not supported by scorpio\|replaced" ${samp} | wc -l)
	echo ${samp}","${numsamp}","${lineages}","${ids} >> scorpio_summary.txt
done
