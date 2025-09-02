#!/bin/bash

# Pass the input file as a command-line argument and process with sed and awk
sed -e 's/\r//g' "$1" \
    | sed '/^-/d' \
    | sed '/Descrição/d' \
    | sed '/Domínio/d' \
    | awk -F: '{ print $2 }' \
    | awk 'BEGIN { FS=";"; RS=""; } 
{
    gsub(/ /, "", $0); 
    arr[NR]="[" $1 ";" $4 ";" $5 "]"
} 
END {
    for(i=1; i<=NR; i++) {
        printf "%s", arr[i];
        if(i<NR) printf ",";
        printf "\n";
    }
}'