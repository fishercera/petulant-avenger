#!/usr/bin/perl
# Pseudo-code for RBH project
# HAVE two files -- Blast1 to 2 and Blast2 to 1
# Use format 6 so we have just the hits no header
# ~~~~ Cera Fisher 3/18/2014 ~~~~

$infile1 = "2057_to_2065.out"; #just changed the names of the vars to flip around what I was comparing to what
$infile2 = "2065_to_2057.out";
#$infile2 = "2050_to_2071.blastp.out"; #just changed the names of the vars to flip around what I was comparing to what
#$infile1 = "2071_to_2050.blastp.out";

open (INFILE1, "$infile1") or
        die "I cannot find the $infile1";

open (INFILE2, "$infile2") or
        die "Cannot find the $infile2";


%hits = (
        elj2057_QueryID => "2065_SubjectID",
);

while ($line = <INFILE1>) {
        @Cols = split "\t", $line;
#~~ @Cols = qseqid[0] sseqid[1] pident[2] length[3] evalue[4] mismatch[5] gapopen[6] qstart[7] qend[8] sstart[9] send[10] qlen[11] slen[12]
    if ($hits{$Cols[0]}){print "Already have a hit for $Cols[0]"; next;}
        next if ($Cols[3]/$Cols[11]) < .50;
        next if ($Cols[3]/$Cols[12]) < .50;
        $key = lc $Cols[0];
        $hits{$key} = "elj2065_$Cols[1]"; # Key Query_id (2057) has Value Subject_id (2065)
        print "Query_id\t$key\tSubject_id\t$hits{$key}\n";
}

%Rhits = (
        elj2065_QueryID => "2057_SubjectID", #Doing this just helps me remember how to use the hash
);

$outfile1 = "Orthologs_2057-to-2065.out";
$outfile2 = "Non-recip_2065.out";

open (OUTFILE1, ">$outfile1") or
        die "Cannot open the outfile";
open (OUTFILE2, ">$outfile2") or
        die "cannot open the outfile";


$numRBH = 0;
$numNRH = 0; # Counter for non-recip blast hits
print "Now for the Reciprocals:\n";
while ($line = <INFILE2>) {
        @Cols = split "\t", $line;
	$key = lc $Cols[0];
        next if ($Rhits{$Cols[0]});
        next if ($Cols[3]/$Cols[11]) < .50;
        next if ($Cols[3]/$Cols[12]) < .50;
        $Rhits{$key} = "elj2057_$Cols[1]";
        print "Query_id\t$key\tSubject_id\t$Rhits{$key}\n"; 
}

@hitsarray = keys %hits; # An array of all the keys for the first hash (2057 => 2065)
for ($count = 0; $count < scalar @hitsarray; $count++) {
    $hitskey = $hitsarray[$count];
    $Val2065 = $hits{$hitskey}; # <-- A 2065 contig: a value in the first hash for a key that is a 2057 query ID
    $Val2057 = $Rhits{$Val2065}; # <-- A 2057 contig: a value in the second hash for a key that is a 2065 query id
        if ($Val2065 eq $hits{$Val2057}) { # If this 2065 contig is the same as the valye in %hits for the 2057 contig then this is RBH
                        print OUTFILE1 "$Val2065\t$Val2057\n";
                        print "$Val2065\t$Val2057\n";
                        $numRBH++;
                }
                if ($Val2065 eq $hits{$Val2057}) { #If this contig doesn't match the value in %hits for its 2057 contig this is not RBH
                        print OUTFILE2 "$Val2065\tNo hit\n";
                        print "$Val2065\tNo hit\n";
                        $numNRH++;
                }
}

close OUTFILE1;
close OUTFILE2;
