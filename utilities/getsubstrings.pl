#!/usr/bin/perl
# Just getting the 20 char seeds to grep adapters for SeqPrep
use warnings;
use strict;


my $seq = $ARGV[0];
my $file = $ARGV[1];
print "$seq\n";

my $b = 0;

for (my $n = 0; $n <length($seq)-19; $n+=1) {
#   print substr($seq, $n, 20), "\n";
    my $sub = substr($seq, $n, 20);
    my $count = `grep -c "$sub" $file`;
    print "$sub: $count \n";
  }