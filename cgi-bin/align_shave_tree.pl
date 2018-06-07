#!/usr/bin/perl -w
#####################################################
# CODIGO PARA alinear y mostrar contexto genomico
#
#####################################################
############################## def-DBM #################################
use Fcntl ; use DB_File ; $tipoDB = "DB_File" ; $RWC = O_CREAT|O_RDWR
;
############################## def-SUB  ################################


##use strict;
use CGI::Carp qw(fatalsToBrowser);
use CGI;
use globals;

#system "mkdir -p /var/www/html/EvoMining/cgi-bin/blast/seqf/tree";
## Faltaba OUTPUT_PATH entre newevomining y blast
## Lo cree a mano


my $tfm2 = "$OUTPUT_PATH/mi_hashNUMVia.db" ;
$hand2 = tie my %hashNUMVia, $tipoDB , "$tfm2" , 0 , 0644 ;
print "$! \nerror tie para $tfm2 \n" if ($hand2 eq "");

my %Input;
my $query = new CGI;
$color[0]="#000000";
$color[1]="#FF0000";
$color[2]="#FF0000";

$color[3]="#FF8000";
$color[4]="#FF8000";

$color[5]="#FF8000";
$color[6]="#A5DF00";
$color[6]="#045FB4";
$color[8]="#045FB4";
######weekend#######
#system "rm /var/www/newevomining/blast/seqf/*only*";
print $query->header,
      $query->start_html(-style => {-src => '/EvoMining/html/css/tabla2.css'} );
my @pairs = $query->param;
#open(OUTT, ">salidaaaa");
foreach my $pair(@pairs){

 if($pair =~ /clave_\d+/){ 
    $Input{$pair} = $query->param($pair);
 }
 else{
 $Input2{$pair} = $query->param($pair);
 $outdir = $Input2{'pidfecha'};
 }
 #print OUTT "$query->param($pair);->$Input{$pair}\n";
 #my $OUTPUT_PATH = $Input{'pidfecha'};
}

#foreach my $x (keys %Input){
#print OUTT "$x->$Input{$x}--$Input2{'pidfecha'}**$OUTPUT_PATH\n";#

#}

my @dat= recepcion_de_archivo();
#close OUTT;
#exit(0);
#open (NUM, "losnumeros");
#while(<NUM>){
#chomp;
#push(@dat,$_);

#}

close NUM;




print qq |
<div class="encabezado">
</div>
<div class="expandedd">Aligning</div>
|;
my %hashNUM_NP='';

#--------------------- Alineando---------------------------
align();

sub align{
foreach my $c (@dat){
  
    ###########weekend###############
	$grepCENTRAL=`grep -c '>CENTRAL' $OUTPUT_PATH/blast/$c.concat.fasta`; 
	#print("grep -c \'>CENTRAL\' $OUTPUT_PATH/blast/$c.concat.fasta <br>"); 
	#print "Central $grepCENTRAL result <br>";
	if($grepCENTRAL<=1){   
		#print "Entre <br>"; 
		#print("cat $OUTPUT_PATH/blast/$c.central >>$OUTPUT_PATH/blast/$c.concat.fasta <br>");	 
		system("cat $OUTPUT_PATH/blast/$c.central >>$OUTPUT_PATH/blast/$c.concat.fasta");	 
		}
     system "/opt/muscle/muscle -in $OUTPUT_PATH/blast/$c.concat.fasta -out $OUTPUT_PATH/blast/$c.aln";

  if($c ne 'Submit' and $c ne '' and  $c ne ' '){ 
      $nam="$OUTPUT_PATH/blast/$c.aln";
     ###########weekend############### 
     addGap($nam);
   }   
}

#print qq |
#<div >Done...</div><div >Using seq fire...</div>
#|;
open (LOG, ">$OUTPUT_PATH/entradaAlignnn.log") or die $!;
}


