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

while ($dna= <DNA>) {
    chomp $dna;
    print $dna, "\n";
} 

# Print the DNA sequence onto the screen
#print "Here is the DNA sequence:\n";
#print $dna, "\n";

# Also remember to close the file once we are done.
close DNA;

exit;
