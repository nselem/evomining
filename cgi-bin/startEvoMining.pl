#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long 'HelpMessage';
###############################################3
#ask for GEnomes
#ask for NP's
#ask for central pathways
# RAST to Evo
# Edit Globals
# mv Databases Rigth place
####################################################################

=head1 NAME

Corason - pass your inputs trough the command line!

=head1 SYNOPSIS

  --natural_db,n	Natural products DB, EvoMining will use MiBig if not new DB is provided
  --central_db,c    	Central Pathways DB. EvoMining will Streptomyces and Mycobacteria if no new central pathways are provided
  --genome_db,g		Genome DB. EvoMining will use

=head1 VERSION

0.01

=cut

####################################################################################################
################       get options ##############################################################
GetOptions(
	'natural_db=s' => \(my $natural_db="MiBIG_DB.faa"),
        'central_db=s' => \(my $central_db="ALL_curado.fasta") ,
        'antismash_db=s' => \(my $smash_db="AntiSMASH_CF_peg_Annotation_FULL.txt") ,
	'genome_db=s' => \(my $genome_db="los17"),
	'rast_ids=s' => \(my $rast_ids="los17Rast.ids"),
	'help'     =>   sub { HelpMessage(0) },
       ) or HelpMessage(1);

####################### end get options ###############################################3
######################### BEGIN  Main program ###########################################
printInputs($natural_db,$central_db,$genome_db,$rast_ids,$smash_db);
my $output_path="$central_db\_$natural_db\_$genome_db";
createOutDir($output_path);
editGlobals($genome_db,$natural_db,$central_db,$smash_db);

prepareDB($genome_db,$natural_db,$central_db,$rast_ids,$smash_db);
system("perl reparaHEADER.pl");
system ("sudo service apache2 start");
######################### END main program

###################### Subs ######################################
sub createOutDir{
	my $output_path=shift;
	if (!-d "/var/www/html/EvoMining/exchange/$output_path"){
		system("mkdir -p /var/www/html/EvoMining/exchange/$output_path/blast/seqf/tree");
		system ("chmod -R 777 /var/www/html/EvoMining/exchange/$output_path");
		print "mkdir /var/www/html/EvoMining/exchange/$output_path has been created\n";
		}
	else {
		print "mkdir /var/www/html/EvoMining/exchange/$output_path already exists\n";
		system ("chmod -R 777 /var/www/html/EvoMining/exchange/$output_path");
		}
	print "Ready output directory \n\n";
	unless(-e "/var/www/html/EvoMining/exchange/$output_path/EvoMining.log"){
		open (FILE,">/var/www/html/EvoMining/exchange/$output_path/EvoMining.log");
		print FILE "startEvoMining ";
		close FILE;
		}
	system ("chmod -R 777 /var/www/html/EvoMining/exchange/$output_path/EvoMining.log");
	}
#____________________________________________________________________________
sub printInputs{
        my $np=shift;
        my $central=shift;
        my $genome=shift;
	my $rast_ids=shift;
	my $smash_db=shift;

	print "\n\n\n\n";
	print "##########################################\n";
	print "Welcome to EvoMining\n";
	print "##########################################\n";
	print "Genome DB: $genome_db\n";
	print "Central DB: $central_db\n";
	print "Natural Products: $natural_db\n";
	print "Rast Ids: $rast_ids\n";
	print "AntiSMASH: $smash_db\n";
}