#	NamesBeforeGblocks();
#sub NamesBeforeGblocks{  
#--------------------- Recortando alineamiento-------------
foreach my $cc (@dat){
 chdir "$OUTPUT_PATH/blast/seqf/";
 #SEQFIRE #system "python seqfire.py -i ../$cc\gap.aln -a 2 -o 2";
 print LOG "aquiiiiii ENTRO\n";
 #------------------------------------------------------------------------------
 #seccion 1 para sustuir nombres largos por cortos para GBLOCKS,# se sustituyen todos los encabezados por precaucion
 	open(FILE, "$OUTPUT_PATH/blast/$cc\gap.aln") or die "$!,$OUTPUT_PATH/blast/$cc\gap.aln";
 	open(OUT, ">../$cc\gap.aln.out") or die $!;
	$cont=1;
	while($line=<FILE>){
    		chomp($line);
    		if($line=~ />/){
      			$aux=$line;
      			$line = ">".$cont."_"."$cc\_aln";
			$hashHeader{$line}=$aux;
			$cont++;
      			#print "$line";
			#<STDIN>;
    			}
   		print OUT "$line\n";
   		 }#internal while
 
	close FILE;
  	close OUT;
	print LOG "antes de gblocks\n";
#}


 #-------------------------------------------------------------------------------------------------
   system "whoami>quien";
  ###########weekend###############
 #chdir "$OUTPUT_PATH/blast/";
my $dir=`pwd`;
  print LOG "Dir $dir\n/opt/Gblocks_0.91b/Gblocks ../$cc\gap.aln.out -b4=5 -b5=H -b3=10>LOG$cc.GBLOCks\n";
    system("/var/www/html/EvoMining/cgi-bin/Gblocks ../$cc\gap.aln.out -b4=5 -b5=H -b3=10>../LOG$cc.GBLOCks");
   # system "sudo Gblocks $cc\gap.aln.out -b4=5 -b5=H -b3=10>LOG$cc.GBLOCks";
# chdir "$OUTPUT_PATH/blast/seqf";
  #------------------------------------------------------------------------------
  #seccion 2 para sustuir nombres largos por cortos para GBLOCKS,# se sustituyen todos los encabezados por precaucion
  #regresa nombre largos despues de GBLOCKs
$paath="$OUTPUT_PATH/blast/$cc\gap.aln.out-gb";
 open(AGAIN, "$OUTPUT_PATH/blast/$cc\gap.aln.out-gb") or die "$!,$paath";
 open(FINAL, ">$OUTPUT_PATH/blast/$cc\gap.aln.out-gb2") or die $!;
  while($linea=<AGAIN>){
    chomp($linea);
   if($linea=~ />/){
       $linea=$hashHeader{$linea};
     
      }
     print FINAL "$linea\n";
  
   }
 
  close AGAIN;
  close FINAL;

  print LOG "salio\n";
  #-----------------------------------------------------------------------------
		}
#print qq |
#<div >Seqfire Done...</div>
#|;
close LOG;

#--------------------- Formato Stockolmo-------------
foreach my $cc (@dat){
 if($cc eq 'Submit'){
    next;
 }
 chdir "$OUTPUT_PATH/blast/seqf/";
###########weekend############### 
#system "$reformatPATH/esl-reformat --informat afa stockholm ../$cc\gap.aln.out-gb2 >$cc.stock";
system "perl /var/www/html/EvoMining/cgi-bin/converter.pl  $OUTPUT_PATH/blast/$cc\gap.aln.out-gb2 >$cc.stockLOG";
#CON SEQFIRE #system "/opt/hmmer-3.1b1-linux-intel-x86_64/binaries/esl-reformat --informat afa stockholm $cc\gap\_2_short.fasta >$cc.stock";
#system " /opt/hmmer-3.1b1-linux-intel-x86_64/binaries/esl-reformat --informat afa stockholm 4_2_short.fasta > probeWEB.stock";
}
#print qq |
#<div >Reformat Stockolm Done...</div>
#|;


