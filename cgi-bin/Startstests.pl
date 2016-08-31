#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long 'HelpMessage';
 


system ("sudo service apache2 start");
#ask for GEnomes
#ask for NP's
#ask for central pathways


=head1 NAME
Corason - pass your inputs trough the command line!
=head1 SYNOPSIS
CORASON extense manual can be consulted at: https://github.com/nselem/EvoDivMet/wiki/Detailed-Tutorial/
  --natural_db,n	Natural products DB, EvoMining will use MiBig if not new DB is provided
  --central_db,c    	Central Pathways DB. EvoMining will Streptomyces and Mycobacteria if no new central pathways are provided
  --genome_db,g		Genome DB. EvoMining will use

Remarks:
For float values (as e_value, e_core etc) 0.001 will work, but .001 won't do it.
=head1 VERSION
0.01
=cut

##################################################################



####################################################################################################
#########################  end of variables ########################################################
####################################################################################################
################       get options ##############################################################
GetOptions(
	'natural_db=s' => \(my $natural_db="MiBIG_DB.faa"),
        'central_db=s' => \(my $central_db="ALL_curado.fasta") ,
	'genome_db=s' => \(my $genome_db="los17"),
	'help'     =>   sub { HelpMessage(0) },
       ) or HelpMessage(1);

#######################3 end get options ###############################################3
print "Welcome to EvoMining\n";
print "Genome DB $genome_db\n";
print "Central DB $central_db\n";
print "Natural Products $natural_db\n";


if (! -e "/var/www/html/exchange/$central_db\_$natural_db\_$genome_db"){
	system("mkdir /var/www/html/EvoMining/exchange/$central_db\_$natural_db\_$genome_db");
	print "mkdir /var/www/html/EvoMining/exchange/$central_db\_$natural_db\_$genome_db has been created\n";
	}
else {
	print "mkdir /var/www/html/EvoMining/exchange/$central_db\_$natural_db\_$genome_db already exists\n";
	}
