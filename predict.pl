#!/usr/bin/env perl 
## ngram-level lexical modeling as described by Zayyan et al. 2016
## usage: cat undicritized.txt | predict.pl
## requires match.sh 
use strict;
use warnings;
use utf8;

while (my $line = <>) {
	chomp $line;
	my ($search, $target, $word);
	my @words = split /[\s[:punct:]]+/, $line;

	for (0..$#words) {
		if ($_ > 2) {
			$search = join "\t", @words[$_-3, $_-2, $_-1, $_];
			$target = 'r_quadgrams.txt';
			$word = `./match.sh "$search" $target`;
			goto THEEND if length $word;
		} 
		if ($words[$_+1] and $words[$_+2] and $words[$_+3]) {
			$search = join "\t", @words[$_, $_+1, $_+2, $_+3];
			$target = 'l_quadgrams.txt';
			$word = `./match.sh "$search" $target`;
			goto THEEND if length $word;
		} 
		if ($_ > 1) {
			$search = join "\t", @words[$_-2, $_-1, $_];
			$target = 'r_trigrams.txt';
			$word = `./match.sh "$search" $target`;
			goto THEEND if length $word;
		} 
		if ($words[$_+1] and $words[$_+2]) {
			$search = join "\t", @words[$_, $_+1, $_+2];
			$target = 'l_trigrams.txt';
			$word = `./match.sh "$search" $target`;
			goto THEEND if length $word;
		} 
		if ($_ > 0) {
			$search = join "\t", @words[$_-1, $_];
			$target = 'r_bigrams.txt';
			$word = `./match.sh "$search" $target`;
			goto THEEND if length $word;
		} 
		if ($words[$_+1]) {
			$search = join "\t", @words[$_, $_+1];
			$target = 'l_bigrams.txt';
			$word = `./match.sh "$search" $target`;
			goto THEEND if length $word;
		}
		$search = $words[$_];	
		$target = 'unigrams.txt';	
		$word = `./match.sh "$search" $target`;
		$word = $search unless length $word;	# last resort 

		THEEND:
		$line =~ s/\Q$words[$_]\E/$word/;
	}

	print "$line\n";
}
