use strict;
use warnings;


########3 Nota necesito corregir que lea la cantidad total de genes del archivo total de base de datos de genomas.
## This script generates one images with all the ids on file

`rm *.input`;
#print "Number of contexts $NumberContexts\n";
my $fileNames="RAST/RAST.ids"; ##File with genome ids RASt.ids
#my @gen_id=@ARGV; ##File with genome ids to get the contexts
open (ERROR, ">Error") or die $!;

#print "$ARGV[0]\n";

#print "0:$div[0], 1:$div[1]\n";
my $apacheHTMLpath="/var/www/html/EvoMining/exchange";
my $Folder=$ARGV[0];
chomp($Folder);
$Folder =~ s/\r|\s//g;
chomp($Folder);
my @gen_id;
@gen_id=@ARGV;
print ERROR "este es el contenido !$gen_id[0]! !$Folder!\n";

#print "Reading $file\n";
my %LIST;
my %NAMES;
my $long=80000;
my $ClusterSize=100; ##Gen number around

print "$fileNames\n";
#print "$ARGV[0],$ARGV[1]!\n";

###################### Main ########################################
	read_list($fileNames,\%LIST,\%NAMES,@gen_id);
	#my $pause=<STDIN>;
	foreach my $gi (keys %LIST){
		my $gi_file=$LIST{$gi};
		print "working on $gi on $gi_file\n";
		ContextArray($gi_file,$gi,$long,\%NAMES);
		}
######################################################################
###################### Subs ##########################################

#____________________________________________________________________________________________
sub ContextArray{
	my $orgs=shift;
	my $peg=shift;
	my $long=shift;
	my $refNAMES=shift;	

	open(FILE,">$apacheHTMLpath/$Folder/$peg.input")or die "could not open $orgs.input file $!";
	my @CONTEXT;

	my ($hit0,$start0,$stop0,$dir0,$func0,$contig0)=getInfo($peg,$orgs);
	my $midle0=int(($start0+$stop0)/2);
	#my $sizeFile=`grep '>' $orgs.faa | wc`;
	#print "Total $sizeFile";

	$CONTEXT[0]=[$hit0,$start0,$stop0,$dir0,$func0];
	print FILE "$CONTEXT[0][1]\t$CONTEXT[0][2]\t$CONTEXT[0][3]\t1\t$refNAMES->{$peg}\t$CONTEXT[0][4]\t$CONTEXT[0][0]\n";
	my $count=1;	
	my @sp=split(/\./,$peg);
	my $genId=$sp[2];
	
	for (my $i=$genId-$ClusterSize;$i<$genId+$ClusterSize;$i++){
		my $neighbourId=$sp[0].".".$sp[1].".".$i;
		my ($hit,$start,$stop,$dir,$func,$contig)=getInfo($neighbourId,$orgs);
		if(!($hit eq "")){				
			my $midle=int(($start+$stop)/2);
			my $dist=abs($midle-$midle0);
			if($dist<$long){
				if($contig0 eq $contig){
					$CONTEXT[$count]=[$hit,$start,$stop,$dir,$func];
					}
				}
			if ($contig0 eq $contig and $i!=$genId){
  				#print "$contig0 $contig\n";
				print FILE "$CONTEXT[$count][1]\t$CONTEXT[$count][2]\t$CONTEXT[$count][3]\t0\t$refNAMES->{$peg}\t$CONTEXT[$count][4]\t$CONTEXT[$count][0]\n";		
				$count++;
				}
			}
		}
close FILE;
}





sub getInfo{
	print "GetInfo\n";
	my $gen=shift;
	my $file=shift;
	print "file $file\n";
	print "Gen $gen\n";
	my @sp0=split(/\./,$gen);
	my $peg=$sp0[0].".".$sp0[1].".peg.".$sp0[2];
	print "peg $peg sp2 $sp0[2]\n";	
	
	print " Grep  grep 'peg.$sp0[2]\t' RAST/$file.txt \n";
	my $Grep=`grep 'peg.$sp0[2]\t' RAST/$file.txt`;

	my @sp=split("\t",$Grep);
	my $contig="";	
	my $hit="";
	my $start="";
	my $stop="";
	my $dir="";
	my $func="";
	if($sp[7]){
 		$contig=$sp[0];	
		$hit=$sp[1];
		$start=$sp[4];
		$stop=$sp[5];
		$dir=$sp[6];
		$func=$sp[7];
		}
	#print "hit $hit start $start stop $stop dir $dir func $func cont $contig\n\n";	
	return ($hit,$start,$stop,$dir,$func,$contig);
}


#_________________________________________________________________________________
sub read_list{  ## Get the files where the genes belongs

	my $fileNames=shift;	
	my $refLIST=shift;
	my $refNAMES=shift;
	my @ID=@_;
        my $pwd =`pwd`;
	#open (FILE, $file) or die "Could not open file $file \n $!";

	for my $gen_id (@ID){
	#	chomp $line;
		#print "$line\n";
		my @sp=split(/\./,$gen_id);

		if ($sp[0] and $sp[1]){
			print("0:$sp[0],1:$sp[1],2:$sp[2]\n");
			my $genome=$sp[0].".".$sp[1];
			open (NAMES,$fileNames) or die "Could not open names file\n $fileNames-$pwd-$!";
			print "Reading file names from $fileNames-$pwd\n-";
				for my $line2 (<NAMES>){
					chomp $line2;
					my @sp2=split(/\t/,$line2);
					if($line2=~/$genome/){
						print "$line2\t field1:$sp2[0]\tfield2:$sp2[2]\n";
						$refLIST->{$gen_id}=$sp2[0];
						$refNAMES->{$gen_id}=$sp2[2];
						last;
					 	}
					close NAMES;
					}						
				}
			}
	#close FILE;	
	}
