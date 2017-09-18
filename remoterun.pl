#v1.0
#remoterun is a perl script written with plink and takes input of file <switches.txt> useful when you want to run commands across 
#lots of switches 
#the script only allows show commands to be run as a added security
use warnings;
use strict;
use Term::ReadKey;
use IO::Handle;
###Set Plink variable path 
my $plink = 'c:\\tools\\plink.exe';
print "Username: ";
chomp(my $user = <STDIN>);
Readmode("noecho");
print "Password: ";
chomp(my $pass=<STDIN>);
Readmode("orginal");
print "\n";
my $valid=0;
my $cmd;
while ($valid == 0) {
print "Enter the Command to be run:";
chomp($cmd=<STDIN>);
if ( $cmd =~ /^sh/) {
$valid=1;
}
else { 
print "Only Show commands are allowed \n";
}
}
my $switches = 'switches.txt';
open(my $host,"<",$switches) or die "Cannot open Switches file :$!";
while ( !eof($host) ) {
defined ( $_ = readline $host) or die "readline failed :$!";
chomp;
print "Running Commands on ",$_,"\n";
print `$plink -l $user pw $pass $_ \"$cmd\" `;

