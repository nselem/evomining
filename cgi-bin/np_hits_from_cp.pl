#!/usr/bin/perl -w
#####################################################
# CODIGO PARA hacer Blast Vs NP
#
#####################################################

##use strict;
use CGI::Carp qw(fatalsToBrowser);
use CGI;
use Statistics::Basic qw(:all);
use globals;
############################## def-DBM #################################
use Fcntl ; use DB_File ; $tipoDB = "DB_File" ; $RWC = O_CREAT|O_RDWR
;
############################## def-SUB  ################################
my %Input;
my $query = new CGI;

my $via_met=$VIA_MET; # From globals
my $np_db=$NP_DB;	#From globals

my $tfm = "$OUTPUT_PATH/mi_hashNombrePorNum.db" ;	
$hand = tie my %NombresPorNum, $tipoDB , "$tfm" , $RWC , 0644 ;
print "$! \nerror tie para $tfm \n" if ($hand eq "");

my $tfm2 = "$OUTPUT_PATH/mi_hashNUMVia.db" ;
$hand2 = tie my %hashNUMVia, $tipoDB , "$tfm2" , 0 , 0644 ;
print "$! \nerror tie para $tfm2 \n" if ($hand2 eq "");

 
print $query->header,
      $query->start_html(-style => {-src => '/EvoMining/html/css/tabla2.css'} );
my @pairs = $query->param;
foreach my $pair(@pairs){
$Input{$pair} = $query->param($pair);
}


############### Recovering previous session ##########################
my $prev_heat=`grep 'Heatplot' $OUTPUT_PATH/EvoMining.log`;  ##Heatplot done
my $prev_np=`grep 'np_hits_from_cp' $OUTPUT_PATH/EvoMining.log`; ##np done

if ($prev_heat){
#	print "Previously done $prev_heat ";
#	print "Previously done $prev_np ";
	}
else {
	print qq|<meta http-equiv="Refresh" content="0;url=../html/index.html" >|;
	exit;
}

if(!$prev_np){
`/opt/blast/bin/makeblastdb -in NPDB/$np_db -dbtype prot -out NPDB/$np_db.db`;
}
#`/opt/blast/bin/makeblastdb -in NPDB/$np_db -dbtype prot -out NPDB/$np_db.db`;
###########33 Reading Natural products metadata if exists file;
my %NP_META;
if (-e "NPDB/$np_db.meta"){
	open (NP_META, "NPDB/$np_db.meta")or die "Couldn't open $np_db.meta\n $!";
	foreach my $line (<NP_META>){
	chomp $line;
	my @st=split(/\t/,$line);
	$NP_META{$st[0]}=[$st[1],$st[2],$st[3],$st[4],$st[5]];
#	print qq|$st[0]<br>@{$NP_META{$st[0]}} <br>|;
#	print qq|#$st[0]!<br>|;
	}
}
####################################################################################
my $oldid;
($eval,$score2,$oldid)=recepcion_de_archivo(); #Iniciar la recepcion del archivo

#print "Im here 1:$eval 2:$score2 3:$OUTPUT_PATH!";
#exit;

system "touch $OUTPUT_PATH/prueba";

