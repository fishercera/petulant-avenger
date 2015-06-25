#!/opt/perl/bin/perl

#system "cd $HOME";
$sysdir = system "echo $ENV{$HOME}";
print $sysdir;
print "echo $ENV{$HOME}";

exit;
