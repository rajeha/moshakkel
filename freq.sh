#!/usr/bin/env bash
# reports list of frequencies and probablities
LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr | tee freq.tmp | perl -nlae 'print $F[0]' | paste -sd+ - | bc > sum.tmp
cat freq.tmp | perl -nlae "print join \"\t\", \$F[0]/$(cat sum.tmp), @F"
rm -f freq.tmp sum.tmp 
