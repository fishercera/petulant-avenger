#!/usr/bin/perl -w

while(defined($file=glob("*.pepstats")))

#unless (@ARGV==1) {die "provide infile\n";}

{
$infile=$file ;

$outfile=$infile.".parsed";

$outfile2=$infile.".pI";

$outfile3=$infile.".pos_charged";



open(IN, "< $infile") or die "cannot open $infile: $!";
open(OUT, "> $outfile") or die "cannot open $outfile: $!";
open(OUT2, "> $outfile2") or die "cannot open $outfile2: $!";
open(OUT3, "> $outfile3") or die "cannot open $outfile3: $!";

while(defined($line=<IN>)){
    chomp($line);
    if($line=~"PEPSTATS"){
    
	@parts=split(/\s+/,$line);
    
	print OUT "$parts[2]\t$parts[6]\t";
	
	$length=$parts[6];
    
    }

    if($line=~"Isoelectric Point"){
    
	@parts=split(/\s+/,$line);
    
	print OUT "$parts[3]\t";
	
	print OUT2 "$parts[3]\n";
	
	$charged=0;
    
    }


    if($line=~"H = His"){
    
	@parts=split(/\s+/,$line);
    
	$charged+=$parts[3];
    
    }

    if($line=~"K = Lys"){
    
	@parts=split(/\s+/,$line);
    
	$charged+=$parts[3];
    
    }

    if($line=~"R = Arg"){
    
	@parts=split(/\s+/,$line);
    
	$charged+=$parts[3];
	
	$proportion=$charged/$length;
	
	print OUT "$proportion\n";
	print OUT3 "$proportion\n";
    
    }



}
close(IN);
close(OUT);
close(OUT2);
close(OUT3);
}

