#!/opt/perl/bin/perl
use warnings;
# transcribe DNA to RNA
$DNA = 'ATGGCGAGCAAAAATTGCAGTGCT';

# Print the DNA onto the screen
print "Here is the starting DNA:\n";
print "$DNA\n";

# Transcribe the DNA to RNA by substituting all T's with U's.
$RNA = $DNA;
$RNA =~ s/T/U/g;

# Print the RNA onto the screen
print "Here is the result of transcribing the DNA to RNA:\n";
print "$RNA\n";

exit;
