#!/usr/bin/perl -w
#####################################################
# CODIGO PARA UPLOAD-FILE
#
#####################################################

#use strict;
use CGI::Carp qw(fatalsToBrowser);
use CGI;
use Statistics::Basic qw(:all);
use globals;

############################## def-DBM #################################
use Fcntl ; use DB_File ; $tipoDB = "DB_File" ; $RWC = O_CREAT|O_RDWR
;
############################## def-SUB  ################################
my $tfm2 = "mi_hashNUMVia.db" ;
$hand2 = tie my %hashNUMVia, $tipoDB , "$tfm2" , $RWC , 0644 ;
print "$! \nerror tie para $tfm2 \n" if ($hand2 eq "");


my $apacheCGIpath=$APACHE_CGI_PATH; #From globals
my $genomes=$GENOMES; #from globals
my $blast_file=$BLAST_FILE; #from globals
#$apacheCGIpath="/home/evoMining/newevomining"; #evom-0-3ORIG.pl
;
#los diez
#--- Generados con /var/www/newevomining/DB/reparaHEADER.pl------------------ 
my $tfm1A = $TFM1A; 	#From globals

#my $tfm1A = "hashOrdenNombres1_10.db" ;#evom-0-3ORIG.pl

$hand1A = tie my %hashNOMBRES, $tipoDB , "$tfm1A" , 0 , 0644 ;
print "$! \nerror tie para $tfm1A \n" if ($hand1A eq "");##

my $tfm2A = $TFM2A; 	#From globals
#my $tfm2A = "hashOrdenNombres2_10.db" ;#evom-0-3ORIG.pl
$hand2A = tie my %hashOrdenNOMBRES, $tipoDB , "$tfm2A" , 0 , 0644 ;
#print "$! \nerror tie para $tfm2A \n" if ($hand2A eq "");

my $tfm3A = $TFM3A; 	#From globals
#my $tfm3A = "hashOrdenNombres3_10.db" ;#evom-0-3ORIG.pl

$hand3A = tie my %hashOrdenNOMBRES2, $tipoDB , "$tfm3A" , 0 , 0644 ;
print "$! \nerror tie para $tfm3A \n" if ($hand3A eq "");
#-----------

#los casi200
#--- Generados con /var/www/newevomining/DB/reparaHEADER.pl------------------ 
#my $tfm1A = "hashOrdenNombres1_old2.db" ;
#$hand1A = tie my %hashNOMBRES, $tipoDB , "$tfm1A" , 0 , 0644 ;
#print "$! \nerror tie para $tfm1A \n" if ($hand1A eq "");#

#my $tfm2A = "hashOrdenNombres2_old2.db" ;
#$hand2A = tie my %hashOrdenNOMBRES, $tipoDB , "$tfm2A" , 0 , 0644 ;
#print "$! \nerror tie para $tfm2A \n" if ($hand2A eq "");

#my $tfm3A = "hashOrdenNombres3_old2.db" ;
#$hand3A = tie my %hashOrdenNOMBRES2, $tipoDB , "$tfm3A" , 0 , 0644 ;
#print "$! \nerror tie para $tfm3A \n" if ($hand3A eq "");
#----------------------------------------------------------------------------

#mil genomas
#--- Generados con /var/www/newevomining/DB/reparaHEADER.pl------------------ 
#my $tfm1A = "hashOrdenNombres1ALL.db" ;
#$hand1A = tie my %hashNOMBRES, $tipoDB , "$tfm1A" , 0 , 0644 ;
##print "$! \nerror tie para $tfm1A \n" if (!$hand1A);

#my $tfm2A = "hashOrdenNombres2ALL.db" ;
#$hand2A = tie my %hashOrdenNOMBRES, $tipoDB , "$tfm2A" , 0 , 0644 ;
##print "$! \nerror tie para $tfm2A \n" if (!$hand2A);

#my $tfm3A = "hashOrdenNombres3ALL.db" ;
#$hand3A = tie my %hashOrdenNOMBRES2, $tipoDB , "$tfm3A" , 0 , 0644 ;
##print "$! \nerror tie para $tfm3A \n" if (!$hand3A);
#----------------------------------------------------------------------------




my %Input;

my $query = new CGI;
print $query->header,
      $query->start_html(-style => {-src => '/html/evoMining/css/tabla.css'} );
my @pairs = $query->param;

foreach my $pair(@pairs){
$Input{$pair} = $query->param($pair);
}	