#---------------------hash num and NP--------------
 open(HASH, "$OUTPUT_PATH/hash.log")or die $!;
   while(<HASH>){
   chomp;
      #@data=split("---", $_);
      #@gis=split(/,/, $data[1]);
      @numData=split(/---/, $_);
      @numeroFile=split(/===/, $numData[0]);
      $hashNUM_NP{$numeroFile[0]}=$numData[1]; # ejemplo : de esta linea ,71===Aspartatetransaminase_1---Esmeraldine_4,Prenilated_phenazines_8 forma el hash:71 => Esmeraldine_4,Prenilated_phenazines_8
     # @sinCmas=split(/,/, $numData[1]);
   }
   close HASH;
#--------------------- Quick tree-------------

foreach my $cc (@dat){
 if($cc eq 'Submit'){
    next;
 }
 chdir "$OUTPUT_PATH/blast/seqf/";
 ###########weekend###############  
# system "/opt/quicktree/quicktree_1.1/bin/quicktree -in a -out t -boot 10000 $OUTPUT_PATH/blast/$cc\gap.aln.out-gb2.stock > $OUTPUT_PATH/blast/seqf/tree/$cc.tree";
 #print "/opt/fasttree/FastTree $OUTPUT_PATH/blast/$cc\gap.aln.out-gb2 > $OUTPUT_PATH/blast/seqf/tree/$cc.tree <br>";
 system "/opt/fasttree/FastTree $OUTPUT_PATH/blast/$cc\gap.aln.out-gb2 > $OUTPUT_PATH/blast/seqf/tree/$cc.tree0";
 system("nw_reroot $OUTPUT_PATH/blast/seqf/tree/$cc.tree0 \$(nw_labels $OUTPUT_PATH/blast/seqf/tree/$cc.tree0 |grep CENTRAL|sort -g |head -n1)  > $OUTPUT_PATH/blast/seqf/tree/$cc.tree");
 #########weekend######### 
 system "nw_distance -n $OUTPUT_PATH/blast/seqf/tree/$cc.tree > $OUTPUT_PATH/blast/seqf/tree/distance.$cc";
 $dist="distance.$cc";
 #$fileNamee=findDistance2($dist,$cc);
if (-e "$OUTPUT_PATH/blast/$cc.fasta_ExpandedVsNp.blast.2.recruitedUniq"){
 	$namee=findDistance2($dist,$cc);
       	system "nw_display -w 5600 -sr -S -v 100 -l 'font-size:x-small' -b 'visibility:hidden' -o $OUTPUT_PATH/blast/seqf/tree/ornament.$cc $OUTPUT_PATH/blast/seqf/tree/$cc.tree >$OUTPUT_PATH/blast/seqf/tree/$cc.p.svg";
}
else{
       	system "nw_display -w 5600 -sr -S -v 100 -l 'font-size:x-small' -b 'visibility:hidden' $OUTPUT_PATH/blast/seqf/tree/$cc.tree >$OUTPUT_PATH/blast/seqf/tree/$cc.p.svg";
}
 #$namee=CSSmap($fileNamee);
 #open(GO, ">/var/www/newevomining/blast/seqf/checar");
 #print "nw_display -w 5600 -sr -S -v 100 -b 'visibility:hidden' -c $namee /tree$cc.tree >$cc.p.svg";
 #########weekend######### 
 #system "nw_display -w 5600 -sr -S -v 100 -b 'visibility:hidden' -c ../distance.9.only.cssmap 9.tree >9color2.svg"
}

#print qq |
#<div >Quick tree Done...</div>
#|;

#---------------imprime tabla---------------------



