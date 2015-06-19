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
$sequence = join("", @dna);
$sequence =~ s/\s//g;

$countA = $sequence =~ tr/A/A/;
$countC = $sequence =~ tr/C/C/;
$countG = $sequence =~ tr/G/G/;
$countT = $sequence =~ tr/T/T/;


#$first_base = substr($sequence, 0, 1);
#print $first_base, "\n";

print "Number of A: $countA\n";
print "Number of C: $countC\n";
print "Number of G: $countG\n";
print "Number of T: $countT\n";
#print "Your total length is $array_size\n";

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