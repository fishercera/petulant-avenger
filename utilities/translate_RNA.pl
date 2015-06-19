#!/usr/bin/perl
# ~~~~ CF (c) 2014
use warnings;
#use a hash table to translate CDS to protein
# first set an infile
%code = (
    'TCA' => 'S',    # Serine
    'TCC' => 'S',    # Serine
    'TCG' => 'S',    # Serine
    'TCT' => 'S',    # Serine
    'TTC' => 'F',    # Phenylalanine
    'TTT' => 'F',    # Phenylalanine
    'TTA' => 'L',    # Leucine
    'TTG' => 'L',    # Leucine
    'TAC' => 'Y',    # Tyrosine
    'TAT' => 'Y',    # Tyrosine
    'TAA' => '*',    # Stop
    'TAG' => '*',    # Stop
    'TGC' => 'C',    # Cysteine
    'TGT' => 'C',    # Cysteine
    'TGA' => '*',    # Stop
    'TGG' => 'W',    # Tryptophan
    'CTA' => 'L',    # Leucine
    'CTC' => 'L',    # Leucine
    'CTG' => 'L',    # Leucine
    'CTT' => 'L',    # Leucine
    'CCA' => 'P',    # Proline
    'CCC' => 'P',    # Proline
    'CCG' => 'P',    # Proline
    'CCT' => 'P',    # Proline
    'CAC' => 'H',    # Histidine
    'CAT' => 'H',    # Histidine
    'CAA' => 'Q',    # Glutamine
    'CAG' => 'Q',    # Glutamine
    'CGA' => 'R',    # Arginine
    'CGC' => 'R',    # Arginine
    'CGG' => 'R',    # Arginine
    'CGT' => 'R',    # Arginine
    'ATA' => 'I',    # Isoleucine
    'ATC' => 'I',    # Isoleucine
    'ATT' => 'I',    # Isoleucine
    'ATG' => 'M',    # Methionine
    'ACA' => 'T',    # Threonine
    'ACC' => 'T',    # Threonine
    'ACG' => 'T',    # Threonine
    'ACT' => 'T',    # Threonine
    'AAC' => 'N',    # Asparagine
    'AAT' => 'N',    # Asparagine
    'AAA' => 'K',    # Lysine
    'AAG' => 'K',    # Lysine
    'AGC' => 'S',    # Serine
    'AGT' => 'S',    # Serine
    'AGA' => 'R',    # Arginine
    'AGG' => 'R',    # Arginine
    'GTA' => 'V',    # Valine
    'GTC' => 'V',    # Valine
    'GTG' => 'V',    # Valine
    'GTT' => 'V',    # Valine
    'GCA' => 'A',    # Alanine
    'GCC' => 'A',    # Alanine
    'GCG' => 'A',    # Alanine
    'GCT' => 'A',    # Alanine
    'GAC' => 'D',    # Aspartic Acid
    'GAT' => 'D',    # Aspartic Acid
    'GAA' => 'E',    # Glutamic Acid
    'GAG' => 'E',    # Glutamic Acid
    'GGA' => 'G',    # Glycine
    'GGC' => 'G',    # Glycine
    'GGG' => 'G',    # Glycine
    'GGT' => 'G',    # Glycine
    );

#$infile = "scalloped_mrna.fasta";
die "usage: <translate_RNA.pl> <fasta file>\n" unless @ARGV == 1;
$infile = $ARGV[0];
open (CDS, $infile) or
    die "Cannot open $infile";

@seqLines = <CDS>;

$header = shift @seqLines;
print "$header\n";

$sequence = join("", @seqLines);
$sequence =~ s/\s//g;
$sequence =~ s/\r//g;
print "Sequence is: $sequence \n";

$protein = "";
$readingFrame = "1";
for ($i = 0; $i < (length($sequence)); $i=$i+3) {
    $codon = substr($sequence, $i, 3);
    $protein = $protein.$code{$codon};
}
print "Frame: $readingFrame\nSeq: $protein\n";
$stopCount = $protein =~ tr/*/*/;
if ($stopCount > 1) {print "Stop-codon in frame\n";}



$protein = "";
$readingFrame = "2";
for ($i = 1; $i < (length($sequence)); $i=$i+3) {
    $codon = substr($sequence, $i, 3);
    if (length($codon)<3) {next;}
    $protein = $protein.$code{$codon};
}
print "Frame: $readingFrame\nSeq: $protein\n";
$stopCount = $protein =~ tr/*/*/;
if ($stopCount > 1) {print "Stop-codon in frame\n";}

$protein = "";
$readingFrame = "3";
for ($i = 2; $i < (length($sequence)); $i=$i+3) {
    $codon = substr($sequence, $i, 3);
    if (length($codon)<3) {next;}
    $protein = $protein.$code{$codon};
}

print "Frame: $readingFrame\nSeq: $protein\n";
$stopCount = $protein =~ tr/*/*/;
if ($stopCount > 1) {print "Stop-codon in frame\n";}

$protein = "";
$revcomp = reverse $sequence;
$revcomp =~ tr/CAGT/GTCA/;


$readingFrame = "-1";
for ($i = 0; $i < (length($revcomp)); $i=$i+3) {
    $codon = substr($revcomp, $i, 3);
    if (length($codon)<3) {next;}

    $protein = $protein.$code{$codon};
}
print "Frame: $readingFrame\nSeq: $protein\n";
$stopCount = $protein =~ tr/*/*/;
if ($stopCount > 1) {print "Stop-codon in frame\n";}

$protein = "";

$readingFrame = "-2";
for ($i = 1; $i < (length($revcomp)); $i=$i+3) {
    $codon = substr($revcomp, $i, 3);
    if (length($codon)<3) {next;}
    $protein = $protein.$code{$codon};

}
print "Frame: $readingFrame\nSeq: $protein\n";

$stopCount = $protein =~ tr/*/*/;
if ($stopCount > 1) {print "Stop-codon in frame\n";}

$protein = "";
$readingFrame = "-3";
for ($i = 2; $i < (length($revcomp)); $i=$i+3) {
    $codon = substr($revcomp, $i, 3);
    if (length($codon)<3) {next;}
    $protein = $protein.$code{$codon};
}
print "Frame: $readingFrame\nSeq: $protein\n";
$stopCount = $protein =~ tr/*/*/;
if ($stopCount > 1) {print "Stop-codon in frame\n";}


close CDS;
