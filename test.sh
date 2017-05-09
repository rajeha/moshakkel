#!/usr/bin/env bash
# reports percentage of correctly diacritized words
# usage: cat diacritized_file.txt | ./test.sh
# requires strip.sh and predict.sh
tee test.tmp | ./strip.sh | ./predict.pl | perl -CSDL -aple 's/\s+/\n/g' > df1.tmp
cat test.tmp | perl -CSDL -aple 's/\s+/\n/g' > df2.tmp
echo "scale=2;$(sdiff -s df1.tmp df2.tmp | wc -l)/$(cat df1.tmp| wc -l)*100" | bc -l
rm -f test.tmp df1.tmp df2.tmp 
