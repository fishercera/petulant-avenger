#!/usr/bin/perl
# ~~~~ Cera Fisher (c) 2014
#
#(3) (16 points) Write a program to count the number of "high-frequency" SNPs 
#(defined as frequency >= 95%) in 20-kb windows along each of the 14 longest 
#pseudoscaffolds (SL9_pseudoscaffold_1 to SL9_pseudoscaffold_14). If you have overlap 
#(e.g., 10-kb) between two adjacent windows, it would be a typical "sliding window 
#algorithm". But for our purpose here, you don't have to have overlap between adjacent 
#windows. In case you want to know the pseudoscaffold length, they are available from 
#the "pseudoscaffold_length.txt" file in the same directory. 

#I want to count up the number of high frequency SNPs in each window. 
#So this is a "binning" problem, so I'll use a hash. 
#My hash will be a hash of arrays - does that make sense? Yes. Each time I get to a new 
#Scaffold in the excel file, I'll start a new array and make a new key/value. 

#%hash = (
#
#refOne => ["0","1","2"],
#refTwo => ["00", "11", "22"]
#
#);
# 
# print keys %hash, "\n";
# print "\n";
# 
# print "$hash{'refOne'}[0]\n";
# print "$hash{'refOne'}[1]\n";
# print "$hash{'refTwo'}[2]\n";

#~~~~~~~~#

my $infile = "smallSNP.txt";


$SeqName = "";
while ($line = <IN>) {
	chomp $line;
	@Cols = split($line, \t);
	if ($SeqName eq $Cols[0] { #Then, I am still looking at the the same scaffold - do stuff 
	}
	elsif ($SeqName neq $Cols[0]) { #Now this is a new scaffold!
		$SeqName = $Cols[0]
		$begin = 0;
		$end = 20000;
		for ($i = 0; $i <= ScaffoldLength; $i += 20000) {
		# 
		}
	}
	
}




close IN;