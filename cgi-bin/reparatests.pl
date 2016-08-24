###################################################
# reparaHAEDER.pl
#
# modifica encabezado de fastas de genomas para
# funcionar con evomining, realiza blast GENOMAS VS Rutas CENTRALES
# y viceversa, y cre hashes en disco apra funcionamiento.
#
# nselem@langebio.cinvestav.mx
# cmartinez@langebio.cinvestav.mx
#
#
# INPUT: genomas en formato fasta.
#
# OUTPUT: -Genoma  en formato para evomining
#         con 6 campos divididos por pipes, sin
#         parentesis, corchetes, apostrofes, 
#         guiones, caracteres vacios.
#
#         -Genera hash en Disco que
#         se utilizaran para determinar el orden en el heatplot
#         en evom-0-3.pl
#          
#	  -Genera hash en disco para determinar las rutas centrales por BBH y
#	  etiquetar en rojo
#	  
#	  -Hash en disco de datos de AntiSmas y CF
#	   
#  
# 
#
#
#
###################################################

############################## HASH en disco #################################
use Fcntl ; use DB_File ; $tipoDB = "DB_File" ; $RWC = O_CREAT|O_RDWR;
use globals;

##############################################################################

my $tfm1A= $TFM1A; #from globals
if(-e $tfm1A){
 `rm $tfm1A`;
}
$hand1A = tie my %hashNOMBRES, $tipoDB , "$tfm1A" , $RWC , 0644 ;
print "$! \nerror tie para $tfm1A \n" if ($hand1A eq "");

my $tfm2A= $TFM2A; #from globals
if(-e $tfm2A){
  `rm $tfm2A`;
}
$hand2A = tie my %hashOrdenNOMBRES, $tipoDB , "$tfm2A" , $RWC , 0644 ;
print "$! \nerror tie para $tfm2A \n" if ($hand2A eq "");

my $tfm3A= $TFM3A; #from globals
if(-e $tfm3A){
  `rm $tfm3A`;
}

$hand3A = tie my %hashOrdenNOMBRES2, $tipoDB , "$tfm3A" , $RWC , 0644 ;
print "$! \nerror tie para $tfm3A \n" if ($hand3A eq "");
#----------------------------------------------------------------------------
#--------------CENTRAL pathways HD HASH--------------------------------------

if(-e $tfm){
  `rm $tfm`;
}




$tfm =$TFM ; #from globals
$hand = tie  %hashMETCENTRAL, $tipoDB , "$tfm" , $RWC , 0644 ;
print "$! \nerror tie para $tfm \n" if ($hand eq "");



$genomes=$GENOMES; #from globals
#`mkdir /home/evoMining/newevomining/blast/BBH/$genomes`;

`mkdir -p $OUTPUT_PATH/blast/BBH/$genomes/aux_files`;
$dir="$OUTPUT_PATH/blast/BBH/$genomes";

$start=1;
$end=2;

$lista0[0] =1;
$lista0[1] =2;
#-----------------------------------------------------------------------------

########################ANTISMASH###################################
$antismash=$ANTISMASH; #from globals

my $tfmAsmash= "$OUTPUT_PATH/hashANTISAMASandCF$GENOMES.db" ;

$handAM = tie my %hashANTISMASHid, $tipoDB , "$tfmAsmash" , $RWC , 0644 ;

print "$! \nerror tie para $tfmAM \n" if ($handAM eq "");
#  open(SMASH,"AntiSMASH_CF_peg_Annotation_FULL.txt");
  open(SMASH,"antiSmashClusteFinder/$antismash");

  while(<SMASH>){
    chomp;
    @asmash=split (/\t/,$_);

    $hashANTISMASHid{$asmash[1]}=$asmash[2];
    #print  "$asmash[1]-->$asmash[2]\n";
    #<STDIN>;
   
  }
  close SMASH;
  untie %hashANTISMASHid;
########################################################################




