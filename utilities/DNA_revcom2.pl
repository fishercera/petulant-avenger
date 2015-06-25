#!/opt/perl/bin/perl
use warnings;
# Calculating the reverse complement of a strand of DNA


# The DNA
$DNA = $ARGV[0];

# Print the DNA onto the screen
print "Here is the starting DNA:\n";
print "$DNA\n";

# It doesn't matter if we first reverse the string and then
# do the complementation; or if we first do the complementation
# and then reverse the string.  Same result each time.
# So when we make the copy we'll do the reverse in the same statement.

$revcom = reverse $DNA;

$revcom =~ tr/ACGT/TGCA/;

# Print the reverse complement DNA onto the screen
print "Here is the reverse complement DNA:\n";
print "$revcom\n";

exit;
