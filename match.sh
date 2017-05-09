#!/usr/bin/env bash
# finds most likely dicritization of a word
# usage: ./match.sh [ngram] [ngram file]
cat ${2} | LC_ALL=C egrep "\s${1}\s" | LC_ALL=C sort -k1,1 -nr | head -n +1 | rev | cut -f1 | rev | tr -d '\n' 
