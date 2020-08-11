#!/usr/bin/perl -w
use CGI::Carp qw(fatalsToBrowser);
use List::MoreUtils qw(uniq);
use CGI;
use globals;
use Fcntl ; use DB_File ; $tipoDB = "DB_File" ; $RWC = O_CREAT|O_RDWR;



my %Input;
my $query = new CGI;
my @pairs = $query->param;

foreach my $pair(@pairs){
$Input{$pair} = $query->param($pair);
}

print $query->header,
      $query->start_html(-style => {-src => '/EvoMining/html/css/tabla3.css'} );

 #$tfm = "/var/www/newevomining/blast/BBH/hashMETCENTRAL22.db" ;
 my $apacheCGIpath=$APACHE_CGI_PATH;
 my $newickPATH="/opt/newick-utils-1.6/src";
 my $apacheHTMLpath=$APACHE_HTML_PATH;
 
 $genomes =$GENOMES; #from globals
 $tfm = $TFM ; #from globals
 $np_db=$NP_DB ; #from globals
 
 #$genomes ="los30"; #
 #$tfm = "hashMETCENTRAL$genomes.db"; 
 

#exit(1);
 
 $hand = tie  %hashMETCENTRAL, $tipoDB , "$tfm" , 0 , 0644 ;

 #my $tfmAsmash= "$OUTPUT_PATH/hashANTISAMASandCF$GENOMES.db" ;
my $tfmAsmash= "$OUTPUT_PATH/hashANTISAMASandCF.db" ;


$handAM = tie my %hashANTISMASHid, $tipoDB , "$tfmAsmash" , 0 , 0644 ;
print "$! \nerror tie para $tfmAM \n" if ($handAM eq "");

$prenumFile=$ENV{'QUERY_STRING'};
@arraynumFile=split(/&&/,$prenumFile);
$numFile=$arraynumFile[0];
$OUTPUT_PATH=$arraynumFile[1];
########################ANTISMASH###################################

#@filesanti=`ls $apacheCGIpath/blast/seqf/tree/antismashPAblo/`;
#foreach my $x( @filesanti){
#  chomp($x);
#  open(SMASH,"$apacheCGIpath/blast/seqf/tree/antismashPAblo/$x");
#  #print "--$x--\n";
#  while(<SMASH>){
#    chomp;
#    @asmash=split (/\t/,$_);
#    @bsmash=split (/\|/,$asmash[1]);
#    @csmash=split (/\_/,$bsmash[0]);
#    $hashANTISMASHid{$csmash[1]}=$csmash[1];
#    #print  "$csmash[1]\n";
#    #<STDIN>;
#   
#  }
#  close SMASH;
#  
#}
######################## END ANTISMASH###################################

#-----------------------indexado de NP-----------------------------------
open (NP,"$apacheCGIpath/NPDB/$np_db")or die "$apacheCGIpath/NPDB/$np_db, $!";

while(<NP>){
 chomp;
 if($_ =~ />/){
  $_ =~ s/>//;
  $hashNP{$_}=$_;
 }

}
close NP;

#--------------------FIN de indexado de NP-------------------------------

#system "cp $apacheCGIpath/$OUTPUT_PATH/blast/seqf/tree/ornament.$numFile $apacheCGIpath/$OUTPUT_PATH/blast/seqf/tree/ornament.$numFile.edit";

chdir "$OUTPUT_PATH/blast/seqf/";


system "nw_labels -I $OUTPUT_PATH/blast/seqf/tree/$numFile.tree > $OUTPUT_PATH/blast/seqf/tree/$numFile.labels";
open (LABELS, "$OUTPUT_PATH/blast/seqf/tree/$numFile.labels")or die $!;
open (OUTLABELS, ">$OUTPUT_PATH/blast/seqf/tree/$numFile.mapp")or die $!;


