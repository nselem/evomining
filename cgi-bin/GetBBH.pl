use strict;
### This file uses vuelta.bbh  
## Returns .bbh files A partition of all Functions on metabolic Pathways on the vuelta <name>.bbh file

my $file=$ARGV[0]; ##vuelta<name>.bbh

open (FILE,$file) or die;
my %HASH;

foreach my $line (<FILE>){
	chomp $line;
	my @st=split(/\t/,$line);
	my @st1=split ('>',$st[0]);
	$st1[0]=~s/ -//;
	my $id=$st1[0]; 
	#print"$st1[0]\n";

	my @st2=split(/\|/,$st1[1]);
	$st2[2]=~s/_\d*$//;
	my $central=$st2[2];

	if(! -exists $HASH{$central}){	$HASH{$central}=();	}
	if ( !($id~~@{$HASH{$central}})){
		push(@{$HASH{$central}},$id)
		}
	#print"$central  @{$HASH{$central}}\n";

	#my $pause=<STDIN>;	
	
}
close FILE;


foreach my $key(keys %HASH){
	open (FILE,">$key\.bbh");
	foreach my $id(@{$HASH{$key}}){
		print FILE "$id\n";
		}
my $size=scalar @{$HASH{$key}};
print "$key\t$size\n";
}
