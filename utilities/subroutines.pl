#!/usr/bin/perl
# How to make subroutines
# in Perl, a package of subroutines is called a module

use warnings;
use strict;

my $seq = $ARGV[0];

print rev_com($seq), "\n";


##########################
#Behold the subroutines  #
##########################

sub rev_com {
my ($sequence) = @_; #list context vs. scalar context - this puts the first element of @_ into $sequence
my $rev_com = reverse $sequence;
$rev_com =~ tr/ATGCatgc/TACGtacg/;
return $rev_com;
}