#-------------CONFIGURACION------------------------
 $MEtCentral="PasosBioSin/$VIA_MET"; #from globals
 $genomesDB="DB/$genomes/$genomes.fasta"; #from globals
 $genomesOUT="DB/$genomes\HEADER.fasta"; #from globals
 #Query = Central Met
 $genomesOUTDB="DB/$genomes\HEADER.db"; #from globals
 
 #Query = Genomes
 $centralOUTDB="DB/$MEtCentral\HEADER.db"; #from globals
 
 
 $listaNombres="listaold";
 
 
#--------------------------------------------------


open (DB, "$genomesDB") or die $!;
open (DBOUT, ">$genomesOUT")or die $!;
open (NAMESOUT, ">$listaNombres")or die $!;
open (HASHESOUT, ">HASHESnombres")or die $!;# solo para ver como qeudaria el hash en disco

$counting=0;
while (<DB>){
chomp;
  if($_ =~ />/){ 
   @pre_arr=split(/\|/,$_);
   $legible=$pre_arr[$#pre_arr];
 #  print "$legible";
 #  <STDIN>;
   $_ =~ s/\]|\[//g;
   $_ =~ s/&&&//;
    $_ =~ s/\+//g;
    $_ =~ s/\-//g;
    $_ =~ s/\r//g;
    $_ =~ s/\://g;
    $_ =~ s/  / /g;
    $_ =~ s/ /_/g;
    $_ =~ s/\'/_/g;
    $_ =~ s/\,//g;
    $_ =~ s/\///g;
    $_ =~ s/\(//g;
    $_ =~ s/\)//g;
    
    @arr=split(/\|/,$_);
    #print "$_\n";
    $arr[$#arr]=~ s/\.//g;
    print NAMESOUT "$legible\t";   #Legible
    $arr[$#arr]=~ s/\_//g;
    $arr[$#arr]=~ s/ //g;
    print NAMESOUT "$arr[$#arr]\n";	#nombre concatenado
    
    $_=join("\|",@arr);  
     #<STDIN>;
    print DBOUT "$_\n";
    
    #if(!exists $hashUniq{$arr[$#arr]} and $arr[$#arr] =~ /\w/){
    if(!exists $hashUniq{$arr[$#arr]}){
       $hashNOMBRES{$arr[$#arr]}=$legible;
       $hashOrdenNOMBRES{$legible}=$counting;
       $hashOrdenNOMBRES2{$counting}=$legible;
       print HASHESOUT qq/\$hashNOMBRES{'$arr[$#arr]'}="$legible";-->$hashNOMBRES{$arr[$#arr]}\n/;
       print HASHESOUT qq/\$hashOrdenNOMBRES{'$arr[$#arr]'}=$counting;-->$hashOrdenNOMBRES{$legible}\n/;
       print HASHESOUT qq/\$hashOrdenNOMBRES2{$counting}="$legible";-->$hashOrdenNOMBRES2{$counting}\n\n\n/;
       $hashUniq{$arr[$#arr]}=1;
       $counting++;
    }
    
    
    
    #<STDIN>;
  }
  else {
    print DBOUT "$_\n";
  
  }
}

close DB;
close DBOUT;
close NAMESOUT;
close HASHESOUT;
#untie %hashNOMBRES;
#untie %hashNOMBRES2;
#sudo rm ultimosPAblo/new_genomesrepaired.db*
#sudo rm ultimosPAblo/pscp30012015prueba.blast
#sudo rm ../blast/pscp30012015.blast

print "Indexando base de datos CENTRAL MET VS GENOMES...\n";
system "makeblastdb -dbtype prot -in $genomesOUT -out $genomesOUTDB";
print "\nBlast1...\n";
system "blastp -db $genomesOUTDB -query $MEtCentral -outfmt 6 -num_threads 4 -evalue 0.0001 -out OUTPUT_PATH/blast/pscp$genomes.blast";

print "Indexando base de datos GENOMES VS CENTRAL MET...\n";
system "makeblastdb -dbtype prot -in $MEtCentral -out $centralOUTDB";
print "\nBlast2...\n";
system "blastp -db $centralOUTDB -query $genomesOUT -outfmt 6 -num_threads 4 -evalue 0.0001 -out blast/vuelta$genomes.blast";

$lista0[0]="pscp$genomes.blast";
$lista0[1]="vuelta$genomes.blast";

print "Seleccionando unicos...\n";
selectUniq(@lista0); #INPUT @lista0 OUTPUT=UNICOS en /blasts con extension .uniq
print "Seleccionando BBH...\n";
bbhAfterUniq(@lista0);#INPUT los .uniq OUTPUT=BBH en /blasts con extension .bbh
print "Done!\n";




print "Finished!!\n";




untie %hashMETCENTRAL;




#############################################
###### selcciona unicos antes de BBH#########
#############################################
sub selectUniq {
my @cadenas=@_;

$cont=0;
$top=2;

  
  
  foreach $i (@cadenas){
   open (BLAST, "blast/$i") or die "blast/$i,$!";
   while (<BLAST>){
     chomp;
     @divBlast=split("\t",$_);
      
      #################identifica el organismo de cada registro###########
        @buscaORG1=split(/\|/,$divBlast[0]);
        @buscaORG2=split(/\|/,$divBlast[1]);
        if($buscaORG1[0] eq 'gi'){
          $Organismo=$buscaORG1[5];
	  $pasoBio=$divBlast[1];
	  $gii=$buscaORG1[1];
	  #$hit=
        }
	else{
	  $Organismo=$buscaORG2[5];
	  $pasoBio=$divBlast[0];
	  $gii=$buscaORG2[1];
	}
         #print "$Organismo";
	 #<STDIN>;
	 $llaveOrg=$Organismo."|".$divBlast[0];
	#################FIN identifica el organismo de cada registro###########
      
      if (exists $unico{$llaveOrg}){
        @comp=split("\t",$unico{$llaveOrg});
	if($comp[11] < $divBlast[11]){
	 $unico{$llaveOrg}=$_;
	}
	else{
	 $unico{$llaveOrg}=$unico{$llaveOrg};
	}
	
      }#end if
      else{
       $unico{$llaveOrg}=$_;
      }
   
   }#end while BLAST
   close BLAST;
   $fileuniq=$i.".uniq";
   open(WR,">$dir/aux_files/$fileuniq") or die "no se pudo $!,$dir/aux_files/$fileuniq";
   foreach $keys (keys %unico){
     print WR "$unico{$keys}\n";
   }
   undef %unico;
   close WR;  
 }#end foreach


}#end select/uniq





######################################
##selecciona BBH descd pues de unicos####
######################################

sub bbhAfterUniq {
 my @cadenas=@_;
 
 
    push (@orden, "$cadenas[1].bbh");
    open (UNI, "$dir/aux_files/$cadenas[0].uniq") or die "no abrio $!, $dir/aux_files/$cadenas[0]";
    $original0=0;
    while (<UNI>){
     chomp;
     @sel=split("\t", $_);
     $llave="$sel[0]&&$sel[1]";
     $hashBBH{$llave}=$_;
     $original0++;
    }#end while
    close UNI;
    $original=0;
     $cont=0;
 
    open (UNIQ, "$dir/aux_files/$cadenas[1].uniq") or die "nooo $!";
    open (BBH, ">$dir/aux_files/$cadenas[1].bbh") or die "no abrio $!";
   
    while (<UNIQ>){
     chomp;
     @sele=split("\t", $_);

     $llave2="$sele[1]&&$sele[0]";
     if (exists $hashBBH{$llave2}){
     
      @a1=split(/\|/,$sele[0]);
      print BBH "$a1[1] -> $sele[1]\t$sele[0]\n";
      $hashMETCENTRAL{$a1[1]}="$sele[1]\t$sele[0]\n";
     }
     $original++;
        
    }#end while
    close UNIQ; 
    close BBH;
   undef %hashBBH;  
 
  
# `rm -r $dir/aux_files/`;

  
}#end sub
