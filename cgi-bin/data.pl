#!/usr/bin/perl -w
#####################################################
#
#####################################################
############################## def-SUB  ################################
use globals;
use List::MoreUtils qw(uniq);
no warnings 'experimental::smartmatch';
# ussage 
# $c =10
#perl data.pl $c

#print "$OUTPUT_PATH\n";
############################# Reaading files
my $num=$ARGV[0]; #Family number
my $map=$OUTPUT_PATH."/blast/seqf/tree/".$num.".map2";
my $tree=$OUTPUT_PATH."/blast/seqf/tree/".$num.".tree";
my $GenomeFile=$GENOMES; ##GENOMES FROM CENTRAL
#print "$map\n$tree\n";

############################################################################
my %LEAVES;
fill(\%LEAVES,$map); #Read colors on tree ids =genoemeId.GenId color->{Id1,Id2,...}
addGray(\%LEAVES,$tree);
my %GENOMESNUM=fillGenomes(\%LEAVES);
my %GENOME_NAME=GenomeNames(\%GENOMESNUM);
#names('6666666.146852',\%GENOME_NAME);
#exit;
## Change names on tree
treeNames($tree,$num,\%GENOMESNUM,\%GENOME_NAME);
exit;

################## Sub ##########################################	
sub names{
my $genome=shift;
my $Genome_Names=shift;

my $name=$Genome_Names->{$genome};
#print "$genome\t$name\n";
#	my $pause=<STDIN>;
return $name;
}
#-----------------------------------
sub copies{
my $genome=shift;
my $Genome_Copies=shift;

my $copies=$Genome_Copies->{$genome};
return $copies;
}
#---------------------------------------------------------
sub GenomeNames{
	my $GENOMESNUM=shift;
	my %GENOMES_NAME;
	my $path="RAST/$GenomeFile"."Rast.ids";
	open (RAST,"$path") or die "No pude abrir $path $!";
		foreach my $line (<RAST>){
			chomp $line;
#			$line=~s/\r//;
#			my @st=split(/\t/,$line);
			$line=~s/\d*\t\s*(\d*)\.(\d*)\s*\t*//;
			my $genome=$1.".".$2;
			$GENOMES_NAME{$genome}=$line;
		#	print "$line\n";
		#	print "$genome->$GENOMES_NAME{$genome}\n";
		#	my $pause=<STDIN>;
			}
	close RAST;
	return %GENOMES_NAME;
}
#--------------------------------------------------------------------
sub fillGenomes{
	my %GENOMES;
	my $LEAVES=shift;
	foreach my $key(keys %$LEAVES){
		foreach my $elem(@{$LEAVES->{$key}}){
		#	print "$key:$elem\t";
			if($elem=~/(\d*)\.(\d*)\.(\d*)/){
				$genome=$1.".".$2;
				if(!exists $GENOMES{$genome}){
					$GENOMES{$genome}=1;
					}
				else{
					$GENOMES{$genome}=$GENOMES{$genome}+1;
					}
				}
			#	print "$genome\t$GENOMES{$genome}\n";
			}
		}
	return %GENOMES;
	}
#-----------------------------------------------------------------------------------------------------------------
sub addGray{
	my $LEAVES=shift;
	my $tree=shift;
	$LEAVES->{'Gray'}=();
	open(TREE,$tree) or die "No pude abrir $tree \n $!";
	foreach my $line (<TREE>){
		chomp $line;
		my @st=split(':',$line);
		foreach my $long(@st){
			if($long=~/gi/){
				my @st1=split(/\|/,$long);
				$st1[1]=~s/(\d*)\.(\d*)\.(\d*)//;
				my $name=$1.".".$2.".".$3;
				#print "$name";
				my $genome=$1.".".$2;
				my ($type,$color)=getColor($name);	
				if($color =~/Gray/){
					push(@{$LEAVES->{'Gray'}},$name);
			#		print "$name\tgray\n";
					}	
				}
			}
		}
	close TREE;
	}