print qq| <table>|;
print qq |<div><td >Central</td></div>|;
print qq |<div><td >Natural Products</td></div>|;
#print qq |<div><td >HITS</td></div>|;
print qq |<div><td >tree</td></div>|;
 open(FF, "$OUTPUT_PATH/hash.log"); ###aqui hay que modificar
 while ($xef = <FF>){
     chomp($xef);
     @array =split("---",$xef);
     @array2 =split("===",$array[0]);
     #$array[1] =~ s/_\d+//g;
    foreach my $xc (@dat){
        if($array2[0] eq $xc){
          $onlyD="distance.$xc.only";
        if (-e "$OUTPUT_PATH/blast/seqf/tree/$onlyD"){  
		open(XT, "$OUTPUT_PATH/blast/seqf/tree/$onlyD") or die "$!,$onlyD";
	}
          
	  while($line=<XT>){
              chomp($line);
             # $acum=$acum.'<a href="'."http://148.247.230.39/cgi-bin/newevomining/context.pl?197710970".'" target="ventana_iframe">'.$line.'</a><br>';
	      #$acum=$acum.'<a href="'."http:///10.10.100.24/cgi-bin/newevomining/context.pl?$line".'">'.$line.'</a><br>';
	     $line=~ s/\t.*//g;
	      @sep=split(/\|/,$line);
	      push(@gisV,$sep[0]);
	      push(@desc,$sep[1]);
	      #$acum=$acum.$line;
           }
       	   
          close XT;
          print qq |<tr>|;
          #$clave="clave_$hashNUM{$array[0]}";
          #print qq| <input type="hidden" name="$clave" value="$clave">|;
          print qq |<div><td > $hashNUMVia{$array2[0]}</td></div>|;
          #pridnt qq |<div class="campo2"><td>$hashNUM{$array[0]}</td></div>|;
          $array[1]=~ s/\,/,\n/g;
	  #print qq |<div><td>$array[1]</td></div>|;
	    
	     my $conta=0;
	     print qq |<td>|;
	     print qq| <table >|;
	    foreach my $x (@gisV){
	       if($x =~ /gi/){
	         next;
	       }
	       @cleanNP=split(/_/,$x);
	       
	      # print qq |<tr>|;
	       #print qq |<div class="campo2"><td>$acum</td></div>|;
               print qq |<div ><a href="http://mibig.secondarymetabolites.org/repository/$cleanNP[0]/index.html#cluster-1" target="_blank" onClick="window.open(this.href, this.target); return false;">$x</a></div>|;
	       #print qq |<div><td>$x</td></div>|;
	       
	       #print qq |<div><td >--$desc[$conta]++</td></div>|;
	       #print qq |</tr>|;
	       $conta++;
	    } 
	    print qq |</table>|;
	    print qq |</td>|;
                  print qq |<div><td ><a href="color_tree.pl?$array2[0]&&$OUTPUT_PATH" target="_blank">check tree</a> </td></div>|;

		  # print qq |<div><td ><a href="http://cgi-bin/color_tree.pl?$array2[0]&&$OUTPUT_PATH" target="_blank">check tree</a><br><a href="http://$OUTPUT_PATH/blast/seqf/tree/$array2[0].tree" target="_blank"> Download newick_tree</a></td></div>|;
           #print qq |<div class="campo2"><td><a href="http://148.247.230.39/cgi-bin/newevomining/tree.pl?$array2[0]" target="_blank">check tree</a></td></div>|;
          print qq |</tr>|;
	  $acum='';
       undef @gisV;
       undef @desc;
      }
      else{
        next;
      }
    }	  
 }
 close FF;
print qq |</table>|;
#print qq| <table BORDER="0" CELLSPACING="0" ALIGN="center"  WIDTH="15">|;
 
 #----------------------iframe----------------------------
   
#   print qq| <table class="segtabla" BORDER="1" CELLSPACING="1" ALIGN="center"  WIDTH="800">|;
#   print qq |<div class="subtitulo"><td>|;
#   print qq |<iframe  src="http://10.10.100.24/cgi-bin/newevomining/context.3pl"  ALIGN="center"
#   marginwidth="1" marginheight="1" name="ventana_iframe" scrolling="yes" border="1" 
#   frameborder="1" width="800" height="150">
#   </iframe> |;
#   print qq |</td></div>|;
#   print qq |</table>|;
#print qq| <table BOR
#----------------END------iframe----------------------------


