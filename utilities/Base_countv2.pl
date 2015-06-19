#!/opt/perl/bin/perl
use warnings;
# read a DNA sequence from a file

# store the file name to a variable
$filename = 'ROI1.fasta';

# To "open" the file, we need associate a "filehandle" with it.
# Let's use DNA for readability. The filehandle doesn't have 
#to be in upper case, but that's a good convention to keep. 
open (DNA, $filename);

# Now we do the actual reading of the DNA sequence data from the file,
# by using the angle bracket operator "< >" to get the input from the
# filehandle.  We store the data into the variable $dna.

@dna = <DNA>; # reading a whole chunk of information into an array.
shift @dna; # pops off the first element of the array
$dna = join("", @dna);
$dna =~ s/\n//g;
@sequence = split("", $dna);
print "@sequence", "\n";

$array_size = scalar(@sequence);
$countA = 0;
$countC = 0;
$countG = 0;
$countT = 0;
#$i = 0;
for ($i = 0; $i < $array_size; $i++) {
    if ($sequence[$i] =~ m/A/) {$countA++;}
    elsif ($sequence[$i] =~ m/C/) {$countC++;}
    elsif ($sequence[$i] =~ m/G/) {$countG++;}
    elsif ($sequence[$i] =~ m/T/) {$countT++;}
    else {print "This is not a standard nucleotide.\n";}
}



print "Number of A: $countA\n";
print "Number of C: $countC\n";
print "Number of G: $countG\n";
print "Number of T: $countT\n";
print "Your total length is $i\n";

#print length$dna;
#print $dna[0];
#print "@dna\n"; # Look at how the array looks like
#print scalar@dna, "\n";



#while ($dna= <DNA>) {
#    chomp $dna;
#    print $dna, "\n";
#} 

# Print the DNA sequence onto the screen
#print "Here is the DNA sequence:\n";
#print $dna, "\n";

# Also remember to close the file once we are done.
close DNA;

exit;