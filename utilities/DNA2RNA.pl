#!/usr/bin/perl
#takes your
#input sequence and outputs its RNA compliment
#sequence. 
#
#$revcomplement =~ tr/CAGT/GTCA/;
#print OUTFILE $revcomplement;
#close OUTFILE;
# USAGE: DNA2RNA.pl infile.fasta outfile.fasta

$infile = $ARGV[0];
$outfile = $ARGV[1];

open (INFILE, "$infile") or
	die "Could not find $infile";

open (OUTFILE, ">$outfile") or
	die "Could not open $outfile";

while ($line = <INFILE>) {
	if ($line=~ />/) {
	    print $line;
		print OUTFILE $line;
		next;
	}
		else {
		    $line =~ tr/CAGT/GUCA/;
		    print $line;
		    print OUTFILE $line;
	}
}

	