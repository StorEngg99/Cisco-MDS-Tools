#v 1.0
# Works with Cisco MDS Switches
#When you connect two switches via ISL , you would normally want to check if cabling has been done correctly or set port description
# the config file generate cisco commands to set interface description 
#Requires account which has permission to run show commands 
# To change description you need an account with admin priv
#you need to download putty.exe and pscp.exe 
#useful in organisation where access to tools are restricted 
use warnings;
use strict;
use Term::ReadKey;
use IO::Handle;
#Configuration info for pscp & putty 
my $plink = 'c:\\tools\plink.exe'
my $pscp = 'c:\\tools\pscp.exe'
print "UserName: ";
chomp(my $user = <STDIN>);
ReadMode("noecho");
print "Password: ";
chomp(my $pass = <STDIN>);
ReadMode("orginal");
print "\n";
print "Hostname: ";
chomp(my $host = <STDIN>);
#config file will be directed to the directory where the program was run from 
my $config_file = $host."\.txt";
open(my $cf_file,">",$config_file) or die "Cannot open config file";
my $cmd = 'show toplogy isl vsan 1 detail'
my $out = `$plink -l $user -pw \"$pass\" $host \" $cmd\"`;
#######################################################
# This section is to generate the configuration file 
open(my $fh ,"<",\$out);
my @temp;
my $length;
my $n;
# We are setting a Base variable to Handle Port-channel numbers less than 100 as they tend to add a extra space in output
my $base = 0;
print $cf_file "conf\n";
while (! eof($fh)){
defined ( $_ = readline $fh ) or die "Readline Failed :$!";
$n = $fh->input_line_number();
next if $n < 5;
  if (/(^\s+)/){
      $base=1;
      }
   @temp = split(/\s+/);
   $length = scalar @temp;
   print $cf_file "int ",$temp[$base+3],"\n";
   print $cf_file "switchport description ",$temp[$base+2]," ",$temp[$base+3]," To ",$temp[$base+5],"  ",$temp[$base+4],"\n";
   }
   print $cf_file "end\n";
   print $cf_file "copy run start \n";
   close($cf_file);
   close($fh);
   #Once the above step is completed config files are Generated ##################
   # The code below helps if you want to automate copy and applying changes as well 
   print "This Steps Below Require Admin Access to Copy and Run commands on Cisco MDS Switches.\n";
   print "Do you want to Copy the files to ",$host," Y/N ? ( Default:N):";
   chomp( my $option = <STDIN>);
   if ( $option -ne 'Y') {
   exit;
   }
   print " Inorder for copy to work you need to have SCPserver enabled on Cisco Switches.\n";
   print "You will be now asked to enter  username with admin privellages and password.\n";
   print "UserName :";
   chomp($user=<STDIN>);
   ReadMode("noecho");
   print "Password :";
   chomp($pass = <STDIN>);
   ReadMode("original");
   print "\nCopying File :",$config_file," to ",$host,"\n";
   print `$pscp -l $user -pw \"$pass\" $config_file $host\":\"`;
   ###This section handles the running part on Cisco MDS 
   print "\n Do you want to Run the Script on ",$host," Y/N(Default N):";
   $option = <STDIN>;
   chomp($option);
   if ( $option ne 'Y') {
   exit;
   }
   print "\n";
   $cmd = 'run-script  bootflash:'.$config_file;
   print "\nRunning script :",$config_file," on ",$host,"....\n";
   print `$plink -l $user -pw \"$pass\" $host \"$cmd\"`;
