use strict;
use warnings;
#This script generates a <File> zone.vsan.txt on directory where the script is run 
#Usage perl active_zone.pl <startupfile> <vsanno>

#intialize the variables
my $startup=shift;
my $vsan=shift;
my $zonetxt="zone.$vsan.txt";
my $zone,$ZS1,$ZS2;
#####
$/=undef; #changing input record seperator value
open(START,$startup);
open(ZN,">",$zonetxt);

my $begin=eval{qr/\!Active Zone Database Section for vsan $vsan/};
my $end=eval{qr/zoneset name (.*?) vsan $vsan/};
my $end1=eval{qr/zoneset activate name (.*?) vsan $vsan/};

while (<START>) {
s/\n/\_N\_/g;
if m(/$begin(.*)$end(.*)$end1/i){
$zone=$1;
$ZS1=$2;
$ZS2=$4;
}

$zone=~s/\_N\_/\n/g;
$ZS1=~s/\_N\_/\n/g;
$ZS2=~s/\_N\_/\n/g;

print ZN $zone;
print "Database zoneset name:", $ZS1,"\n";
print "Active zoneset name:",$ZS2,"\n";
}
close(ZN);
close(START);
