#!/bin/bash
echo "Most prominent payment types: " 
sort -k10,10 -nr -t, yellow_tripdata_2019-01.csv | cut -f10 -d, | uniq -c| sort -nr | head -n -1
