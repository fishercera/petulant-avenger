#!/usr/bin/perl
#
# need input file: tab delim pairs of orthologs
# Make a loop that does this for each line of the input file:
# - Figure out the fasta file name from the pairs of orthologs
# - Cat those two files into one file called "both.faa"
# - Align with muscle: muscle -in both.faa -out both.muscle.faa
# - Build a HMM 
# hmmbuild both.hmm both.muscle.faa
# hmmpress both.hmm
# - Query the drafts.faa file with the HMM
# hmmscan --tblout -o hmmscan.out both.hmm drafts.faa
# Then parse the hmmscan output file and count number of orthologs
# 		-use the considerations of alignment length and similarity threshholds
# 		-count hits

$infile = "OrthologPairs.txt";

open (INFILE, $infile) or
	die "cannot open infile";

%orthologs = (
);

$outfile = "Orthologs.tab";
open (OUTFILE, ">$outfile") or
    die "cannot open outfile";

while ($line = <INFILE>) {
    $loopctr++;
    system "rm -f both.hmm*";
	chomp $line;
	@array = split "\t", $line;
	$name1 = $array[0];
#model gi|410481375|ref|YP_006768921.1|	gi|407470529|ref|YP_006783028.1|
	$name1 =~ s/gi\|.+\|ref\|(.+)\|/$1/;
#model after YP_006768921.1
	$name2 = $array[1];
	$name2 =~ s/gi\|.+\|.+\|(.+)\|/$1/;
	$name1 = lc $name1.".fasta";
#model after yp_006768921.1.fasta
	$name2 = lc $name2.".fasta";
#	print $name1."\t".$name2."\n";
	system "cat $name1 $name2 > both.faa";
	system "muscle -in both.faa -out both.muscle.faa";
	system "hmmbuild --cpu 1 both.hmm both.muscle.faa";
	system "hmmpress both.hmm";
	system "hmmscan  -o hmmscan.out --tblout table_hmm.out --cpu 1 both.hmm drafts.faa";
    # Now parse output
    open (INFILE2, "table_hmm.out") or
        die "cannot open table_hmm.out";
    $count = 0;
	while ($hit = <INFILE2>) {
		next if $hit =~ /^#/;
    	@Cols = split /\s+/, $hit;
	    #targetname[0] accession[1]  queryname[2] accession[3]    E-value[4]  score  bias   E-value  score  bias   exp reg clu  ov env dom rep inc description of target
    	$evalue = @Cols[4];
    	print "$evalue\n";
	    if ($evalue < 1e-80) {
    	    print "Got a hit!\n";
    	    print "$evalue\n";
    	    $count = $count + 1;
    	    print "Count is now: $count\n";
    	}
	
	}
print $count;
$orthologs{$count} = $orthologs{$count} + 1;
print "\tOrthologs(count): $orthologs{$count}\n";
close INFILE2;
print OUTFILE "$name1\t$name2\t$count\n";

#if ($loopctr > 2) {last;}
}


#print scalar %orthologs;
open (OUTFILE2, ">tabulatedresults.tab") or
    die "Cannot open outfile2";

@Bins = keys %orthologs;
sort @Bins;
print "\n";
print keys %orthologs;
print "\n";
$len = scalar @Bins;
for ($token = 0; $token < $len; $token = $token+1) {
    $count=$Bins[$token];
    print OUTFILE2 "$Bins[$token]:\t".$orthologs{$count}."\n";
}
close OUTFILE;
close OUTFILE2;
close INFILE;
#print %orthologs;