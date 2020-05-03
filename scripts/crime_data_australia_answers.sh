#!/bin/bash

echo "1. Number of lines in file excluding header"
tail -n +2 crimedata-australia.csv | wc -l
echo ""

echo "2. Number of columns"
head -1 crimedata-australia.csv | sed 's/[^,]//g' | wc -c
echo ""

echo "3. For a given city type of crime on top of list"
cut -d "," -f1,10 crimedata-australia.csv |tail -n+2|sort -n -r -k 2 --field-separator=","| head -1
echo ""

echo "4. Number of crimes for a given city"
awk -F"," '{sum+=$7}END{print "total crimes in city is " sum}' crimedata-australia.csv
echo ""

echo "5. Average Crimes for a given city"
awk -F"," '{ total += $3; count++ } END { print total/(count-1) }' crimedata-australia.csv
echo ""

echo "6. City with lowest average crime"
./avg_crime.sh