#____________________________________________________________________________
sub prepareDB{
        my $genome=shift;
        my $np=shift;
        my $central=shift;
	my $rast_ids=shift;
	my $smash_db=shift;
	my $import_p="/var/www/html/EvoMining/exchange";
	my $moved_p="/var/www/html/EvoMining/cgi-bin";
	my $ids_name="$genome\Rast.ids";
        
	if ($smash_db ne "AntiSMASH_CF_peg_Annotation_FULL.txt") {
 		system("cp $import_p/CyanosSMASH $moved_p/antiSmashClusteFinder/.");
		}
        if($genome ne "los17"){
                if(!$rast_ids){
                        print "Error: RastIds file must be provided";
                        exit;
                        }
                else{
                        print "Genome and RAST DB will be actualized\n";

                        if(!-e "$moved_p/RAST/$ids_name"){
				system( "ln -s $import_p/$rast_ids $moved_p/RAST/$ids_name\n");
				}
			else {
				print "RAST/$ids_name file already exists!\n";
				}
			#system("for f in $import_p/$genome/*.faa\; do basename \$f \| while read UF \; do echo ln -s \$f $moved_p/RAST/\$UF\;done\; done");
			system("for f in $import_p/$genome/*.faa\; do basename \$f \| while read UF \; do ln -s \$f $moved_p/RAST/\$UF\;done\; done");
			system("for f in $import_p/$genome/*.txt\; do basename \$f \| while read UF \; do ln -s \$f $moved_p/RAST/\$UF\;done\; done");

                        print( "We will copy genome to DB\n");
                        if(-d  "$moved_p/DB/$genome") {
				system( "rm -r $moved_p/DB/$genome");
				system( "cp -R $import_p/$genome $moved_p/DB/$genome");
				}  ## copy to DB to converte formats
			else{
				system( "cp -R $import_p/$genome $moved_p/DB/$genome");
				}
			print "Genome DB has been copied\n";
			print "\n\n"; 
			#print "pause\n\n"; my $pause=<STDIN>;
			print "Fasta files will be converted to evo files\n";
			system("ls DB/$genome/*.faa \| while read line\; do echo perl  FaaToEvoNelly-modified.pl \$line RAST/$ids_name DB/$genome\; perl FaaToEvoNelly-modified.pl \$line RAST/$ids_name DB/$genome\;done");			## convert files
			print "Files have been converted to EvoMining format\n\n";

		#	system("for f in DB/$genome/*.faa\; do mv \$f \$f.evo\; done");
			if (-e "$moved_p/DB/$genome/$genome.fasta"){system(" rm $moved_p/DB/$genome/$genome.fasta"); } ##Cat file
			system("cat $moved_p/DB/$genome/*.evo \> $moved_p/DB/$genome/$genome.fasta");  ##Cat file
			print "Genome Db has been stored \n\n";

			system("echo $moved_p/DB/$genome/*evo $import_p/$genome/.");
			system("mv $moved_p/DB/$genome/*evo $import_p/$genome/.");
			print "evo files has been stored at exchange  \n\n";
		
			system("rm $moved_p/DB/$genome/*txt");
			print "Deleted extra txt files  \n\n";
                        }
                }
        if($central ne "ALL_curado.fasta"){
                print "Central pathway $central \n";
                print "mv Central pathway DB \n";
                system( "ln -s $import_p/$central $moved_p/PasosBioSin/$central");
                }
        if($np ne "MiBIG_DB.faa"){
                print "Natural Products $np\n";
                print "mv Natural Products DB\n";
                system( "cp -s $import_p/$np $moved_p/NPDB/$np");
                }
        }
#____________________________________________________________________________

sub editGlobals{
        my $genome=shift;
        my $np=shift;
        my $central=shift;
	my $smash=shift;

        if ($genome){system("perl -p -i -e 's/GENOMES=\".+\"/GENOMES=\"$genome\"/ if /GENOMES/' globals.pm ");}
        if ($genome){system("perl -p -i -e 's/GENOMES=\".+\"/GENOMES=\"$genome\"/ if /GENOMES/' globals.pm ");}
        if ($np){system("perl -p -i -e 's/NP_DB=\".+\"/NP_DB=\"$np\"/ if /NP_DB/' globals.pm ");}
        if ($central){system("perl -p -i -e 's/VIA_MET=\".+\"/VIA_MET=\"$central\"/ if /VIA_MET/' globals.pm ");}
        if ($smash){system("perl -p -i -e 's/ANTISMASH=\".+\.txt\"/ANTISMASH=\"$smash\"/ if /ANTISMASH/' globals.pm ");}

        }
#____________________________________________________________________________