$hashothernames{'enolase2'}="enolase";
$hashothernames{'enolase1'}="enolase";
$hashothernames{'enolase4'}="enolase";
$hashothernames{'enolase3'}="enolase";
$hashothernames{'phosphoglyceratemutase1'}="phosphoglycerate mutase";
$hashothernames{'phosphoglyceratemutase2'}="phosphoglycerate mutase";
$hashothernames{'phosphoglyceratemutase3'}="phosphoglycerate mutase";
$hashothernames{'phosphoglyceratemutase4'}="phosphoglycerate mutase";
$hashothernames{'phosphoglyceratekinase1'}="phosphoglycerate kinase";
$hashothernames{'phosphoglyceratekinase2'}="phosphoglycerate kinase";
$hashothernames{'phosphoglyceratekinase3'}="phosphoglycerate kinase";
$hashothernames{'phosphoglyceratekinase4'}="phosphoglycerate kinase";
$hashothernames{'Triosephosphateisomerase1'}="Triosephosphate isomerase";
$hashothernames{'Triosephosphateisomerase2'}="Triosephosphate isomerase";
$hashothernames{'Triosephosphateisomerase3'}="Triosephosphate isomerase";
$hashothernames{'Triosephosphateisomerase4'}="Triosephosphate isomerase";
$hashothernames{'Fructosebiphosphatealdolase1'}="Fructose biphosphate aldolase";
$hashothernames{'Fructosebiphosphatealdolase2'}="Fructose biphosphate aldolase";
$hashothernames{'Fructosebiphosphatealdolase3'}="Fructose biphosphate aldolase";
$hashothernames{'Fructosebiphosphatealdolase4'}="Fructose biphosphate aldolase";
$hashothernames{'Phosphofructokinase1'}="Phosphofructokinase";
$hashothernames{'Phosphofructokinase2'}="Phosphofructokinase";
$hashothernames{'Phosphofructokinase3'}="Phosphofructokinase";
$hashothernames{'Phosphofructokinase4'}="Phosphofructokinase";
$hashothernames{'Phosphofructokinase5'}="Phosphofructokinase";
$hashothernames{'Phosphofructokinase6'}="Phosphofructokinase";
$hashothernames{'Phosphofructokinase7'}="Phosphofructokinase";
$hashothernames{'Glucose6phosphateisomerase1'}="Glucose 6 phosphate isomerase";
$hashothernames{'Glucose6phosphateisomerase2'}="Glucose 6 phosphate isomerase";
$hashothernames{'Glucose6phosphateisomerase3'}="Glucose 6 phosphate isomerase";
$hashothernames{'Glucose6phosphateisomerase4'}="Glucose 6 phosphate isomerase";
$hashothernames{'Glucosekinase1'}="Glucose kinase";
$hashothernames{'Glucosekinase2'}="Glucose kinase";
$hashothernames{'Glucosekinase3'}="Glucose kinase";
$hashothernames{'Glucosekinase4'}="Glucose kinase";
$hashothernames{'Glucosekinase5'}="Glucose kinase";
$hashothernames{'Glucosekinase6'}="Glucose kinase";
$hashothernames{'Glucosekinase7'}="Glucose kinase";
$hashothernames{'Pyruvatekinase1'}="Pyruvate kinase";
$hashothernames{'Pyruvatekinase2'}="Pyruvate kinase";
$hashothernames{'Pyruvatekinase3'}="Pyruvate kinase";
$hashothernames{'Pyruvatekinase4'}="Pyruvate kinase";

#-----------------------JAVA SCRIPT------------------
print qq |
<script language="javascript">
function checkAll(formname, checktoggle)
{
  var checkboxes = new Array(); 
  checkboxes = document[formname].getElementsByTagName('input');
 
  for (var i=0; i<checkboxes.length; i++)  {
    if (checkboxes[i].type == 'checkbox')   {
      checkboxes[i].checked = checktoggle;
    }
  }
}
</script>

|;
#------------END JAVA SCRIPT-------------------------
print qq |

<div class="encabezado">
</div>
<div class="expandedd">Results</div>
|;
#------------ guarda hash----------------------
#print "Content-type: text/html\n\n";
system "ls $OUTPUT_PATH/FASTASparaNP > $OUTPUT_PATH/ls.FASTANP";

open (VIAS, "PasosBioSin/$via_met")or die $!;
open (VIASOUT, ">PasosBioSin/viasout") or die $!;
#open (VIAS, "/var/www/newevomining/PasosBioSin/tRAPs_EvoMining.fa");
$counter=0;
while (<VIAS>){
chomp;
  if($_ =~ />/){
     @nomb =split (/\|/, $_);
     $nomb[2]=~ s/_//;
     if(!exists $uniqVIA{$nomb[2]}){
        $uniqVIA{$nomb[2]}=$counter; ## hash quwe contiele relacion:via original --> numero de via general de trabajo
        $counter++;
	print VIASOUT "$nomb[2]--->$uniqVIA{$nomb[2]}\n";
     }
     $hashnombreVIA{$counter}=$nomb[2];

  }
}