#---------------------------------
sub treeNames{
	my $tree=shift;
	my $num=shift;
	my $genomeCopies=shift;
	my $genomeName=shift;

open(TREE,$tree) or die "No pude abrir $tree \n $!";
open (FILE,">$OUTPUT_PATH/blast/seqf/tree/$num.csv") or die $!;
print FILE"Id\tMetabolism\tMetabolism__colour\tMetabolism__shape\tGenome\tFunction\tCopies\tCopies___colour\tCopies__shape\n";
open (TREE2,">$OUTPUT_PATH/blast/seqf/tree/$num.nwk") or die $!;

foreach my $line (<TREE>){
	chomp $line;
#	print $line;
	my @st=split(':',$line);
	my $newtree="";
	foreach my $long(@st){
		my $name="";
		my $color="";
		my $type="";
		my $genome="";
		#print "$long\n";
		if($long=~/gi/){
			my @st1=split(/\|/,$long);
			$st1[1]=~s/(\d*)\.(\d*)\.(\d*)//;
			$name=$1.".".$2.".".$3;
			$genome=$1.".".$2;
			#print "$name\t$st1[4]\n\n";
			$st1[0]=~s/gi//;
			$newtree.=$name.":";
#			$st1[4]=~s/\_/ /g;	
			($type,$color)=getColor($name);	
			my $nombre=names($genome,$genomeName);	
			my $copias=copies($genome,$genomeCopies);	
			print FILE "$name\t$type\t$color\tcircle\t$nombre\t$st1[4]\t$copias\tCopies___colour\tcircle\n";
			#print FILE "$name\t$st1[4]\n";	
			}
		elsif($long=~/CENTRAL/ ){
			my @st1=split(/\|/,$long);
			$name=$st1[0]."_".$st1[2];
	                $name=~s/\(//g;	
	                $name=~s/\d*\.\d*,CENTRAL/CENTRAL/g;	
			#print "$name\t$st1[2]\n\n";
#			($type,$color)=getColor($name);		
			$newtree.="(".$name.":";
			$st1[2]=~s/\_/ /g;	
			print FILE "$name\tSeed Enzyme\tOrange\tcircle\t$st1[3]\tFunction\tCopies\tCopies___colour\tcircle\n";
			#print FILE "$name\t$st1[2]\n";	
			}
		elsif($long=~/BGC/){
			
			my @st1=split('BGC',$long);
			my $last=$st1[$#st1];
			$name="BGC".$last;
			($type,$color)=getColor($name);		
			#print "$name\tMIBiG\n";
			$newtree.=$st1[0].$name.":";
			#print FILE "$name\t$last\n";	
			print FILE "$name\t$type\t$color\tcircle\tBGC\tNatural Products\t1\tCopies___colour\tcircle\n";
			}
		else{
			$newtree.=$long.":";
		}
		}
	print TREE2 $newtree;
	}
close TREE;
close TREE2;
close FILE;
}
#-----------------------------------------------------
sub fill{
my $LEAVES=shift;
my $map=shift;
open(FILE,$map) or die "No pude abrir $map \n $!";
system("perl -i -ne 'print if /\\S/' $map ");
foreach my $line(<FILE>){
	chomp $line;
	#print "Line $line\n";
	$line=~s/\|/_/g;
	my @st=split(' ',$line);
	my $key="";
	
	if($line=~/orange/)	{
		$key="orange";
#		print "Line $line\n";
		shift @st;
		shift @st;
		shift @st;
		shift @st;
       #line "<circle style='fill:orange;stroke:black' r='9'/>" I CENTRAL3PGA_AMINOACIDS_Mtub
		}
	elsif ($line !~/circle/){
		shift @st;
		$key=shift @st;
		shift @st;
		$key=~s/stroke://g;
		$key=~s/"//g;
		$key=~s/;//g;
		}
	else {#"<circle style='fill:purple;stroke:black' r='9'/>" I
		shift @st;
		my $pre=shift @st;
		shift @st;
		shift @st;
		$pre=~s/style=\'fill://;
		$pre=~s/stroke:black\'//;
		$key=$pre;
		$key=~s/;//g;
		}
	#my $pause=<STDIN>;

#		print "line $line\n";
#		print "key $key\n";		
#		my $pause=<STDIN>;

	my @unique_leaves;
	my @rename;
	unless($key=~m/blue/ or $key=~/orange/){
#		print "No soy azul\n";
		foreach my $element (@st){
			#chomp $element;
			$element=~s/(\d*)\.(\d*)\.(\d*)_(\w*)//;
			$element=$1.".".$2.".".$3;
#			print "Elem $element";
			push(@rename,$element);
			#if($key=~/cyan/){
#				print "$line\n";
			#	print "Soy verde\n";
	#			print "key $key Elemento $element\n";
			#	}
			#print "Renombrado $element\n";
		#	my $pause=<STDIN>;
			}
		}
	if($key=~/blue/ or $key =~/orange/){ 
		@rename=@st;
		#foreach my $element (@rename){
		#	print "key $key Elemento $element\n";
		#	}
		}

	if(!exists $LEAVES->{$key}){
		$LEAVES->{$key}=();	
		@unique_leaves = uniq @rename;
#		foreach my $elem(@rename){print "$key $elem\n";}
		#my $pause=<STDIN>;	
	}
	else{
		push (@{$LEAVES->{$key}},@rename);
		@unique_leaves = uniq @{$LEAVES->{$key}};
		#foreach my $elem(@rename){print "$key $elem\n";}
		#my $pause=<STDIN>;	
		}
	@{$LEAVES->{$key}}=@unique_leaves;	

	}
close FILE;
}


#------------------------------------------------------------
sub getColor{
	my $leave=shift;
	my $color="Gray";
	my $type="expansion";
	foreach my $key(keys %LEAVES){
		
#		if($key=~/lue/ and $leave =~/BGC/){
#			print "key $key\n";
#			print "LEAVE $leave\n";
#			my $pause =<STDIN>;

#			foreach my  $bg (@{$LEAVES{$key}}){
#				print "UF bg $bg\n";
#				}
#	 		my $pause =<STDIN>;
#		}

		if($leave=~/CENTRAL/){
			$color="Orange";
			if($color eq "orange"){$color="Orange";$type="Seed sequence";}
			next;
			}
		
		if ($leave~~@{$LEAVES{$key}}){
			$color=$key;
		#	print $color;
		# $pause=<STDIN>;
		if($color eq "red"){$color="Red";$type="Central metabolism";}
		if($color eq "blue"){$color="Blue";$type="Recruited Enzyme (MIBiG)";}
		if($color eq "cyan"){$color="Cyan";$type="Secondary metabolsim (antiSMASH)";}
		if($color eq "gray"){$color="Gray";$type="Expansion";}
		if($color eq "purple"){$color="Purple";$type="Transition Enzyme (antiSMASH and Central metabolism)";}
		if($color eq "#a5bb47"){$type="Secondary metabolism (EvoMining Hit)";}
			next;
			}
		}

	#my $pause=<STDIN>;
	return ($type,$color);
}
#my %DATA; #name, type, color,shape,function 
