#!/usr/bin/perl
# ~~~~ Cera Fisher (c) 2014
use warnings;
use strict;
#
#(1) (1 point) What's the average coverage for each site you would expect?
#~~~500 Mbp genome = 500,000,000 five hundred million base pairs
#~~~280 million reads of 100 bp each = 280,000,000 * 100 = 28,000,000,000 28 billion bp
#~~~OR 28000 million / 500 million = 56 - so I expect coverage of about 56x, each 
#~~~base should be seen 56 times on average. 
#(2) (4 points) For our ultimate goal, what kinds of SNPs should be filtered out and why? 
#Filter these "unwanted" SNPs using either Linux commands or Perl script. 
#Note: you may need re-think about this question after you are done with problem (3). 
#We should filter out very low coverage snps -- less than 30x, let's say. 

#GOAL: Filter out low coverage SNPS
#Open SNP file
#Save the first line to a header variable
#Then read through line by line and check Column 11, the coverage
#If that value < 30, next
#Else write to filtered_snps file
die "Usage: perl FilterSnps.pl <raw snps filename> <output filename>" unless @ARGV == 2;
my $infile = $ARGV[0]; 
my $outfile = $ARGV[1];

open (IN, $infile) or 
    die "I cannot open $infile\n";

my $header = <IN>;

open (OUT, ">$outfile") or
    die "I cannot open $outfile to write\n";
print OUT $header;


while (my $line = <IN>) {
    my @Cols = split "\t", $line;
    if ($Cols[10] >= 30) {
#    print "This coverage is $Cols[10], greater than 30\n";
    print OUT $line;
    # write to out file
    }
    elsif ($Cols[10] < 30) {
#    print "This coverage is $Cols[10], less than 30\n";
    # discard this line
    }
}

close OUT;
close IN;

