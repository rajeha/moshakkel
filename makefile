SHELL = /bin/sh

TRAINSET := $(wildcard trainset/*)
DEVSET := $(wildcard devset/*)
TESTSET := $(wildcard testset/*)

help:
	@echo 'options:'
	@echo '  train  [creates ngram frequencies]'
	@echo '  eval   [reports accuracy based on devset/*]'
	@echo '  test   [reports accuracy based on testset/*]'
	@echo '  clean  [removes *.tmp files]'
	@echo '  fclean [removes *.tmp and *gram.txt files]'

train: unigrams.txt r_bigrams.txt r_trigrams.txt r_quadgrams.txt l_bigrams.txt l_trigrams.txt l_quadgrams.txt

eval: $(DEVSET) test.sh
	cat $(DEVSET) | ./test.sh

test: $(TESTSET) test.sh
	cat $(TESTSET) | ./test.sh	 

# words*.tmp are lists of ngrams
words.tmp: $(TRAINSET) tokenize.sh
	cat $(TRAINSET) | ./tokenize.sh > $@

words2.tmp: words.tmp
	cat $< | tail -n +2 | paste $< - > $@

words3.tmp: words2.tmp
	cat $< | tail -n +2 | cut -f2 | paste $< - > $@

words4.tmp: words3.tmp
	cat $< | tail -n +2 | cut -f3 | paste $< - > $@

unigrams.txt: words.tmp strip.sh freq.sh
	cat $< | ./strip.sh | paste - words.tmp | ./freq.sh > $@

# *grams.txt are frequency lists of ngrams
r_bigrams.txt: words2.tmp strip.sh freq.sh 
	cat $< | ./strip.sh | paste - $< | cut -f1,2,4 | ./freq.sh > $@ 

r_trigrams.txt: words3.tmp strip.sh freq.sh
	cat $< | ./strip.sh | paste - $< | cut -f1,2,3,6 | ./freq.sh > $@
	
r_quadgrams.txt: words4.tmp strip.sh freq.sh
	cat $< | ./strip.sh | paste - $< | cut -f1,2,3,4,8 | ./freq.sh > $@

l_bigrams.txt: words2.tmp strip.sh freq.sh 
	cat $< | ./strip.sh | paste - $< | cut -f1,2,3 | ./freq.sh > $@ 

l_trigrams.txt: words3.tmp strip.sh freq.sh
	cat $< | ./strip.sh | paste - $< | cut -f1,2,3,4 | ./freq.sh > $@
	

l_quadgrams.txt: words4.tmp strip.sh freq.sh
	cat $< | ./strip.sh | paste - $< | cut -f1,2,3,4,5 | ./freq.sh > $@

clean:
	rm -rf *.tmp

# training takes a long time -- careful
fclean:
	rm -rf *.tmp *grams.txt