$cuentaNum=0;
while (<LABELS>){
    chomp;
    #print OUTLABELS "$_	METcentral\n";
        
    $cuentaNum++;
    $nameG=$_;
    #$nameG=~ s/\d+\|//;
    @giA=split(/\|/,$_);
    $nameG=$giA[$#gia];
    
   #my  $ALL_ids='';
    
    ########################### ANTISMASH ##############
  
       if(exists $hashANTISMASHid{$giA[1]} and !exists $hashMETCENTRAL{$giA[1]} ){
         $keyAM="$giA[1]"."|"."$giA[$#giA]";
	  $antSMASHstring=$antSMASHstring.'"stroke-width:7; stroke:cyan" Individual '.$keyAM."\n";
          $antSMASHcircle=$antSMASHcircle. qq|"<circle style='fill:cyan;stroke:black' r='9'/>" I $keyAM\n|;
         
       }
      if(exists $hashMETCENTRAL{$giA[1]} and exists $hashANTISMASHid{$giA[1]}){
         $keyAM="$giA[1]"."|"."$giA[$#giA]";
	 $antSMASHstring=$antSMASHstring.'"stroke-width:7; stroke:purple" Individual '.$keyAM."\n";
         $antSMASHcircle=$antSMASHcircle. qq|"<circle style='fill:purple;stroke:black' r='9'/>" I $keyAM\n|;
            	}
   
    ###########################FIN  ANTISMASH ##############

 
  
    #-------------------NP--------------------------------
    if(exists $hashNP{$giA[0]}){
        $NPs=$NPs.'"stroke-width:7; stroke:blue" Individual '.$_."\n";
        $NPc=$NPc. qq|"<circle style='fill:blue;stroke:black' r='8'\/>" I $_\n|;
     }
     else{
         $ALL_ids=$giA[1].'|'.$giA[$#giA];
	
	
	    #------------------FIN NP-----------------------------
 
	    ######################################## 
	    #------****MEtabolismo central***-------
	    ########################################
 
           if(exists $hashMETCENTRAL{$giA[1]} and !exists $hashANTISMASHid{$giA[1]}){
            	$METcentral=$giA[1].'|'.$giA[$#giA];
	   	print OUTLABELS "$_	$METcentral\n";
             	push(@QC, $METcentral);
		}
	     elsif($giA[0]=~/CENTRAL/){
		print OUTLABELS "$_	$giA[0]|$giA[3]\n";
		$keyCENT=$giA[0]."|".$giA[3];
		$CENTRALcircle=$CENTRALcircle. qq|"<circle style='fill:orange;stroke:black' r='9'/>" I $keyCENT\n|; ## Circle for seed central pÃ¡thway
	  	$CENTRALstring=$CENTRALstring.'"stroke-width:7; stroke:orange" Individual '.$keyCENT."\n";
		}
             else{
	     	  print OUTLABELS "$_	$ALL_ids\n";
		#  	  print "CENTR ?? $_	$ALL_ids\n";
               #
             }
    	   # print OUTLABELS "$_	$ALL_ids\n";


     }
    
 
}#end while LABELS
close LABELS;
close OUTLABELS;



open (EDIT, ">>$OUTPUT_PATH/blast/seqf/tree/ornament.$numFile") or die $!;
foreach my $cc (@QC){
	##print "siiiiii/$METcentral\n";
 	print EDIT "\n";
 	if($cc =~/\./ or $cc eq '' or $cc eq ' '){
  		#next;
 		}
 		print EDIT $NPc;
 		print EDIT qq|"<circle style='fill:red;stroke:black' r='6'/>" I $cc|; ## circle for CEntral pathway
 		print EDIT "\n";
		}
print EDIT $antSMASHcircle;
print EDIT $CENTRALcircle;
close EDIT;

open (MAP, "$OUTPUT_PATH/blast/seqf/tree/ornament.$numFile") or die $!;
open (OUTMAP, ">$OUTPUT_PATH/blast/seqf/tree/$numFile.map") or die $!;

while(<MAP>){
 	chomp;
 	#=================== extrae known recruitments para tener la lista y procesar evoMining predictions=========
 	if($_ =~ /"<circle style='fill:blue;stroke:black' r='8'\/>" I /){
   		$stringKR=$_;
		#   print KR "-----$_\n";
   		$stringKR=~ s/"<circle style='fill:blue;stroke:black' r='8'\/>" I //;
   		@knownRecruitments=split(/ /,$stringKR);
   		foreach my $x (@knownRecruitments){
     			$hashKR{$x}=$x;
     			#print KR "$x\n";
   			}

 		}

	 #===================  FIN extrae known recruitments para tener la lista y procesar evoMining predictions=========
	 $_ =~ s/"<circle style='fill:blue;stroke:black' r='8'\/>" I/"stroke-width:7; stroke:blue" Individual/;
	 $_ =~ s/"<circle style='fill:red;stroke:black' r='6'\/>" I/"stroke-width:6; stroke:red" C/;
	 print OUTMAP "$_\n";
	}
print OUTMAP $antSMASHstring;
print OUTMAP $CENTRALstring;
close OUTMAP;
close MAP;
#----------------------- analiza KR con nw_clade-------
open (KR, ">$OUTPUT_PATH/blast/seqf/tree/$numFile.kn") or die $!;
open (KRR, ">$OUTPUT_PATH/blast/seqf/tree/$numFile.krr") or die $!;
open (OUTKRR, ">$OUTPUT_PATH/blast/seqf/tree/$numFile.pruebaKR") or die $!;
 $numClades=-1;
while($numClades<30){
 	$numClades++;
  	foreach my $y (keys %hashKR){
      		@listClade = `nw_clade -c $numClades $OUTPUT_PATH/blast/seqf/tree/$numFile.tree $y|nw_labels -I -`; 
      		foreach my $x (@listClade){
		        chomp($x); 
	
			if($x !~ /\|/){
	 		 	next;  # si no es un gi|genoma # seria un NP KR
			}
			#print OUTKRR "$y->$numClades->$x->$cadenaKR\n";
	
			@gi_genoma=split (/\|/,$x);
			print OUTKRR "$gi_genoma[1]\n";
			$ID_genome="$gi_genoma[1]|$gi_genoma[$#gi_genoma]";
			$hashIDT{$gi_genoma[1]}=$ID_genome;
			#$hashIDT{$gi_genoma[1]}=$x;
	
        		if (!exists $hashMETCENTRAL{$gi_genoma[1]} and !exists $hashANTISMASHid{$gi_genoma[1]}){
				   $cadenaKR=$hashIDT{$gi_genoma[1]}." ".$cadenaKR;
				   $flagcadenaKR=1;#print OUTKRR "$gi_genoma[0]--$x--$hashMETCENTRAL{$gi_genoma[0]}--$hashANTISMASHid{$gi_genoma[0]}\n"; 
					}
			if(exists $hashMETCENTRAL{$gi_genoma[1]}){
				   $cadenaKR='';
				   delete $hashKR{$y};
				   $flagcadenaKR=0;
				   print OUTKRR "ES ROJOO:$gi_genoma[1]--$hashMETCENTRAL{$gi_genoma[1]}\n";
				  last;
				}
	
	
     			 }#end clade
      
	      if($flagcadenaKR==1){#print OUTKRR "lalalalal$flagcadenaK--$cadenaKR\n";
        		 print KRR qq|"<circle style='fill:#a5bb47;stroke:black' r='8'\/>" I $cadenaKR\n\n|;
		         print KR qq|"stroke-width:8; stroke:#a5bb47" Individual $cadenaKR\n|;
		        # print KR "-------$y\n";
			      } 
       		$cadenaKR='';
       		$flagcadenaKR=0;
      		#$cadenaKR=$y." ".$cadenaKR;
	   }#end foreach @listClade 
	 }#end while
 
  # print KR "$cadenaKR\n";
close KR; 
close KRR;
close OUTKRR;
system "cat $OUTPUT_PATH/blast/seqf/tree/$numFile.krr $OUTPUT_PATH/blast/seqf/tree/ornament.$numFile >$OUTPUT_PATH/blast/seqf/tree/ornament2.$numFile";  
system "cat $OUTPUT_PATH/blast/seqf/tree/$numFile.map $OUTPUT_PATH/blast/seqf/tree/$numFile.kn>$OUTPUT_PATH/blast/seqf/tree/$numFile.map2";  
#----------------------- END  analiza KR con nw_clade-------

#system "nw_rename -l tree/$numFile.tree tree/$numFile.map";
system "nw_rename -l $OUTPUT_PATH/blast/seqf/tree/$numFile.tree $OUTPUT_PATH/blast/seqf/tree/$numFile.mapp |nw_display -w 10600 -sr  -S -v 100 -i 'font-size:xx-small' -b 'opacity:0' -i 'visibility:hidden' -c $OUTPUT_PATH/blast/seqf/tree/$numFile.map2 -o $OUTPUT_PATH/blast/seqf/tree/ornament2.$numFile ->$OUTPUT_PATH/blast/seqf/tree/$numFile.pp.svg";
#################### Nelly agregado prueba Feb 16 ######################
##########################################################################
system "mkdir $OUTPUT_PATH";
 `perl -p -i.back -e 's/>/>\n/g' $OUTPUT_PATH/blast/seqf/tree/$numFile.pp.svg`;
 
`rm $OUTPUT_PATH/$numFile.idForcontext`;
 `perl $apacheCGIpath/blast/seqf/tree/zoom/ScaleSvg.pl $OUTPUT_PATH/blast/seqf/tree/$numFile.pp.svg `;
#system("cp $OUTPUT_PATH/blast/seqf/tree/$numFile.pp.svg $OUTPUT_PATH/blast/seqf/tree/$numFile.pp.svg.new");
my $special="NCPPB382s";
 `perl -p -i.back -e 's{>\$}{ fill="violet">} if /$special/ && /sendtoDrawContext/' $OUTPUT_PATH/blast/seqf/tree/$numFile.pp.svg.new`;
#system("cp $OUTPUT_PATH/blast/seqf/tree/$numFile.pp.svg $OUTPUT_PATH/blast/seqf/tree/$numFile.pp.svg.new");
# system "cp $OUTPUT_PATH/blast/seqf/tree/$numFile.pp.svg.new $OUTPUT_PATH/$numFile.pp.svg.new";

################################################################################33
###########################3 microreact #####################################################

#use List::MoreUtils qw(uniq);
no warnings 'experimental::smartmatch';
# ussage 
# $c =10
#perl data.pl $c
#print "hello world ";
#print "que pasa oh"; 
#`echo tristeza >microLOG`;
#exit;
#print "$OUTPUT_PATH\n";
############################# Reaading files
my $num=$ARGV[0]; #Family number
my $map="$OUTPUT_PATH/blast/seqf/tree/$numFile.map2";
my $tree="$OUTPUT_PATH/blast/seqf/tree/$numFile.tree";
my $GenomeFile=$GENOMES; ##GENOMES FROM CENTRAL
#print "$map\n$tree\n";

############################################################################
my %LEAVES;
fill(\%LEAVES,$map); #Read colors on tree ids =genoemeId.GenId color->{Id1,Id2,...}
addGray(\%LEAVES,$tree);
my %GENOMESNUM=fillGenomes(\%LEAVES);
my %GENOME_NAME=GenomeNames(\%GENOMESNUM);
###########names('6666666.146852',\%GENOME_NAME);
## Change names on tree
treeNames($tree,$numFile,\%GENOMESNUM,\%GENOME_NAME);
#exit;

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
	my $path="$apacheCGIpath/RAST/$GenomeFile"."Rast.ids";
	open (RAST,"$path") or die "No pude abrir $path $!";
		foreach my $line (<RAST>){
			chomp $line;
#			$line=~s/\r//;
#			my @st=split(/\t/,$line);
			$line=~s/\d*\t\s*(\d*)\.(\d*)\s*\t*//;
			my $genome=$1."_".$2;
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
#			print "key $key:Elem:$elem\t";
			if($elem=~/(\d*)_(\d*)_(\d*)/){
				$genome=$1."_".$2;
				
				#$genome=~s/\./_/;
				if(!exists $GENOMES{$genome}){
					$GENOMES{$genome}=1;
					}
				else{
					$GENOMES{$genome}=$GENOMES{$genome}+1;
					}
				}
#				print "$genome\t$GENOMES{$genome}\n";
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
#				print "long $long\n";
				my @st1=split(/\|/,$long);
				$st1[1]=~s/(\d*)\.(\d*)\.(\d*)//;
				my $name=$1.".".$2.".".$3;
				my $genome=$1."_".$2;
				$name=~s/\./_/g;
#				print "Name $name Genome $genome\n";
#				print "pause"; my $pause=<STDIN>; 
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
#-------___________--------------------------
sub treeNames{
	my $tree=shift;
	my $num=shift;
	my $genomeCopies=shift;
	my $genomeName=shift;

	open(TREE,$tree) or die "No pude abrir $tree \n $!";
	open (FILE,">$OUTPUT_PATH/blast/seqf/tree/$num.csv") or die "Num $num $!";
	print FILE"Id\tMetabolism\tMetabolism__colour\tMetabolism__shape\tGenome\tFunction\tCopies__autocolour\n";
	open (TREE2,">$OUTPUT_PATH/blast/seqf/tree/$num.nwk") or die $!;

	foreach my $line (<TREE>){
	chomp $line;
	#print "Line $line\n";
	my @st=split(':',$line);
	my $newtree="";
	foreach my $long(@st){
		my $name="";
		my $color="";
		my $type="";
		my $genome="";
#		print "$long\n";
		if($long=~/gi/ and !($long=~/CENTRAL/)){
	#		print "long gi $long <br>";
			my @st1=split(/\|/,$long);
			chomp $long;
			$st1[1]=~s/(\d*)\.(\d*)\.(\d*)//;
			$name=$1."_".$2."_".$3;
			$genome=$1."_".$2;
			#print "$name\t$st1[4]\n\n";
			$st1[0]=~s/gi//;
			$newtree.=$st1[0].$name.":";
#			$st1[4]=~s/\_/ /g;	
			($type,$color)=getColor($name);	
			my $nombre=names($genome,$genomeName);	
			my $copias=copies($genome,$genomeCopies);
			$nombre=~s/\r//g;
			my $function=$st1[4];	
			$function=~s/\r//g;
			print FILE "$name\t$type\t$color\tcircle\t$nombre\t$function\t$copias\n";
			#print "$name#$type#$color#circle#$nombre#$function#$copias<br>";
			#print FILE "$name\t$st1[4]\n";	
			}
		elsif($long=~/CENTRAL/ ){
			print "Long $long <br>";
			my @st1=split(/\|/,$long);
#			my @st2=split();
			$name=$st1[0]."_".$st1[2];
			$newtree.=$name.":";
	                $name=~s/\(//g;	
	                $name=~s/\d*\.\d*,CENTRAL/CENTRAL/g;	
			#print "$name\t$st1[2]\n\n";
#			($type,$color)=getColor($name);		
#			$st1[2]=~s/\_/ /g;	
			print FILE "$name\tSeed Enzyme\tOrange\tcircle\t$st1[3]\tFunction\t1\n";
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
			print FILE "$name\t$type\t$color\tcircle\tBGC $name\tNatural Products\t1\n";
			}
		else{
			$newtree.=$long.":";
			}
#		print "$newtree\n\n";
	#	print "pausa"; 
#		my $ST=<STDIN>;
		}
	chop $newtree;
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
			$element=~s/\./_/g;
#			print "Elem $element\n";
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


#my %DATA; #name, type, color,shape,function 
########################################33 Fin Nelly ##########################3


open(OPT, ">$OUTPUT_PATH/blast/seqf/tree/$numFile.prueba2.svg")or die $!;
open(OP, "$OUTPUT_PATH/blast/seqf/tree/$numFile.pp.svg.new")or die $!;
 $cuentasust=0;
 while(<OP>){
  #$_ =~ s/<defs>/<script xlink:href="SVGPan\.js"/>/;
  $string=$string.$_; 
  $tempo=$string;
  if($cuentasust==0){
   $tempo =~ s/<defs>/<defs><script xlink\:href\=\"SVGPan\.js\"\/>/;
  
  }
  $cuentasust++;
  print OPT "$tempo";
 }

#$OUTPUT_PATHANDfile="$OUTPUT_PATH"."xxx"."$numFile";
#$OUTPUT_PATHANDfile="$OUTPUT_PATH";
$out_for_apache=$OUTPUT_PATH;
$out_for_apache=~s/\/var\/www\/html//;
print qq¬
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Evolution - inspired Genome Mining Tool</title>
    <link rel="shortcut icon" href="images2/favicon.ico" type="image/x-icon">
    <link rel="icon" href="images2/favicon.ico" type="image/x-icon">
    <!-- Bootstrap -->
    <link href="/EvoMining/html/css2/bootstrap.min.css" rel="stylesheet">
    <link href="/EvoMining/html/css2/estilo.css" rel="stylesheet" type="text/css">
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-63898104-1', 'auto');
  ga('send', 'pageview');

</script>
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
 
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script type="text/javascript">
    function target_popup(form) {
    window.open('', 'formpopup', 'width=400,height=200,resizeable,scrollbars');
    form.target = 'formpopup';
   }
   </script>
  </head>
  <body>

  <!-- header -->
  <div class="container-fluid" id="banner"><img src="/EvoMining/html/images2/banner.png" width="940" height="140"></div>
  <!-- header -->
  <div class="container"> <!-- CONTENEDOR PRINCIPAL 12col -->

    <div class="col-md-9">
      <table class="table table-bordered">
        <tr>
          <td>
            <object type="image/svg+xml" name="viewport" data="$out_for_apache/blast/seqf/tree/$numFile.pp.svg.new" width="100%" height="500"></object>
            <script type="text/javascript">
            $(document).ready(function() {
            $('svg#outer').svgPan('viewport');
            });
            </script>
          </td>
        </tr>
      </table>
    </div>
      <div class="col-md-3">
        <table class="table table-bordered">
          <tr>
            <td>
              <h4 id="verde">Color Code</h4>
                <form action="commentlog.pl" onsubmit="target_popup(this)" target="_blank" method="post">
                <div class="ratio">
                      <body>
    <canvas id="myCanvas" width="11" height="18"></canvas>
    <script>
      var canvas = document.getElementById('myCanvas');
      var context = canvas.getContext('2d');
      var centerX = canvas.width / 2;
      var centerY = canvas.height / 2;
      var radius = 3;

      context.beginPath();
      context.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
      context.fillStyle = 'red';
      context.fill();
      context.lineWidth = 5;
      context.strokeStyle = 'red';
      context.stroke();
    </script> Orthologs from Central Metabolism
                    </br>
                    <canvas id="myCanvas2" width="12" height="18"></canvas>
    <script>
      var canvas = document.getElementById('myCanvas2');
      var context = canvas.getContext('2d');
      var centerX = canvas.width / 2;
      var centerY = canvas.height / 2;
      var radius = 3;

      context.beginPath();
      context.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
      context.fillStyle = 'blue';
      context.fill();
      context.lineWidth = 5;
      context.strokeStyle = 'blue';
      context.stroke();
    </script> Known recruitments
                    </br>
                    <canvas id="myCanvas3" width="11" height="18"></canvas>
    <script>
      var canvas = document.getElementById('myCanvas3');
      var context = canvas.getContext('2d');
      var centerX = canvas.width / 2;
      var centerY = canvas.height / 2;
      var radius = 3;

      context.beginPath();
      context.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
      context.fillStyle = 'cyan';
      context.fill();
      context.lineWidth = 5;
      context.strokeStyle = 'cyan';
      context.stroke();
    </script> EvoMining Hits (Detected by antiSMASH/Clusterfinder)
     </br>
                    <canvas id="myCanvas4" width="11" height="18"></canvas>
    <script>
      var canvas = document.getElementById('myCanvas4');
      var context = canvas.getContext('2d');
      var centerX = canvas.width / 2;
      var centerY = canvas.height / 2;
      var radius = 3;

      context.beginPath();
      context.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
      context.fillStyle = '#a5bb47';
      context.fill();
      context.lineWidth = 5;
      context.strokeStyle = '#a5bb47';
      context.stroke();
    </script> EvoMining Predictions
                    </br>
                     <br>
                  
		  
                </div>
               <hr>
Send us your comments:
<p><label>E-mail: <input name="email" type="text" size="20" maxlength="254" /></label></p>
<p><label>Comment:<br /><textarea name="Comment" rows="3" cols="20"></textarea></label></p>
<p><input type="submit" value="Send Comment"  /></p>
</fieldset>

<input type='hidden' name="required" value="email,Comment" />
<input type="hidden" name="env_report" value="REMOTE_HOST,HTTP_USER_AGENT" />
<input type="hidden" name="hidden" value="Referring_Page_Link,Referring_Page_Title" />
<input type="hidden" name="Referring_Page_Link" value="http://www.google.com.mx/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0CB0QFjAAahUKEwjHnbS5y4jGAhVODZIKHfzYANE&url=http%3A%2F%2Frevcom.us%2Fcommentform-en.php&ei=Nf55VYevI86ayAT8sYOIDQ&usg=AFQjCNFStLEMrNFcowXzUW7P3ZxteK5duA&bvm=bv.95277229,d.aWw">

<input type='hidden' name="redirect" value="http://revcom.us/commentsthanks.php" />
<input type="hidden" name="Referring_Page_Title" value="" />
<input type="hidden" name="subject" value="Comments Re: " />

                </form>
            </td>
          </tr>
        </table>
      </div>
 

      <div class="container-fluid" id="centrado">
        <tr>
          <td>
<p>

<IFRAME SRC="/EvoMining/cgi-bin/sendtoDrawContext.pl?$OUTPUT_PATH" name="iframe_abajo" WIDTH=810 HEIGHT=350 FRAMEBORDER=0 >  </IFRAME>





  </div>  <!-- CONTENEDOR PRINCIPAL 12col -->

  <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>
¬;
 


# print qq|
#  <html>
# <head>
# <title></title>
# </head>
# <body>/$string/
# <div class="container"> <!-- CONTENEDOR PRINCIPAL 12col -->
# <div class="col-md-8">
# <table class="table table-bordered">
# <object type="image/svg+xml" name="viewport" data="tree/$numFile.pp.svg" width="1730" height="1500"></object>
# <script type="text/javascript">
#  $(document).ready(function() {
#  $('svg#outer').svgPan('viewport');
#   });
#   </script>
#   </table>
#   </div>
#  </div>  <!-- CONTENEDOR PRINCIPAL 12col -->
#|;
 
#print qq|

# </body>
# </html>|;
  exit; 

