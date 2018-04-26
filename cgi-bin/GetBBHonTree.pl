use strict;
####
###

my $fileCENTRAL=$ARGV[0];
open (FILE,$fileCENTRAL) or die;

my $fasta;
my$central;
foreach my $line (<FILE>){
	chomp $line;
	my @st=split(/\t/,$line);
	 $fasta=$st[0].".concat.fasta";
	 $central=$st[1].".bbh";
		print "$fasta\t$central";
		getCentralTree($central,$fasta);
		}

sub getCentralTree{
	my $fileBBH=shift;
	my $fileFasta=shift;
	#buscar los Elementos de BBH que estan en fasta

	my  @BBH;
	my @FASTA;
	open (FILE,">$central\.tree");
	#Read BBBH file
	open (BBH,$fileBBH) or die;

	foreach my $line (<BBH>){
		chomp $line;
		push(@BBH,$line);
		#print "$line\n";
		}	

	#Read fasta file
	open (FASTA,$fileFasta) or die;
	my $Count=0;

	foreach my $line (<FASTA>){
		chomp $line;
		if ($line=~/>/ and $line=~/gi/ ){
		my @st=split(/\|/,$line);
		if($st[1]~~@BBH){
			$Count++;
			print FILE "$st[1]\n";
			}
		}
	}
close FILE;
print "\t$Count\n";
#elements on BBH also on fatsa
}
