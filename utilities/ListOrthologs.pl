#!/usr/bin/perl
# Pseudo-code for RBH project
# HAVE two files -- Blast1 to 2 and Blast2 to 1
# Use format 6 so we have just the hits no header 

#$infile2 = $ARGV[0]; #just changed the names of the vars to flip around what I was comparing to what
#$infile1 = $ARGV[1];
$infile2 = "2050_to_2071.blastp.out"; #just changed the names of the vars to flip around what I was comparing to what
$infile1 = "2071_to_2050.blastp.out";

open (INFILE1, "$infile1") or
	die "I cannot find the $infile1";

open (INFILE2, "$infile2") or
	die "Cannot find the $infile2";
	

%hits = (
	QueryID => "SubjectID",
);

while ($line = <INFILE1>) { 
	@Cols = split "\t", $line;
#~~ @Cols = qseqid[0] sseqid[1] pident[2] length[3] mismatch[4] gapopen[5] qstart[6] qend[7] sstart[8] send[9] qlen[10] slen[11] evalue[12]
	next if ($hits{$Cols[0]}); 
	next if ($Cols[3]/$Cols[10]) < .70;
	next if ($Cols[3]/$Cols[11]) < .70;	
	$hits{$Cols[0]} = $Cols[1];
}

%Rhits = (
	QueryID => "SubjectID", #Doing this just helps me remember how to use the hash
);

$outfile1 = "OrthologPairs.txt";
$outfile2 = "NonRecipPairs1.txt";

open (OUTFILE1, ">$outfile1") or 
	die "Cannot open the outfile";
open (OUTFILE2, ">$outfile2") or
	die "cannot open the outfile";

	
$numRBH = 0;
$numNRH = 0; # Counter for non-recip blast hits
while ($line = <INFILE2>) {
	@Cols = split "\t", $line;
	next if ($Rhits{$Cols[0]}); # If we already have this query ID stored in the Rhits hash
	next if ($Cols[3]/$Cols[10]) < .70;
	next if ($Cols[3]/$Cols[11]) < .70;	
	$Rhits{$Cols[0]} = $Cols[1]; 
	
}

@hitsarray = keys %hits;
for ($count = 0; $count < scalar @hitsarray; $count++) {
		if ($Rhits{$hits{$hitsarray[$count]}} eq $hitsarray[$count]) {
			print OUTFILE1 "$hits{$hitsarray[$count]}\t$hitsarray[$count]\n";
			print "$hits{$hitsarray[$count]}\t$hitsarray[$count]\n";
			$numRBH++;
		}
		if ($Rhits{$hits{$hitsarray[$count]}} ne $hitsarray[$count]) {
			print OUTFILE2 "$hits{$hitsarray[$count]}\t$Rhits{$hits{$hitsarray[$count]}}\n";
			print "$hits{$hitsarray[$count]}\t$Rhits{$hits{$hitsarray[$count]}}\n";
		}
}

close OUTFILE1;
close OUTFILE2;


print "Number of RBH: $numRBH\n";
print "Number of Non-Reciprocal Hits: $numNRH\n";

#/* Number of RBH: 4917
#Number of unique hits: 0
#Number of Non-Reciprocal Hits: 161
#*/
