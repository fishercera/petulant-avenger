# cat ortholog pairs into single fasta file
# In order to globally align them and view in an alignment program 
# and to make consensus sequences to map reads to


$infile = "Orthologs_2057-to-2065.out";

open (INFILE, "$infile") or
    die "I cannot open $infile, sorry";

while ($line = <INFILE>) {
    $loopctr++;
    system "rm -f both.hmm*";
	chomp $line;
	@array = split "\t", $line;
	$name1 = $array[0];
	$val1 = $name1;
	$val1 =~ s/(elj2065_comp.+_c.+_seq.+)/$1__/;
	# model: elj2065_comp2654_c0_seq1
#	$name1 =~ s/(elj2065_comp.+_)c.+_seq.+/$1*.fasta/; # makes variable $name1 = something like elj2065_comp2654_*.fasta 
	# so picks up all members of component
    $name1 = "$name1.fasta";
    open (INFILE2, "$name1") or
        die "I cannot open $name1, sorry";
        while ($headerline = <INFILE2>) {
            chomp $headerline;
            if ($headerline =~ /^>/) {
                @hCols = split "\s", $headerline;
                #>ELJ2065_comp6350_c0_seq1 len=1702 path=[11880660:0-1701] <- model
                $len=$hCols[1];
                print "$len\n";
                @info = split "=", $len;
                $length1 = int($info[1]);
                print "$length1\n";
                close INFILE2;
            }
        }
	print "$name1\t";
	$name2 = $array[1];
	$val2 = $name2;
	$val2 =~ s/(elj2057_comp.+_c.+_seq.+)/$1/;
	#model: elj2057_comp12778_c0_seq1
	#$name2 =~ s/(elj2057_comp.+_)c.+_seq.+/$1*.fasta/; # elj2057_comp127778_*.fasta
	$name2 = "$name2.fasta";
	    open (INFILE3, "$name2") or
        die "I cannot open $name2, sorry";
        while ($headerline = <INFILE3>) {
            chomp $headerline;
            if ($headerline =~ /^>/) {
                @hCols = split "\s", $headerline;
                #>ELJ2065_comp6350_c0_seq1 len=1702 path=[11880660:0-1701] <- model
                $len=$hCols[1];
                print "$len\n";
                @info = split "=", $len;
                $length2 = int($info[1]);
                print "$length2\n";
                close INFILE3;
            }
        }
	print "$name2\n";
#	print $name1."\t".$name2."\n";
    if ($length1 < 800) {print "length1 less than 800\n"; next;}
    if ($length2 < 800) {print "length2 less than 800\n"; next;}
    system "needle -asequence $name1 -bsequence $name2 -gapopen 10 -gapextend 0.5 -outfile $val1$val2.needle";
    $alignedctr++;
    print "needle -asequence $name1 -bsequence $name2 -gapopen 10 -gapextend 0.5 -outfile $val1$val2.needle\n";
#if ($loopctr > 10) {die};
}

print "\n\n$loopctr pairs considered; $alignedctr pairs were aligned ( both >800 bp ).\n\n"; 
close INFILE;

#NEEDLE usage
#needle -asequence <seqfile> -bsequence -gapopen 10 -gapextend -outfile $val1$val2.needle