#----------------prepara blast Vs NP---------------------------
####weekend# en este caso se tiene que corregir que en pasos anteriores se generaron archivos vacios###
####weekend#
system "ls $OUTPUT_PATH/FASTASparaNP > $OUTPUT_PATH/ls.FASTANP";

#print "<h1>Blast  Central Met./NP VS Genome DB...</h1>";

#system "mkdir NewFASTASparaNP";
if(!$prev_np){
	open (BNP, "$OUTPUT_PATH/ls.FASTANP") or die $!;
	while (<BNP>){
		chomp;
		 ##########cuenta y saca secuencias corts y largas####################
  		open(OUTFASTA, ">$OUTPUT_PATH/NewFASTASparaNP/$_")or die $!;
#  		print (">$OUTPUT_PATH/NewFASTASparaNP/$_");

	 	open(TAM, "$OUTPUT_PATH/FASTASparaNP/$_") or die $!;
		  $contDentro=0;
		  $contfuera=0;
		  $contfueraabajo=0;
		  undef %hashLARGASCORTAS;
		  $hashLARGASCORTAS{$headerr}="";

		 while($lineaa=<TAM>){
			 chomp($lineaa);
			  if($lineaa =~ />/){
			     $headerr=$lineaa;
  				}
  			  else{
			      if(!exists $hashLARGASCORTAS{$headerr}){# solo para quitar el warning de qeu se concatenaba sin inicializar
			        $hashLARGASCORTAS{$headerr}=$lineaa; 
     				 }
      			      else{
			        $hashLARGASCORTAS{$headerr}=$hashLARGASCORTAS{$headerr}.$lineaa; 
      				}
			     }
		  	}#end while interno
 		close TAM;

		 #------------------------- 
		 #separa las bases y cuenta
		 #------------------------- 
		 ###print "Separando bases...\n"; 
		 $cuentaSEQ=0;
		 undef @arrpasos2;
		 foreach my $x (keys %hashLARGASCORTAS){
			@baseees=split(//,$hashLARGASCORTAS{$x});
			$tamSEQ=$#baseees+1;
   			$hashID_size{$x}=$tamSEQ;
			$cuentaSEQ++;
   			$sumaTAM=$sumaTAM+$tamSEQ;
   			$idtam=$x."&&&".$tamSEQ;
   			push (@arrpasos2,$idtam);
   			push (@arrpasos,$tamSEQ);
			 }
 	 	$promedioTamSEQ=$sumaTAM/$cuentaSEQ;
  
		 #------------------------- 
		 #promedio y DEVstd
		 #------------------------- 
		 ###print " Calculando devstd...\n";  
		 #<STDIN>;
		 ####################################################
		 ##    CALCULO DE DESVIACION ESTANDAR
		 ###################################################
	   	$contstd=1;
   		my @v1  = vector(@arrpasos);
   		my $std = stddev(@v1);
   		$prommasDEV=$promedioTamSEQ+$std;
   		$promminusDEV=$promedioTamSEQ-$std;
   		$promminusDEV2=$promminusDEV-$std;# para experimentar quitando dos devstd abajo
   		##print "$_ ->prom:$promedioTamSEQ-->DEVstd:$std\n";
   		##<STDIN>;#
   		$cuentaSEQ=0;
  		$sumaTAM=0;
 
   		foreach my $xids ( @arrpasos2 ){
     			@idssize=split(/&&&/,$xids);
     			if($idssize[1] > $prommasDEV){
			       #print "$idssize[0] $idssize[1] > $prommasDEV";
			       #<STDIN>;
       
			       $SeqRecortada= substr ($hashLARGASCORTAS{$idssize[0]}, 0, $prommasDEV);  #recorta la secuencia al tamanio promedio+STDdev
			       print OUTFASTA "$idssize[0]\n$SeqRecortada\n";
			       $contfuera++;
     				}
			 elsif($idssize[1] < $promminusDEV2){
        			$contfueraabajo++;
				}
 	    		 else{
			        print OUTFASTA "$idssize[0]\n$hashLARGASCORTAS{$idssize[0]}\n";
			        $contDentro++;
     				}


			       ### print "$xids\n";
			  }
 
  		$totalfuera=$contfuera+$contfueraabajo;
  		###print "Dentro :$contDentro  Fueraarriba: $contfuera  fueraabajo:$contfueraabajo totalfuera:$totalfuera";
  
		  ###<STDIN>;

		 ##
		 ##$prommasDEV

		 undef @arrpasos;
		  #print "$_ ->prom:$promedioTamSEQ-->DEVstd:$std\n";
		  #<STDIN>;
		######################################################
		 #foreach my $y (keys %hashID){
		 #  print "$y-->$hashID{$y}-->prom:$promedioTamSEQ-->DEVstd:$std";
 		#  <STDIN>;
 		#}
 
		  undef %hashID_size;
		  undef %hashID;
 
 		 close OUTFASTA;
 
		 ##########FIN cuenta y saca secuencias corts y largas####################
		
		#system "touch $OUTPUT_PATH/prueba0";
		##################weekend#####################
		## version con todos##
		####weekend#
       		$blast=system("/opt/blast/bin/blastp -db NPDB/$np_db.db -query $OUTPUT_PATH/NewFASTASparaNP/$_ -outfmt 6 -num_threads 4 -evalue $eval -out  $OUTPUT_PATH/blast/$_\_ExpandedVsNp.blast") ;#  or die       "EERROOOR:  $?,$!,%d, %s coredump";
       		#$blast=`/opt/blast/bin/blastp -db NPDB/$np_db.db -query $OUTPUT_PATH/NewFASTASparaNP/$_ -outfmt 6 -num_threads 4 -evalue $eval -out $OUTPUT_PATH/blast/$_\_ExpandedVsNp.blast`;#" or die "EERROOOR:$?,$!,%d, %s coredump";
		}#end while externo	

             close BNP;
	}# end if  np on LOG

#print "<h1>Done...</h1>"; ]

system "touch $OUTPUT_PATH/prueba3";
#----------------------------- filtra por score------------------------
system "ls $OUTPUT_PATH/blast/*_ExpandedVsNp.blast > $OUTPUT_PATH/ls.ExpandedVsNp.blast";

open (EXPPP, "$OUTPUT_PATH/ls.ExpandedVsNp.blast") or die $!;
while(<EXPPP>){
chomp;
  open(CUUOUT, ">$_.2")or die $!;
  open(CUU, "$_")or die $!;
  while($linea=<CUU>){
  chomp($linea);
   @arreg=split("\t",$linea);
    if ($arreg[11] >= $score2){
      print CUUOUT "$linea\n";
    
    }
  
  }
  close CUU;
  close CUUOUT;
}
close EXPPP;
#----------------------end filtra por score--------------------------
my @nonRec;

system "ls $OUTPUT_PATH/blast/*_ExpandedVsNp.blast.2 > $OUTPUT_PATH/ls.ExpandedVsNp.blast2";
open (EXP, "$OUTPUT_PATH/ls.ExpandedVsNp.blast2") or die $!;

if (-e "$OUTPUT_PATH/hash.log"){
system "rm $OUTPUT_PATH/hash.log";
}
while(<EXP>){
chomp;
#print "<h1>cat $_ |cut -f2 |sort -u >$_.recruitedUniq</h1>";
   $sii=`egrep -io [a-z] $_`;  # esta linea verifica qeu el archivo contenga texto.
   if($sii){
    ##############weekend############### 
         system "cat $_ |cut -f2 |sort -u >$_.recruitedUniq"; #Si tiene texto el archivo extrae la colunma2 que contiene el nombre del NP
   }
  else{
	$_=~s/$OUTPUT_PATH\/blast\/(\d*)\.fasta_ExpandedVsNp\.blast\.2//;
	my $nam=$1;
	push(@nonRec,$nam);
	system "cp $OUTPUT_PATH/NewFASTASparaNP/$nam.fasta $OUTPUT_PATH/blast/$nam.concat.fasta";
	#print "$nam has been copied";
	my  $reg=$hashnombreVIA{$nam};
        my $reg2="$nam===$reg";
        #print "reg2 $reg2 <br>";
        push(@mostrar, $reg2);
	open (RECPR, ">>$OUTPUT_PATH/hash.log") or die $!;
	print RECPR "$nam===$reg\n";
	close RECPR;
	}
}
close EXP;

system "ls $OUTPUT_PATH/blast/*.recruitedUniq > $OUTPUT_PATH/ls.recruitedUniq ";

open (REC, "$OUTPUT_PATH/ls.recruitedUniq") or die $!;
open (RECPR, ">>$OUTPUT_PATH/hash.log") or die $!;

while(<REC>){
chomp;
 open(OU,"$_")or die $!;
 $sin=$_;
 $sin =~ s/$OUTPUT_PATH\/blast\///g;
 $sin =~ s/\.fasta_ExpandedVsNp\.blast\.2\.recruitedUniq//g;
   while($line=<OU>){
   chomp($line);
      #print RECPR "$line\n";
      $hashUniq{$line}=$line;
      $cad=$cad.",".$line;
       #print RECPR "$cad\n";      
   }
   $cad =~ s/^\,+//;     
   #$reg=$hashNUMVia{$sin}."---".$cad;
   $reg=$hashnombreVIA{$sin}."---".$cad;
   $hashNUM{$hashnombreVIA{$sin}}=$sin;
   if($cad){
    print RECPR "$sin===$reg\n";
   $reg2="$sin===$reg";
#  print "cad $sin reg2 $hashnombreVIA{$sin} <br>"; 
 #  print "cad $cad <br>"; 
     push(@mostrar, $reg2);
   }
   
   $cad='';
 close OU;
 

 $sizeFIle= -s $_;
 if($sizeFIle > 0){
  	open(OUTFASTA,">$_.fasta") or die $!;
  	$nam=$_;
  	$nam =~ s/\.fasta_ExpandedVsNp\.blast\.2\.recruitedUniq//;
  	#system "touch $nam.nanana";
  	push(@nom, $nam);
 	}
 else {
  	next;
 	}
#open(NPDB, "/var/www/newevomining/NPDB/Natural_products_DB.prot_fasta")or die $!; 
#open(NPDB, "/var/www/newevomining/NPDB/NATURAL_PRODUCTS_DB3.fasta")or die $!;
open(NPDB, "NPDB/$np_db")or die $!;
 $si=0;  
 while($line2=<NPDB>){
  chomp($line2);
    if ($line2 =~ />/){
     #$header=$line2;
     $line2 =~ s/>//;
     
       if(exists $hashUniq{$line2}){
           print OUTFASTA ">$line2\n";
	   $si=1;        
       }
       else{
         $si=0;
       }
    }
    else{
       if($si ==1){
         print OUTFASTA "$line2\n";
       }
  
    }#

  }#end while NPDF
close NPDB;
close OUTFASTA;
%hashUniq ='';
}
close REC;

foreach my $x (@nom){
#system "touch $x.nananaaaaaa";
$tempor= $x;
$tempor =~ s/$OUTPUT_PATH\/blast\///;
#########weekend######

## version recortados
###weekend
system "cat $OUTPUT_PATH/NewFASTASparaNP/$tempor.fasta $x.fasta_ExpandedVsNp.blast.2.recruitedUniq.fasta> $x.concat.fasta";
#version todos###system "cat /var/www/newevomining/FASTASparaNP/$tempor.fasta $x.fasta_ExpandedVsNp.blast.2.recruitedUniq.fasta> $x.preconcat.fasta";
#open (CONCAT, "$x.preconcat.fasta");
#open (CONCATOUT, ">$x.concat.fasta");
# $cuenta=0;
#  while (<CONCAT>){
#   chomp;
#   #$_ =~ s/\(|\)//g;
#   #$_ =~ s/\(//g;
#     if($_ =~ />/){
#    # $_ =~ s/\-|\.//g;
#       $cuenta++;
#       #$llave="$cuenta"."_header";
#       $llave="$cuenta";
#      $NombresPorNum{$llave}=$_;
#      
#      print CONCATOUT ">$llave\n";
#      
#     }
#     else{
#       print CONCATOUT "$_\n";
#    
#    }
# }
}#end foreach
#$claveee="si llegaaaaaaaa";
close CONCAT;
close CONCATOUT;


open (MAMA, ">mama.log")or die $!;
#print "<h1>Done...ultimo</h1>"; 
#print "Content-type: text/html\n\n";
print qq| <form method="post" action="align_shave_tree.pl" name="forma"> |;
print qq| <table class="segtabla">|;
print qq |<td></td>|;
print qq |<div class="subtitulo"><td>Central</td></div>|;
print qq |<div class="subtitulo"><td>Natural Products</td></div>|;
foreach my $x (@mostrar){
#print MAMA "$x\n";
@PREarray =split("===",$x);
@array =split("---",$PREarray[1]);
#$array[1] =~ s/_\d+//g;
print qq |<tr>|;
#$clave="clave_$PREarray[0]";#$hashNUM{$array[0]}";
$clave="clave_$PREarray[0]";#$hashNUM{$array[0]}";

print MAMA "$clave\n";
#print qq| <input type="hidden" name="$clave" value="$clave">|;
print qq |<td><input type="checkbox" name="$clave" checked> </td>|;

print qq |<div ><td>$hashNUMVia{$PREarray[0]}</td></div>|;
#print qq |<div ><td>$hashNUMVia{$PREarray[0]}-$PREarray[0]</td></div>|;
#print qq |<div class="campo2"><td>$clave</td></div>|;
my @st=split(/,/,$array[1]);
$array[1]=~ s/\,/ \,/g;
#print qq |<div ><td width="40%"> $#array[1]</td></div>|;
print qq |<div ><td width="60%">|;

foreach my $name (@st){
	my @NPs=split(/_/,$name);
#	foreach my $np (@NPs){	
	if (-exists $NP_META{$NPs[0]}){
		print qq| $NP_META{$NPs[0]}[4]:$NP_META{$NPs[0]}[3]:$NP_META{$NPs[0]}[1]<a href="http://mibig.secondarymetabolites.org/repository/$NPs[0]/index.html#cluster-1" target="_blank" onClick="window.open(this.href, this.target); return false;">$NP_META{$NPs[0]}[0]</a><br>|;
	}
	else{
		print qq |$name <br>|;	
		}
}
print qq|</td></div>|;

print qq |</tr>|;
}
print qq |<input type="hidden" value="$OUTPUT_PATH" name="OUTPUT_PATH" >|;
print qq |</table>|;
print qq| <table>|;
print qq |
<td><div ><a href="javascript:void();" onclick="javascript:checkAll('forma', true);">check all</a></div></td>
<td><div ><a href="javascript:void();" onclick="javascript:checkAll('forma', false);">uncheck all</a></div></td>

|;
print qq |<td><div class="boton"><button  value="Submit" name="Submit">SUBMIT</button></div></td>|;

print qq |</table>|;
#print "<h1>Done...</h1>";
#system "muscle -in FASTAINTER/$nomb -out ALIGNMENTSfasta/$_.muslce.pir -fasta -quiet -group";
print qq| </form> |; 
untie %NombresPorNum;
#exit(1);
system("chmod 777 $OUTPUT_PATH/EvoMining.log");
open (LOG, ">>$OUTPUT_PATH/EvoMining.log") or die " not open $OUTPUT_PATH/EvoMining.log $!";
print LOG "np_hits_from_cp\tDONE\n";
close LOG;

#####################################################
# funciones para upload
#######################################################
sub recepcion_de_archivo{

my $evalue = $Input{'evalue'};
my $score1 = $Input{'score'};
my $PIDfecha = $Input{'OUTPUT_PATH'};
#my $nombre_en_servidor = $Input{'archivo'};

$evalue =~ s/ /_/gi;
$evalue =~ s!^.*(\\|\/)!!;
$score1=~ s/ /_/gi;
$score1 =~ s!^.*(\\|\/)!!;

my $extension_correcta = 1;

return $evalue,$score1,$PIDfecha ;

} #sub recepcion_de_archivo