#print qq |</table>|;
#print "<h1>Done...</h1>";
#system "muscle -in FASTAINTER/$nomb -out ALIGNMENTSfasta/$_.muslce.pir -fasta -quiet -group";


#exit(1);




















###########################################
## fincion agregaGap
##
###########################################
sub addGap {
$file= shift;

  open(ADD, "$file")or die  "$file, $!";
  $file2=$file;
  $file2 =~ s/\.aln/gap.aln/;
  open(ADDOUT, ">$file2")or die $!;
  $cont=0;
    while(<ADD>){
     chomp;
       if($_ !~ />/  and $cont ==0){
           print ADDOUT "-$_\n";
           $cont++;
            #<STDIN>;
        }
       elsif($_ =~ />/){
           $_ =~ s/\(|\)//g;
	   $_ =~ s/\,/_/g;
	   
	   if($_ =~ /\|/){
	    # $_ =~ s/gi\|(\d*)\|/-------$1--------/;
	       #$_ =~ s/gi\|(\w+)\|.*\|.*\|.*\|(.*)\|/$1|$2/g;
	       $_ =$_."|";
	       $_ =~ s/gi\|(\w+)\|.*\|.*\|.*\|(.*)\|/$1|$2/g;
	   }
	   else{
	   
	     $_ =$_;
	   }
	   print ADDOUT "$_\n";
           $cont=0;
        }
       else{
           print ADDOUT "$_\n";
           $cont++;
        } 

    }#end while
close ADD;
close ADDOUT;
}#end sub


###########################################
## fincion CSSmap
##
###########################################
sub CSSmap {
 my $f= shift;
 open (FD, "$f");
 my $nome= "$f\.cssmap";
  #########weekend#########
  open (FDOUT, ">$nome")or die $!;
 $contar=0;
 while(<FD>){
 chomp;
 # if($contar ==0){
    $hits="$hits $_";
  #}
  #$ultimo=$_;
  
 
 }#end while
  #########weekend#########
  print FDOUT qq |"stroke-width:3; stroke:blue" C $hits |;

  return $nome;
}#end sub


