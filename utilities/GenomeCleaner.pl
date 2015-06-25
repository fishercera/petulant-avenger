#!/opt/perl/bin/perl
use warnings;

die print "usage: <GenomeStats.pl>  <genome assembly> <coverage file> <outfile name>\n" unless scalar(@ARGV) == 3;
$infile1 = $ARGV[0];

$infile2 = $ARGV[1];

$outfile = $ARGV[2];

open (FILE2, $infile2); 





%contigs = ();
$header = <FILE2>;
while ($line = <FILE2>) {
    chomp $line;
    @columns = split("\t", $line);
    $coverage = int ($columns[-1]); # saved the coverage in integer
    $name = $columns[0];  # saved the contig name
    $contigs{$name} = $coverage; # adds this key/value pair: name & coverage to the hash
}

close FILE2;

open (FILE1, $infile1) or die "I cannot open the $infile1";
open (OUT, ">$outfile") or die "I can't write to $outfile";
#print OUT "hello!\n";

#while ($line = <FILE1>) {
#    chomp $line;
#    if ($line=~ /^>(.*)$/) {
#        $name = $1;
#        if (exists $contigs{$name}) {
#        } else {print "key $name doesn't exist\n";}
#        if ($contigs{$name} >= 10) {
#            $keep = 1;
#            print "$line\n";
#        } else {
#            $keep = 0;
#            next;
#        }
#    }
#    if ($keep == 1) {
#        print OUT "$line\n";
#    }
#}

while ($line = <FILE1>) {
    chomp $line;
    if ($line =~ /^>(.*)$/) {
        $name = $1;
    }
    if ($contigs{$name} >= 10) {
        print OUT $line, "\n";
    }
}

close OUT;
close FILE1;

# At the end of this file 

# open genome file
# for each line
# if line starts with >:
# isolate contigname from header
# if in the HASH - the value of key{contigname} > 10:
# set a variable named "keep" to the value "1" because that means "Keep is True"
# else set "keep" to the value "0" because that means "Keep is false"
# then
# Check to see if "Keep" is "True"
# If it is, then write this line to the output file
# If not, then "Keep" is "false" so we do not want to keep this line, so 
# go to the next line





# set a variable $keep = 1;
# else set $keep = 0
# then 
# if $keep == 1 
# write this line to the output file
# gotonext



