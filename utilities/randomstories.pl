#!/opt/perl/bin/perl
use strict;
use warnings;

# Declare the variables
my $count;
my $input;
my $number;
my $sentence;
my $story;

# Here are the arrays of parts of sentences:
my @subjects = qw(Lauren Ursula Obama Anniston Sanger
Waston_and_Crick Veronica Mike Andrew Cera Russ Lucas Renee Christina Jeanne Nasim Heidi Karolina Rafa Nikhil);

my @verbs = ('likes', 'studies', 'hates', 'wants', 'likes eating', 'invented', 'discovered', 'sings', 'writes', 'reads', 'won', 'builds', 'collects', 'is', 'takes', 'gives', 'tells', 'cooks', 'talks about');

my @nouns = ('stupid songs', 'shark shit', 'the double helix', 'junk paper', 'DNA sequencing', 'nobile prize', 'phylogeny', 'speciation', 'parasites', 'shit', 'jerk', 'flowers', 'fish', 'mice', 'his/her advisor', 'moss', 'election speech', 'classic papers', 'interesting stories');

my @prepositions = ('in the white house', 'at UConn', 'during lunch', 'at the beach',
'before dinner', 'in the 1970s', 'in 1953', 'around the world', 'all the time', 'at his/her wedding', 'in the shower', 'long time a ago', 'in graduate school', 'when he/she is drunk');

# Seed the random number generator.
# time|$$ combines the current time with the current process id
# in a somewhat weak attempt to come up with a random seed.
srand(time|$$);

# This do-until loop composes six-sentence "stories".
#  until the user types "quit".
do {
    # (Re)set $story to the empty string each time through the loop
    $story = '';  

    # Make 6 sentences per story.
    for ($count = 0; $count < 10; $count++) {

        #  Notes on the following statements:
        #  1) scalar @array gives the number of elements in the array.
        #  2) rand returns a random number greater than 0 and 
        #     less than scalar(@array).
        #  3) int removes the fractional part of a number.
        #  4) . joins two strings together.
        $sentence   = $subjects[int(rand(scalar @subjects))]
                    . " " 
                    . $verbs[int(rand(scalar @verbs))]
                    . " "
                    . $nouns[int(rand(scalar @nouns))]
                    . " "
                    . $prepositions[int(rand(scalar @prepositions))] 
                    . "\n";

        $story.=$sentence;
    }

    # Print the story.
    print "\n",$story,"\n";

    # Get user input.
    print "\nType \"quit\" to quit, or press Enter to continue: ";

    $input = <STDIN>;

    # Exit loop at user's request
}  until($input =~ /^\s*q/i);

exit;

