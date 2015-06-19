#!/usr/bin/perl 
use diagnostics;
use warnings;
#Brian O'Meara, 2007
#concatenatenexusfiles.pl version 1.01
#http://www.brianomeara.info
#Licensed under the GNU Public License Version 2

#This script should be placed in a folder containing individual datasets for each gene,
#  each ending in ".nex", and a file, not ending in ".nex", which contains a list of
#  all the taxa (each separated by a line feed; no spaces in taxon names). The names
#  of the taxa must match between this file and the gene files, though not every
#  taxon need be sequenced for every gene. Upon executing this script, it will
#  ask you for the name of the file of taxa, then use this and all the *nex files
#  to create a new nexus file containing all the sequences, with character sets
#  automatically created based on the input genes. If the gene files come
#  from Mesquite or MacClade, with codon positions stored, this information
#  is used to create  character sets for each codon position of each gene.
#  Feel free to modify the script as needed.
#  Note that the input files should have unix line breaks and the gene files
#  must not be interleaved.

print "everything has to be unix-delimited, non-interleaved\n";
print "file containing list of taxa: ";
$infile=<>;
chomp $infile;
$ntax=0;
#$infile="taxa2.txt";
open(IN,"$infile") or die "could not open the file";
while (<IN>) {
	chomp $_;
	push(@taxonarray,"$_");
	push(@outputarray,"");
	$ntax=$ntax+1;
}
close IN;
open(OUT,">concatenated.txt");
$charsets="begin sets;";
$charactercount=0;
@nexusfilearray=`ls *.nex`;
#If using this on a linux/bash environment, needs to be "ls" instead of "dir" - 
#~~~~ CRF 2015
foreach $nexusfile (@nexusfilearray) {
    chomp $nexusfile;
	$nexusfile=~m/(.*)\.nex/i;
	$genename=$1;
	$currentcharnumberstring=`grep -i "nchar" $nexusfile`;
	# If using this in a linux environment, replace 'findstr' with 'grep' ~~~~ CRF 2015
	$currentcharnumberstring=~m/nchar\s*\=\s*(\d+)/i;
	$currentcharnumber=$1;
	$rawcodonposset = `grep -i "codonposset" $nexusfile`;
	# If using this in a linux environment, replace 'findstr' with 'grep' ~~~~ CRF 2015
	$endchar=$charactercount+$currentcharnumber;
	$startchar=$charactercount+1;
	$charsets="$charsets\n"."charset $genename = $startchar - $endchar;";
	if ($rawcodonposset=~m/N\:\s*([\d\-\s]+)/) {
		$charsets="$charsets\n"."charset $genename"."intron = ";
		$rawN=$1;
		print "\n$rawcodonposset\t";
		@Narray=split(/\D+/,$rawN);
		foreach $Nelement (@Narray) {
			$newelement=$Nelement+$charactercount;
			$charsets="$charsets"." $newelement";
			print "$newelement\t";
		}
		$charsets="$charsets".";";
	}
	if ($rawcodonposset=~m/1\:\s*([\d\-\s]+)/) {
		$charsets="$charsets\n"."charset $genename"."pos1 = ";
		$raw1=$1;
		@Narray=split(/\D+/,$raw1);
		foreach $Nelement (@Narray) {
			$newelement=$Nelement+$charactercount;
			$charsets="$charsets"." $newelement";
		}
		$charsets="$charsets".";";
	}
	if ($rawcodonposset=~m/2\:\s*([\d\-\s]+)/) {
		$charsets="$charsets\n"."charset $genename"."pos2 = ";
		$raw2=$1;
		@Narray=split(/\D+/,$raw2);
		foreach $Nelement (@Narray) {
			$newelement=$Nelement+$charactercount;
			$charsets="$charsets"." $newelement";
		}
		$charsets="$charsets".";";
	}
	if ($rawcodonposset=~m/3\:\s*([\d\-\s]+)/) {
		$charsets="$charsets\n"."charset $genename"."pos3 = ";
		$raw3=$1;
		@Narray=split(/\D+/,$raw3);
		foreach $Nelement (@Narray) {
			$newelement=$Nelement+$charactercount;
			$charsets="$charsets"." $newelement";
		}
		$charsets="$charsets".";";
	}
	for ($taxonnumber=0;$taxonnumber<scalar(@taxonarray);$taxonnumber++) {
		if (`grep -c "$taxonarray[$taxonnumber]" $nexusfile`<2) {
			# egrep is installed on the cluster ~~~~ CRF 2015
			# However, might be better to change this to 
			# `grep -c -E $taxonarray[$taxonnumber] $nexusfile`
			# ----- Then again, it doesn't look like this even is using
			# A regular expression pattern so `grep -c` should be fine, as below on line 107
			for ($i=0;$i<$currentcharnumber;$i++) {
				$outputarray[$taxonnumber]="$outputarray[$taxonnumber]"."?";
			}
		}
		elsif (`grep -c "$taxonarray[$taxonnumber]" $nexusfile`==2) {
			# grep = linux-only command
			$rawmat=`grep "$taxonarray[$taxonnumber]" $nexusfile`;
			$rawmat=~s/\n//g;
			if($rawmat=~m/$taxonarray[$taxonnumber].*$taxonarray[$taxonnumber]\s+(\S+)/) {
				$outputarray[$taxonnumber]="$outputarray[$taxonnumber]"."$1";
			}
			else {
				if($rawmat=~m/$taxonarray[$taxonnumber].*$taxonarray[$taxonnumber](.+)/) {
					print "$taxonarray[$taxonnumber] has "."$1";
				}
				else {
				print "$rawmat\n\n";
				}
			}
		}
		else {
			print "$taxonarray[$taxonnumber] $nexusfile\n";
		}
	}
	$charactercount=$charactercount+$currentcharnumber;
}

$charsets="$charsets\nend;\n";
print OUT "#nexus\nbegin taxa;\ndimensions ntax=$ntax;\ntaxlabels\n";
$taxonlist=join("\n",@taxonarray);
print OUT "$taxonlist ;\nend;\n";
print OUT "begin characters;\ndimensions nchar=$charactercount;\nformat datatype=DNA gap=- missing=?;\nmatrix\n";
for ($taxonnumber=0;$taxonnumber<scalar(@taxonarray);$taxonnumber++) {
	print OUT "$taxonarray[$taxonnumber]  $outputarray[$taxonnumber]\n";
}
print OUT ";\nend;\n$charsets\n";
