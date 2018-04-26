use strict;
## ids in bbh.tree
# that are also on antiSMASH


my $fileCENTRAL=$ARGV[0];
open (FILE,$fileCENTRAL) or die;

my $fasta;
my$central;

##############################################
foreach my $line (<FILE>){
	chomp $line;
	my @st=split(/\t/,$line);
	 $fasta=$st[0].".concat.fasta.ids.smash";
	 $central=$st[1].".bbh.tree";
		print "$fasta\t$central";
#		print "pause1\n";
#		my $pasue=<STDIN>;
		getCentralTreeonSMASH($central,$fasta);
		}

##########################################

sub getCentralTreeonSMASH{
	my $fileBBH=shift;
	my $fileSMASH=shift;
	#buscar los Elementos de BBH que estan en SMASH

	my  @BBH;
	my @FASTA;
	open (FILE,">$central\.bbh_smash");
	#Read BBBH file
	open (BBH,$fileBBH) or die;

	foreach my $line (<BBH>){
		chomp $line;
		push(@BBH,$line);
#		print "On central $line\n";
		}	
close BBH;
	#Read fasta file
	open (SMASH,$fileSMASH) or die "Couldn open $fileSMASH";
	my $Count=0;

	foreach my $line (<SMASH>){
		chomp $line;
#		print "On smash $line\n";
	#	print "$st[1]\n";
		if(!($line~~@FASTA)){
			push(@FASTA,$line);
			if($line~~@BBH){
				$Count++;
			print FILE "$line\n";
				}
			}
	}
close FILE;
close SMASH;
print "\t$Count\n";
#elements on BBH also on fatsa
}
