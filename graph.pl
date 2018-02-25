#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
die "usage: $0 <dna.gz> <kmer length> <directory path>" unless @ARGV == 3;

my ($dna_file, $k, $dir) = @ARGV;

#Get sequences
my %dna;
my $chr; 
my %counts;

open(my $fhin, "gunzip -c $dna_file |") or die "error reading $dna_file";
while (<$fhin>) {
	chomp;
	if (/^>(\S+)/) {
		$chr = $1;
	} else {
		$dna{$chr} .= $_;
	}
}

#Delete MtDNA chromosome
delete $dna{'MtDNA'};

#Get counts for chromosomes and entire genomes
foreach my $chromosome (sort keys %dna) {
	for (my $i = 0; $i < length($dna{$chromosome}) - $k + 1; $i++) {	
		my $kmer = substr($dna{$chromosome}, $i, $k);
		$counts{'genome'}{$kmer}++;	
		$counts{$chromosome}{$kmer}++;
	}
}

#Make Graph	
#my %position; #stores current position in each chromosome
#Position, Counts(Genome), Counts(Chrom)
#foreach my $chromosome (sort keys %dna) {
#	open(my $fhout, ">", "$dir/output-$k-$chromosome.txt");  
#	for (my $i = 0; $i < length($dna{$chromosome}) - $k + 1; $i++) {
#		my $kmer = substr($dna{$chromosome}, $i, $k);
#		$position{$chromosome}++;			
#		print $fhout "$position{$chromosome}\t";
#		print $fhout "$counts{'genome'}{$kmer}\t";
#		print $fhout "$counts{$chromosome}{$kmer}\n";
#	}
#	close $fhout;
#}		