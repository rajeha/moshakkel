#!/usr/bin/env bash
# split text to words (1 word per line)
# included with the Tashkeela corpus:wq
#tr -s '[*!"#\$%&\(\)\+,\\\.\/:;<=>\?@\[\\\\]^_`\{|\}~][:space:]][:punct:][:digit:]' '\n' < $1 | sort | uniq -c | sort -nr >$1.unq
tr -s '[[:space:][:punct:][:alnum:]]' '\n' |sed 's/[،؟.,÷×:ـ]//g' 