###########################################
## fincion findDistance2 solo por vecindad
##EN ESTA FUNCION SE PRETENDIA MARCAR UN CLADO (EVOHITS) BASANDOSE EN LA VECINDAD DE DONDE SON ENCONTRADOS LOS np MARCADOS EN ROJO
###########################################
sub findDistance2 {
   ($dis, $numerin)= @_;
   
    # $hashNUM_NP{$numeroFile[0]}=$numData[1]; # ejemplo : de esta linea ,71===Aspartatetransaminase_1---Esmeraldine_4,Prenilated_phenazines_8 forma el hash:71 => Esmeraldine_4,Prenilated_phenazines_8
   
  @NPs=split (/\,/,$hashNUM_NP{$numerin});
  #########weekend######### 
  open (SI,">../../si.log");
 #########weekend#########  
 print SI "inicio $dis, $numerin\n";
  foreach my $np (@NPs){
    $hashNPS{$np}=1;
  #########weekend######### 
    print SI "- $np\n";
    #######-------- SE DEJO -c 1 para solo marca el producto natural, si se incrementa -c se marcan mas clados
   #########weekend#########  
   system "nw_clade -c 1 $OUTPUT_PATH/blast/seqf/tree/$numerin.tree $np |nw_distance -n ->>$OUTPUT_PATH/blast/seqf/tree/distance.$numerin.only1";
    #print NPPS "$numerin.tree---$np\n";
   #########weekend######### 
    system "echo ==== >>$OUTPUT_PATH/blast/seqf/tree/distance.$numerin.only1";
  }
 #########weekend######### 
  close SI;
   $seccion=0;
   $colorSeccion=0;
 #########weekend#########
   open (NPPS,">$OUTPUT_PATH/blast/seqf/tree/$numerin.NPPS.log") or die $!;
 #########weekend######### 
  open (DOUT, ">$OUTPUT_PATH/blast/seqf/tree/distance.$numerin.only")or die $!;
  open (D, "$OUTPUT_PATH/blast/seqf/tree/distance.$numerin.only1")or die $!;
  #########weekend#########
    open (ORNAMENT, ">$OUTPUT_PATH/blast/seqf/tree/ornament.$numerin")or die $!;
  #########weekend#########
    print ORNAMENT qq|"<circle style='fill:blue;stroke:black' r='8'/>" I |;
   while (<D>){
      chomp;
      #@sinNUM=split("\t", $_);
	#print ORNAMENT qq|$sinNUM[0] |;

      
     
      if($_ =~ /===/){
       #print DOUT "===\n";
      }
     
      @sinNUM=split("\t", $_);

      #************calcula hits a mostrar*************
        if(!exists $hashNPS{$sinNUM[0]}){
	  $cuentaHojas++;
	  $npsId = "$npsId $sinNUM[0]";
	 #########weekend#########
	  print NPPS "$sinNUM[0]\n";
	}
	else{
	#########weekend#########
	print NPPS "******$sinNUM[0] hojas=$cuentaHojas ---$npsId\n";
	#########weekend#########
	print ORNAMENT qq|$sinNUM[0] |;
	
	 ############## elimina redundancias ######c
	      if(!exists $hashONLY{$sinNUM[0]}){
               #########weekend######### 
	        print DOUT "$_\n";
	
	         #print ORNAMENT qq|$sinNUM[0] |;
	         push (@ornament, $sinNUM[0]);
                 $hashONLY{$sinNUM[0]}=$_;
	      }
              else{
                 $hashRepeatedColors{$sinNUM[0]}++;
                                                                                                                                                                         
               }
         ########################################
	
	
	#print DOUT "$sinNUM[0]\n";  
	  if($cuentaHojas < 6){
	   #########weekend#########
	     print NPPS "+++++++$npsId\n";
	   # print ORNAMENT qq|$npsId |;
	    if($npsId !~ /==/){
            #########weekend######### 
	     print DOUT "$npsId\n";
	    }
	  }  
	 $cuentaHojas=0;
	 $npsId = '';
	}
      
      #***********************************************
      
      @a=split("\t", $_);
      if($_ =~ /====/){
        if ($seccion>0){ #para no contemplar el primer caso qeu no tendria nada
	  $ColourBySec{$seccion}=$colorSeccion;
	  $colorSeccion=0;
	}
	
	$seccion++;
	next;
      }
       $colorSeccion++;
       $hits{$seccion}="$hits{$seccion} $a[1]";
      #if($seccion==1){
       #  print FDOUT qq |"stroke-width:3; stroke:$color[$seccion]" C $hits |;
        #$seccion=0;
      #}
   } #end while D
    #########weekend#########
    close NPPS;
   #if ($cuentaHashOnly == 1){
   #  print ORNAMENT qq|"<circle style='fill:red;stroke:black' r='8'/>" I |;
   #}
   #elsif($cuentaHashOnly == 2){
   #  print ORNAMENT qq|"<circle style='fill:#8A0808;stroke:black' cx='-10' r='8'/><circle style='fill:red;stroke:black' r='8'/>" I |;
   #}
   #elsif($cuentaHashOnly >2){
   #  print ORNAMENT qq|"<circle style='fill:#3B0B0B;stroke:black' cx='-25' r='8'/><circle style='fill:#8A0808;stroke:black' cx='-10' r='8'/><circle style='fill:#8A0808;stroke:black' cx='-10' r='6'/><circle style='fill:red;stroke:black' r='8'/>" I |;
   #}
   
   
   
   
   
   #foreach my $x (keys %hashRepeatedColors){
  # 
  #   print ORNAMENT "$x ";
  # }
   
   $cuentaHashOnly=0;
   #########weekend######### 
   close ORNAMENT;
  # system "cp /var/www/newevomining/blast/seqf/tree/ornament.$numerin /var/www/newevomining/blast/seqf/tree/ornament.back.$numerin";
    @ornamen ='';
   undef %hashONLY;
  #########weekend######### 
  close DOUT;
  close D;
  $cont=0; 
  $nomee="distance.$numerin.only.cssmap";
  #########weekend#########
  open (FDOUT, ">$nomee");
   foreach my $xc (keys %$hits){
     if($ColourBySec{$xc} > 8){
      $ColourBySec{$xc}=8;
     }
     #########weekend######### 
     print FDOUT qq |"stroke-width:3; stroke:$color[$ColourBySec{$xc}] " C $hits{$xc} |;
   }
   
    #########weekend#########
    close FDOUT;
   
  return $nomee;
}#end sub





