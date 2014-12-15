#!/usr/bin/perl -w

use strict;
use Carp;

my $patint="([\\+\\-\\d]+)";    # Pattern for Integer number
my $patfp ="([\\+\\-\\d.Ee]+)"; # Pattern for Floating Point number
my $patwrd="([\^\\s]+)";        # Pattern for Work (all noblank characters)
my $patnint="[\\+\\-\\d]+";     # Pattern for Integer number, no () 
my $patnfp ="[\\+\\-\\d.Ee]+";  # Pattern for Floating Point number, no () 
my $patnwrd="[\^\\s]+";         # Pattern for Work (all noblank characters), no () 
my $patbl ="\\s+";              # Pattern for blank space (variable length)

if((scalar @ARGV) != 4) {
    printf(STDERR "incorrect number of parameters: (%d) of $0 (4 required)\n",scalar @ARGV);
    exit(-1);
}

my $xmloutfile = $ARGV[0];
my $stdoutfile = $ARGV[1];
my $stderrfile = $ARGV[2];
my $subdir     = $ARGV[3];
my $vcheck=0;
my $vcomment="not tested";
my $vval=0.0;

if (-f $stdoutfile) {
    open(IN,"$stdoutfile");
    while (<IN>) {
        if (/^\s*Particle redistrib:\s*$patfp\s*/) {
            $vval=$1;
            $vcheck=1;
            $vcomment="ok";
            last;
        }
    }
    if ($vcheck==0) {
        $vcomment="not ok";
    }
} else {
    $vcheck=0; $vcomment="file $stdoutfile not found";
}

open(XMLOUT,"> $xmloutfile") || die "cannot open file $xmloutfile";
print XMLOUT "<verify>\n";
print XMLOUT " <parm name=\"vcheck\" value=\"$vcheck\" type=\"bool\" unit=\"\" />\n";
print XMLOUT " <parm name=\"vcomment\" value=\"$vcomment\" type=\"string\" unit=\"\"/>\n";
print XMLOUT " <parm name=\"vval\" value=\"$vval\" type=\"float\" unit=\"\"/>\n";
#print XMLOUT " <parm name=\"vvalref\" value=\"$vvalref\" type=\"float\" unit=\"\"/>\n";
print XMLOUT "</verify>\n";
print XMLOUT "\n";
close(XMLOUT);

exit(0);