#print "AQUI $blast_file<br>";

#--------------------------------------
$date = `date`;
@divDate=split(/ /,$date);

$pid_fecha=$$."_".$divDate[0].$divDate[1].$divDate[2].$divDate[$#divDate];
$outdir="$pid_fecha";

chomp($outdir);



$la="$outdir/blast/seqf/tree";
system "mkdir -p $outdir/blast";
system "mkdir -p $outdir/FASTASparaNP";
system "mkdir -p $outdir/NewFASTASparaNP";


#system "mkdir -p $la";
#$la="$outdir/blast";

#system "mkdir -p $la";

#mkdir( $la ) or die "Couldn't create $la directory, $!";
#mkdir ("$outdir/blast/seqf");
#mkdir ("$outdir/blast/seqf/tree");
#mkdir ("$outdir/FASTASparaNP");
#mkdir ("$outdir/NewFASTASparaNP");
#--------------------------------------







#Directorio donde queremos estacionar los archivos
my $dir = "DB";
my $dirDB = "DB";
my $dirPB = "PasosBioSin";
my $blastdir = "/opt/ncbi-blast-2.2.28+/bin/";
my $OUTblast = "$outdir/blast";

#------- Rutas Centrales --------------
my $viaMet=$VIA_MET;	 ## From globals
#my $viaMet="ALL_curado.fasta";#evom-0-3ORIG.pl

#my $viaMet="ALL_curado020715.fasta";
#my $viaMet="tRAPs_EvoMining.fa";


#-------- BD de Genomas------------------
# Genomas 
#my $db = "GENOMESDB_230220015HEADER.fasta";

# Genomas de Nelly
#my $db = "NellyDaniel/11Oct2015HEADER.fasta";
#my $db = "TodosActinosHEADER.fasta";#mil genomas

#los diez

my $db ="$genomes\HEADER.fasta";
#my $db = "losDiez/tenGenomes.fasta"; #diez genomas 250116

#los casi200
#my $db = "losCasi200/losCasi200HEADER.fasta"; #200 genomas 250116


#los casi200 filtrados
#my $db = "losCasi200/filtrados/losCasi200filtradosHEADER.fasta"; #200 genomas 250116






#my $dbb = "GENOMESDB_230220015HEADER.fasta.db";
#my $dbb = "TodosActinosHEADER.fasta.db";
 ($eval,$score2)=recepcion_de_archivo(); #Iniciar la recepcion del archivo



#Array con extensiones de archivos que podemos recibir
my @extensiones = ('gif','jpg','jpeg','prot_fasta.2ConNombre','prot_fasta.2', 'fasta');
#my $db = "prueba.db";
#my $db = "ALL_curadoHEADER2.db";

#open (LALO, ">$outdir/lalo");
$cont=0;
$valida=1;
$cuentaVia=1;
open (CHECK, ">$outdir/check.hash");
open (VIAS, "$dirPB/$viaMet");
$cuantasViasvan=0;
while (<VIAS>){
chomp;
#print CHECK "$_\n";
  if($_ =~ />/){
    $_ =~ s/>//;
  # print CHECK "$_\n"; 
    @viaPaso= split (/\|/, $_);
    $llaveViaPaso="$viaPaso[0]_$viaPaso[1]";
   #  print CHECK "-$llaveViaPaso\n";
     if(!exists $hashViaPaso{$llaveViaPaso}){ 
    #  print CHECK "PASOOOOOO$llaveViaPaso\n";
      if($ViaAnterior ne $viaPaso[0]){
       #$llaveViaPaso="$viaPaso[0]_0";                #
       # print CHECK "$cuentaVia**$llaveViaPaso*anterior: +++$ViaAnterior, actual:$viaPaso[0]\n";       
      
       $hashCeros{$cuentaVia}=$cuentaVia; # Esta seccion es para agregar unla columna vacia entre cada via en el HIT PLOT
       # $cuentaVia++;                          #
      }
      $cuantasViasvan++;
      $hashViaPaso{$llaveViaPaso}=$cuentaVia; ## contiee los detalles de las vias "3PGA_AMINOACIDS|4" y el valor es el numero de la columna de la tablaheatplot
      $hashDetallesvias{$cuentaVia}=$llaveViaPaso;# contiene lo mismo del hash anterior pero invertido en llave valor
      $hashNUMVia{$cuentaVia}=$viaPaso[2];#$viaPaso[0]? esto ser[ia para el nombre del paso
      $hashDescripcionvia{$llaveViaPaso}=$viaPaso[2];
     # print CHECK "$cuantasViasvan-$llaveViaPaso -aa-->  $cuentaVia ===$hashViaPaso{$llaveViaPaso} ---- $viaPaso[2]\n";
      $cuentaVia++;
      $ViaAnterior=$viaPaso[0];
     }     

  }

}
print CHECK "$cuantasViasvan----$cuentaVia\n";
#close CHECK;
#--------- Indexa bd para blast --------------------------
#print "<h1>Indexando nuevo Genoma...</h1>";
###
#system "$blastdir/makeblastdb -dbtype prot -in $dir/$db -out $dirDB/$dbb";
# se ejecuto en lina de comando con lo siguiente: makeblastdb -dbtype prot -in GENOMES_DBrepaired.fasta -out GENOMES_DBrepaired.db
#print "<h1>Done...</h1>";
#print "<h1>Blast  Central Met./NP VS Genome DB...</h1>";

#system "$blastdir/blastp -db $dirDB/$dbb -query $dirPB/$viaMet -outfmt 6 -num_threads 4 -evalue $eval -out $OUTblast/pscp.blast";

#se ejecuto en lina de comando con lo siguiente:blastp -db DB/GENOMES_DBrepaired.db -query PasosBioSin/GlycolysisnewHEADER.fasta -outfmt 6 -num_threads 4 -evalue 0.0001 -out pscp.blast 
#blastp -db GENOMESDB_300120015.db -query ../PasosBioSin/ALL_curadoHEADER.fast -outfmt 6 -num_threads 4 -evalue 0.0001 -out ../blast/pscp30012015.blast
###################weekend############################system "$blastdir/blastp -db $dirDB/$db -query $dirPB/$viaMet -outfmt 6 -evalue $eval -out $OUTblast/pscp.blast";

#print "<h1>Done...</h1>"; cu
# print  "<h1>Concatenando blast...</h1>";
	
#  system "cat $OUTblast/$file_name\ConNombre.blast $OUTblast/centralMetVSgenomeBASE.blast  >  $OUTblast/centralMetVSgenomeW$file_name\ConNombre.blast";
#  print  "<h1>aRCHIVO Concatenado:$file_name.out</h1>";

#open (BLA, "/var/www/newevomining/blast/pscp.blast");
#while (<BLA>){
#chomp;
#@datblast=split("\t", $_);


#}#
#close BLA;

#---------------------pinta tabla--------------
#open (BLA, "/var/www/newevomining/blast/pscp10rep3.blast");
#open (BLA, "/var/www/newevomining/$OUTblast/pscp.blast");
#open (BLA, "/var/www/newevomining/blast/pscpPAU070915.blast");
#open (BLA, "/var/www/newevomining/blast/pscpNellyDaniel240915.blast");
#open (BLA, "/var/www/newevomining/blast/pscpTodosActinoscemg.blast");
#open (BLA, "blast/pscporigina190216.blast") or die $!; #250116
#open (BLA, "blast/pscporigina2_150316.blast") or die $!; #150316

#open (BLA, "blast/pscplosdiez.blast"); #250116



open (BLA, "blast/$blast_file") or die "$!"; #from globa.pm




#open (BLA, "blast/pscp11OctubreTodos.blast");
#$directory="$outdir/log.blast";
$directory="$outdir/log.blast";
open (LOG, ">$directory") or die "$!,$directory";
$co=1;
while (<BLA>){
chomp;
  @datblast=split("\t", $_);
  @datpasosBIO=split(/\|/, $datblast[0]);
  @datGenomas=split(/\|/, $datblast[1]);
 # print "$datblast[0]***$datblast[1]\n";
 # print "$datpasosBIO[1]_$datGenomas[5]\n";
 $porcentaje=$datblast[9]*100/$datblast[7];
 $cuatrillave=$datpasosBIO[0]."_".$datpasosBIO[1]."_".$datGenomas[1]."_".$datGenomas[5]; # esto es para qeu se selecciones un solo un GI por genoma, por via y por paso, sin redundancia entre esos 4 criterios
   
  if(!exists $hashUniqGI{$cuatrillave}){
    if ($datblast[11] >= $score2 and $porcentaje >50){
     #if(!exists $hashUniqGI{$trillave}){
      $llaveNVia="$datpasosBIO[0]_$datpasosBIO[1]";
      #$hashViaPaso{$llaveNVia}
      $llave="$hashViaPaso{$llaveNVia}"."_"."$datGenomas[5]";
      print LOG "$_----------$llave-->$hashGenomas{$llave}\n";#"$llaveNVia--->$hashViaPaso{$llaveNVia}-->$llave\n";
      $hashGenomas{$llave}++;
      $hashGIs{$llave}=$hashGIs{$llave}."\t".$datGenomas[1];
      $hashUniqGI{$cuatrillave}=$datblast[2]; #indexa los detalles de la via, y el GI al valor del % de identidfad obtenido del blast
     
      if( !exists$hashpasos{$hashViaPaso{$llaveNVia}}){
        $hashpasos{$co} =$hashViaPaso{$llaveNVia}; #quiza haya que concatenar el numero al a via cuando se agreguen las demas vias
        $co++;
      }
     #print LOG "$_\n";
     #}
    }
    
  }#end if $hashUniqGI{$cuatrillave}
  

 
}#end while

#print LOG "\n\n____________________________________\n\n\n";
$contador=0;
open (NUEVO, ">$outdir/busca.Gintroducido") or die $!;
$firsttime=1; # esta bandera indica qeu hay un organismo mas ademas de los registrados en el hash y es la primera vez que entra en el proceso
$cuentaOrgdemas=101;
$cuentaOrgdemas=237;

foreach my $x (keys %hashGenomas){
 #print "-----------------\n";
 @datllave=split("_", $x );
    
   # print LOG "$x*****$datllave[0]\n";
    if(!exists $hashNOMBRES{$datllave[1]}){
      $hashNOMBRES{$datllave[1]}=$datllave[1];
        ######### first time ?????#######
	 #if($firsttime==1){
          #  $cuentaOrgdemas=130;
         #   $firsttime=0;
         #}
         #else{
	 $contadordeGenomas++;
           $cuentaOrgdemas++;
         #}
	################################## 
	$hashOrdenNOMBRES2{$cuentaOrgdemas}=$datllave[1];
	$hashOrdenNOMBRES{$datllave[1]}=$cuentaOrgdemas;
	#print NUEVO " $hashOrdenNOMBRES{$hashNOMBRES{$datllave[1]}}--$hashNOMBRES{$datllave[1]}--$datllave[1]/ $hashNOMBRES{$datllave[1]} / [$hashOrdenNOMBRES{$hashNOMBRES{$datllave[1]}}][$datllave[0]]--$hashGenomas{$x}/$xllave:$cuentaOrgdemas, valor:$datllave[1] hashgenomas:$x\n";
	$hashNOMBRESActual{$cuentaOrgdemas}=1; 
       # print LOG "siiiiii entro[$hashOrdenNOMBRES{$hashNOMBRES{$datllave[1]}}][$datllave[0]]\n";
    } 
    else{
    $contadordeGenomas++;
    $hashNOMBRESActual{$datllave[1]}=1;
    #print NUEVO "EXISTEEEEEN[$hashOrdenNOMBRES{$hashNOMBRES{$datllave[1]}}--$hashNOMBRES{$datllave[1]}--$datllave[1]][$datllave[0]]-$hashNOMBRES{$datllave[1]}}][$datllave[0]-$hashGenomas{$x}/$xllave:$cuentaOrgdemas, valor:$datllave[1] hashgenomas:$x\n";
      #$hashNOMBRES{$datllave[1]} =~ s/ //g;
      if(!exists $hashOrdenNOMBRES{$hashNOMBRES{$datllave[1]}}){
        $hashNOMBRES{$datllave[1]} =~ s/ //g;
      }
      #print LOG "noooooo entro[$hashOrdenNOMBRES{$hashNOMBRES{$datllave[1]}}][$datllave[0]]-$hashNOMBRES{$datllave[1]}-$hashOrdenNOMBRES{$hashNOMBRES{$datllave[1]}}-\n";
    }
    #$hashNOMBRESActual{$datllave[1]}=1; #registra los nombres qeu provienen del blast para posteterioemente compraralos con el hashNombres
    #print NUEVO "$cuentaOrgdemas**$datllave[1]/*/[$hashOrdenNOMBRES{$hashNOMBRES{$datllave[1]}}][$datllave[0]]--$hashGenomas{$x}/$x\n";#"$hashOrdenNOMBRES{$hashNOMBRES{$datllave[1]}}__$datllave[0]**$datllave[1]\n";#**$hashGenomas{$x}++\n";#$hashGIs{$x}\n";
    $numGenoma2{$hashOrdenNOMBRES{$hashNOMBRES{$datllave[1]}}}="$datllave[1]";
    $tabla[$hashOrdenNOMBRES{$hashNOMBRES{$datllave[1]}}][$datllave[0]]="$hashGenomas{$x}";
    $tabla2[$hashOrdenNOMBRES{$hashNOMBRES{$datllave[1]}}][$datllave[0]]="$hashGIs{$x}";
    $tablanombrevia[$hashOrdenNOMBRES{$hashNOMBRES{$datllave[1]}}][$datllave[0]]="$hashDetallesvias{$datllave[0]}--$hashDescripcionvia{$hashDetallesvias{$datllave[0]}}/$hashNOMBRES{$datllave[1]}";
   #
#	print LOG "/$x/$#{$tabla[1]}+$hashOrdenNOMBRES{$hashNOMBRES{$datllave[1]}}+$datllave[0]+$tabla[$hashOrdenNOMBRES{$hashNOMBRES{$datllave[1]}}][$datllave[0]]\n";
$arrpasos[$datllave[0]]=$arrpasos[$datllave[0]].",".$hashGenomas{$x};

$sumarray[$datllave[0]]=$sumarray[$datllave[0]]+$hashGenomas{$x};
#print "$numGenoma{$datllave[1]}, $datllave[0]] =$hashGenomas{$x}\n ";
#<STDIN>;
}#end foreach %hashGenomas
#print LOG "TERMINO EN:$cuentaOrgdemas. total:$contadordeGenomas.\n";
#close LOG;
#print LOG "**filas $#tabla2 columnas $#{$tabla2[1]}\n";
####################################################
##    CALCULO DE DESVIACION ESTANDAR
##
  $contstd=1;
  #print "<h1>$sumarray[1]</h1>";
  foreach my $x ( @arrpasos ){
     @arregloPROm=split(",",$x);
      my @v1  = vector(@arregloPROm);
      my $std = stddev(@v1);
    #  $arrSTD[$contstd]=$std;
    
 
   $numgenomas=$#tabla;
   $promediO=$sumarray[$contstd]/$numgenomas;
 
   $arrSTD[$contstd]=$promediO+$std;
   $sumPROM='';
   $contstd++;
}
##
##
######################################################
print qq |

<div class="encabezado">
<div class="expanded">Expanded enzyme families</div>
</p>
<form method="post" action="evomBlastNp2.0ORIG.pl"
name="foma">
<table BORDER="0" CELLSPACING="0" ALIGN="center"  WIDTH="15">
<div class="subtitulo" ALIGN="center">Blast option:</div>
	<div class="campo1">e-value:</div>
    <div class="campo-1"><textarea style="width: 65px; height: 25px;" cols="1" rows="1" name="evalue">0.0001</textarea></div>
    <div class="campo2">Minimum Score:</div>
    <div class="campo2-2"><textarea style="width: 50px; height: 25px;" cols="1" rows="1" name="score">100</textarea></div>
    <input type="hidden" name="pidfecha" value="$outdir">
    <div class="boton"><button  value="Submit" name="Submit">SUBMIT</button></div>
</table>
<br>
</form>
|;

#print scalar keys %hashGenomas;
close BLA;
###print  LOG "paso 1 filas $#tabla comunas $#{$tabla[1]}\n";
#print "<h1>$tabla2[3][1]</h1>"; 
print qq|<table cellpadding="1" cellspacing="0" class="tabla">|;
#print "<tr>";
$tope=$#tabla+1;
for (my $x=0; $x<=$tope; $x++){#***filas****
#print LOG "$x--$hashOrdenNOMBRES2{$x}-$#{$tabla[1]}\n";
    if(!exists $hashNOMBRESActual{$x}){
       print NUEVO "$hashOrdenNOMBRES2{$x}\n";
       
       #next;
    }
    if(!exists $hashOrdenNOMBRES2{$x}){
      next;
    }
print "<tr>";
      #if(exists $hashNOMBRES{$hashOrdenNOMBRES2{$x}}){
      if(exists $hashOrdenNOMBRES2{$x}){
        print qq|<td>$hashOrdenNOMBRES2{$x}</td>|;
	#print qq|<td>$hashOrdenNOMBRES2{$x}</td>|;
	
	
      }
      else{
        print qq|<td>//$hashOrdenNOMBRES2{$x}</td>|;
        
      }
      
  for(my $y=1; $y<=$#{$tabla[1]}; $y++){ #columnas******
    if(!$tabla[$x][$y] ){
      $tabla[$x][$y]=0;
    }
    if(exists $hashCeros{$y}){
     print qq |<td  bgcolor="#585858"></td>|; #escribe division de vias en tabla
    }
    
   if($tabla[$x][$y] >= $arrSTD[$y]){
    
     $tabla2[$x][$y] =~ s/E/ E/g;# para los casos en qeu no viene co GI agrega un espacio, pues sal[ian pegados
    print qq |<td bgcolor= "#a02b2b" title=" $tablanombrevia[$x][$y] / $tabla2[$x][$y]" >$tabla[$x][$y]</td>|;
    $tabla3[$x][$y]=$tabla2[$x][$y]; ######selecciona ROJOS del heatplot en tabla3 para el caso de qeu se ocupe mas adelante
     $keyExpanded="$x_$y";
     $hashEXPANDED{$keyExpanded}=1;
   }
   else {
      if ($x == $tope){ 
        # print "<td>$arrSTD[$y]</td>"; #IMPRIME ULTIMA FILA COM DATOS
       }
       else {
        print qq |<td title=" $tablanombrevia[$x][$y] / $tabla2[$x][$y]">$tabla[$x][$y]</td>|;
      
      }
   } 
  }#end for columnas=  
  print "</tr>";
#pLOGrint "</table>";
}#end for filas
print "</table>";
open(SALE, ">$outdir/vacio.hash");
$tope2=$#tabla2+1;
####print LOG "paso antes columas $tabla2{$tabla2[1]} filas $tope2\n";
#------------------EXTRAE gi y genera fastas-----------------
my %Allgis=();
@losGIs=();
for(my $y=1; $y<=$#{$tabla2[1]}; $y++){ #columnas******
# print "++columna $y \n";
   for (my $x=0; $x<=$tope2; $x++){#***filas****
    
       ###selecciona ROJOS del heatplot##@losGIs=split("\t",$tabla3[$x][$y]);
       #$keyExpanded2="$x"."_"."$y";
       #if(exists $hashEXPANDED{$keyExpanded2}){
         @losGIs=split("\t",$tabla2[$x][$y]);
	 
       #}
       #####selecciona ROJOS del heatplot#if($tabla3[$x][$y] eq ''){
       #####selecciona ROJOS del heatplot#  next;
       #####selecciona ROJOS del heatplot#}
       foreach my $r (@losGIs){
         $y =~ s/\r//g;
	 if($r){
	  if(exists $Allgis{$r}){ 
	   $Allgis{$r}=$Allgis{$r}.'-'.$y;
	  print SALE "$r\t$y\t$Allgis{$r}\n";
	  }
	  else{
	    $Allgis{$r}=$y;
	  }
	  
	 }
       }
   }
   
} 
  $siH=0;
  
  open (FAST, "$dirDB/$db") or die "$! $dirDB/$db";
 
   
    
     while(<FAST>){
      chomp;
    
       if($_ =~ />/){
        @extID=split(/\|/,$_);
        $id=$extID[1];

	if(exists $Allgis{$id}){
           $siH=1;
	  #print SALE "$id\t$Allgis{$id}\n";
	  @columFamilies=split(/-/,$Allgis{$id});
	  foreach my $y (@columFamilies){ 
	   open (FASTA, ">>$outdir/FASTASparaNP/$y.fasta") or die $!;
 	   print FASTA "$_\n";
	   close FASTA;
	  } 
        }
        else{
          $siH=0;
        }
      }
      else{
       if ($siH ==1){
	  foreach my $y (@columFamilies){ 
         	open (FASTA, ">>$outdir/FASTASparaNP/$y.fasta") or die $!;
         	print FASTA "$_\n";
	 	close FASTA;
	}	
       }
      }
   }#end while
  
   
   close FAST;
   
   undef %Allgis;
   close LOG;
   close CHECK;


close SALE;







#######################################################
# funciones para upload
#######################################################
sub recepcion_de_archivo{

my $evalue = $Input{'evalue'};
my $score1 = $Input{'score'};
#my $nombre_en_servidor = $Input{'archivo'};

$evalue =~ s/ /_/gi;
$evalue =~ s!^.*(\\|\/)!!;
$score1=~ s/ /_/gi;
$score1 =~ s!^.*(\\|\/)!!;


my $extension_correcta = 1;


return $evalue,$score1;

} #sub recepcion_de_archivo