###########################################
## fincion findDistance
##
###########################################


sub findDistance {
  my ($dis, $numerin)= @_;
   
   
   open(HASH, "$OUTPUT_PATH/hash.log")or die $!;
   while(<HASH>){
   chomp;
      #@data=split("---", $_);
      #@gis=split(/,/, $data[1]);
      @numData=split(/===/, $_);
      if($numData[0] eq $numerin){
        $hashLog{$numData[0]} = $numData[1];
	#print "$numData[0] =aaaaaa $hashLog{$numData[0]}";
	#<STDIN>;
      }
   }
   close HASH;
   
   open (D, "$OUTPUT_PATH/blast/seqf/$dis");
   while (<D>){
      chomp;
      @a=split("\t", $_);
      $hash{$a[1]}=$a[0];
      #print "$_\n";
      #<STDIN>;
   }
  close D;
  $cont=0;
 
 foreach my $x (sort{$b<=>$a} keys %hash){
     @num=split(//,$x);
     $equal=$num[0].$num[1].$num[2].$num[3];
     #$equal=$num[0].$num[1].$num[2].$num[3].$num[4];
     @gis=split(/,/,  $hashLog{$numerin});
     $hashDist{$equal}="$hashDist{$equal}\t$hash{$x}";
    # print "$equal -- $hash{$x}\n";
    # <STDIN>;
    foreach my $xx (@gis){
    
        #if(exists $comp{$equal}){
        #    push(@important,$hash{$x});
        # 
        # } 
        # #elsif($cont ==0) {
	#  print "$hash{$x} *** $xx\n";
        #    <STDIN>;
	@divide=split("---",$xx );
        if($hash{$x} eq $divide[1]) {
            #$comp{$equal}=$x;
           # print "$xx /$equal// $x\n";
           # <STDIN>;
     	    push(@important,$equal);
            #$cont++;
         }   
       #$anteriorEqual=$equa;
       #print "$hash{$x}\n";
           #<STDIN>;
     }#end foreach interno
  }#end foreach
  
  
  $nameOUT="$dis\.only";
 open (DOUT, ">$nameOUT")or die $!;
  foreach my $y (@important){
     #print  "$hashDist{$y}\n";
     $hashDist{$y} =~ s/^\t|\t$//g;
     $hashDist{$y} =~ s/\t/\n/g;
    print DOUT "$hashDist{$y}\n";
     #<STDIN>;

  }
  @important='';
 close DOUT;
  return $nameOUT;
}#end sub







######################################################
# funciones para upload
#######################################################
sub recepcion_de_archivo{
$cuenta =0;
my $PIDfecha = $Input{'pidfecha'};
#open (RECE, ">$PIDfecha/recibio.log");
open (RECE, ">recibioo.log");
 foreach my $x (keys %Input){
   if(exists $Input{'pidfecha'}){
     print RECE "lalalalal$Input{'pidfecha'}\n";
     #exit(1);
     next;
   }
   
   $x =~ s/clave_//;
  print RECE "*$x\n";
   $datoss[$cuenta]=$x;
   $cuenta++;
 }

 my $extension_correcta = 1;
 return @datoss;

} #sub recepcion_de_archivo
