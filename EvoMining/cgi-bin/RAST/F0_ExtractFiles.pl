use strict;
use warnings;
####################################################
######### Description  
#### nselem84@gmail.com
####################################################
## 1. Decompres and extract binding file from tarball RAST download

######### Subs and variables #######################
my @TARS=qx/ls *.tar/; ## Read all cvs

sub unTar;
sub extractFiles;
####################################################
#################################
###### Main program
####################################################

foreach my $tar (@TARS){
	unTar($tar);   ## Decompress all tar files on the script folder
	extractFiles($tar); ## Extract the binding files
}
####################################################
####################################################

sub unTar{

	my $tar=shift;
	chomp $tar; 
	$tar=~s/\.tar//;
	print "$tar\n";	
	qx/mkdir $tar/;  #Create a folder with the Organism Id
	qx/mv $tar.tar $tar\/$tar.tar/;
	`tar -xvf $tar\/$tar.tar -C $tar`; #Extract
}

sub extractFiles{
	my $tar = shift;
	chomp $tar; 
	$tar=~s/\.tar//;
	print "$tar\n";	
	my $file=qx/ls $tar\/*\/Subsystems\/bindings/;  #Create a folder with the Organism Id		
	chomp $file;
	print "$file\n";
	qx /mv $file $tar.bindings/ ;
	qx /rm -r $tar/;
	#qx /rmdir $tar/;
}
