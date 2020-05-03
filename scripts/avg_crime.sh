#!/bin/bash

rows=$(tail -n +2 crimedata-australia.csv|wc -l)
cols=$(head -1 crimedata-australia.csv| sed 's/[^,]//g'|wc -c)

min_avg=$(cut -d, -f2 crimedata-australia.csv|awk -v r=$rows '{total +=$0}END{print total/r}')
city=$(head -1 crimedata-australia.csv | cut -f2 -d,)

for ((i=3;i<$cols;i++))
do
	avg=$(cut -d, -f"$i" crimedata-australia.csv| awk -v r=$rows '{total +=$0}END{print total/r}')
	if (( $(echo | awk "{print $avg < $min_avg}") )); then
		min_avg=$avg
		city=$(head -1 crimedata-australia.csv|cut -f"$i" -d,)
	fi
done

echo "The lowest crime is in the city $city"
echo "Minimin average crime rate is $min_avg"

