#!/usr/bin/perl
#Open the list of ortholog pairs
#step through the list and mv each pair that matches to /keep
$infile = "Orthologs_2057-to-2065.out";

open (INFILE, "$infile") or 
    die "Cannot open $infile";
     
while ($line = <INFILE>) {
    chomp $line; # ALWAYS ALWAYS CHOMP
    @pair = split "\t", $line;
    $name1 = lc $pair[0]; 
    $name2 = lc $pair[1];
    print "$name1 \t $name2\n";
    print "Filenames: $name1 \t $name2\n";
    system "cp $name1.fasta keep/\n";
    system "cp $name2.fasta keep/\n";
} 

system "ls ./keep/";

close INFILE;

