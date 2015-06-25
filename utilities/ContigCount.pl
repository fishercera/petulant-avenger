#!/usr/bin/perl
# Calculate the number of contigs/chromosomes+plasmids for each genome, draft & complete 
#		grep -c ">" <filename>.fna
# Calculate # of proteins they encode 
#       grep -c ">" <filename>.faa
# Calculate the genome size
#		Invert grep: grep -v ">" <filename>.fna | wc -m
# -- I'm using these to check my scripts. However, these numbers might be off, b/c wc is probably counting whitespace, and my script won't

# Proteins are in .faa files, nucleotide sequences are in .fna files
# ARGV[0] could be the base filename, and I could write two loops 
# that handled the proteins and nucls separately, then tabulated both results

# Take the Argv, then make two variables for ProtInfile and NucInfile
# Make a hash! Contigs, Proteins, Genome size; update the keys, then print the hash. 
# Read Protinfile line by line
# Update ProteinNum for each fasta header found in ProtFile
# Read Nucinfile line by line
# Update ContigNum for each fasta header found
# Update genome size = plus the length of each contig
# Print keys and write to an outfile in a pretty format 

%genomeStats = (
	nContigs => "",
	nProteins => "",
	nLetters => "",
);

$inBase = $ARGV[0];
$protIn = $inBase.".faa";
print $protIn;
$nucIn = $inBase.".fna";
print $nucIn;

open (PROTFILE, $protIn) or
	die "Could not open $protIn";
open (NUCFILE, $nucIn) or
	die "Count not open $nucIn";
open (OUTFILE, $ARGV[0] + "output") or
	die "Can't open that outfile";

while ($line = <PROTFILE>) { # read Protfile line by line
	# If header, increment nProteins
	if ($line =~ /^>/) {
		$genomeStats{$nProteins}++;
	}
}
print $genomeStats{$nProteins};

while ($line = <NUCFILE>) {
	if ($line =~ /^>/) {
		$genomeStats{$nContigs}++;
	}
	elsif ($line !~ /^>/) {
		$line =~ s/\s//g;
		$genomeStats{$nLetters} = $genomeStats{$nLetters} + length $line;
	}
}
print $genomeStats{$nContigs};
print $genomeStats{$nLetters};

$prettyPrint = "";
$prettyPrint = $ARGV[0] + " Genome Stats:\n";
$prettyPrint = $prettyPrint."Contigs: ".$genomeStats{$nContigs};
$prettyPrint = $prettyPrint."\nProteins: ".$genomeStats{$nProteins};
$prettyPrint = $prettyPrint."\nGenome Size: ".$genomeStats{$nLetters};
print $prettyPrint;

print OUTFILE $prettyPrint;
close OUTFILE;

