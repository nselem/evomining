#!/usr/bin/perl
use Fcntl ; use DB_File ; $tipoDB = "DB_File" ; $RWC = O_CREAT|O_RDWR;
 $tfm = "/var/www/newevomining/blast/auxiliares/genome.db" ;
 $hand = tie  %genomeCoord, $tipoDB , "$tfm" , 0 , 0644 ;

 $y=5;
 $x=5;
 $ancho=50;
 $largo=50; #min 15 si $ancho50



#lienazo------
 $width=$largo+$x;
 $height=$ancho+$y;

$tam=40;


 $maxX=$largo+$x;
 $maxY=$ancho+$y;
 $LONG=$maxY-$y;

 print "Content-type: text/html\n\n";
 $gi=$ENV{'QUERY_STRING'};
 #if($dato =~ /(\d+)\|/){
 # $gi=$1; 
 #}
 #else{
 #  print "NO encontre GI en URL!!!\n";
 #}
 
 
 #open(OP, "/var/www/newevomining/blast/seqf/tree/9.p.svg");
 #while(<OP>){
 # $string=$string.$_;
 #}

 @DATA=split("\t",$genomeCoord{$gi});
 @coordenadas=split(/\.\./,$DATA[3]);
 $tam=(($coordenadas[1]-$coordenadas[0])+1)/10;
 $coorde=($coordenadas[0]*100)/$tam;
 
 $DATA[5]=~ s/g//;
 
 
 
 
 print qq|
  <html>
 <head>
 <title>Genome Context</title>
 </head>
 <body>
 <?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!-- Created with Inkscape (http://www.inkscape.org/) -->
<svg
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   version="1.0"
   width="$width"
   height="$heigh"
   id="svg2440">
  <defs
     id="defs2443" />
|;
#print "$tam\n***$gi***$genomeCoord{$gi}\n";
#drawFwd($tam);
#for(my $x =0; $x<=10; $x++){
 #drawFwd($tam);
 drawBck($tam);
 #$tam++;
#} 
 
 print qq|</svg>
 </body>
 </html>|;
  
untie  %genomeCoord;
exit; 










#####################################
#
#     FUNCION DRAWBKD
#####################################
sub drawBck {

#flecha--------
#$factorDeMov=0;
my $y=5;
my $x=5;
my $ancho=50;
my $largo=shift; #min 15 si $ancho50



#lienazo------
my $width=$largo+$x;
my $height=$ancho+$y;




my $maxX=$largo+$x;
my $maxY=$ancho+$y;
my $LONG=$maxY-$y;

######################
#
#  Variables para
#  definir 
#  forma de flecha
#
#####################
my $colorInt='#FF0000';
my $colorLine='#2A0A0A';
#$uno=57.20617;#?????
my $uno=(($largo*25)/100)+$x;#?????
# EJE x --------------------------------------
my $longHeadArrow=(($maxX*25)/100)+$x;#coord inicial de cabeza de flecha
print "";
my $otherLong=$x;# coord final de cabeza de flecha

my $coordBody=$maxX; # coord inicial body eje x

### EJE Y-------------------------------------
my $longBODY=((($LONG)*80)/100)+$y; #anchoooooooo flecha coord final de arriba a abajo eje y
my $otraCoord=((($LONG)*20)/100)+$y;#anchoooooooo flecha coord inicial de arriba a abajo eje y

my $Other=$y;#coordenada inicial de arriba a abajo pico trasero flecha eje y
my $long=$maxY; #coordenada final de arriba a abajo pico trasero flecha eje y

my $coor=$LONG/2+$y; # coordenada y de la punta de la flecha

#####################

#--------moviendo en X---------------

#$longHeadArrow=$longHeadArrow+$factorDeMov;
#$otherLong=$otherLong+$factorDeMov;
#$coordBody=$coordBody+$factorDeMov;
#------------------------------------

#open (OUT, ">AUTprobe.svg") or die $!;

print qq|<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!-- Created with Inkscape (http://www.inkscape.org/) -->
<svg
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   version="1.0"
   width="$width"
   height="$heigh"
   id="svg2440">
  <defs
     id="defs2443" />
  <path
     d="M $uno,$longBODY L $coordBody,$longBODY L $coordBody,$otraCoord L $longHeadArrow,$otraCoord L $longHeadArrow,$Other C $longHeadArrow,$Other $otherLong,$coor $otherLong,$coor L $longHeadArrow, $long L $longHeadArrow,$longBODY z"
     id="path2451"
     style="fill:$colorInt;fill-opacity:1;stroke:$colorLine;stroke-width:2;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" />
</svg>
|;



}#end sub








#####################################
#
#     FUNCION DRAWFWD
#####################################
sub drawFwd {

#flecha--------
#$factorDeMov=0;
my $y=5;
my $x=5;
my $ancho=50;
my $largo=shift; #min 15 si $ancho50

#lienazo------
my $width=$largo+$x;
my $height=$ancho+$y;


#$factor

my $maxX=$largo+$x;
my $maxY=$ancho+$y;
my $LONG=$maxY-$y;

#-------calcula porcentaje X--------
 #if($largo < ($ancho/2) ){
 #  $porcentX=(($largo*100)/$ancho )*2;
 #} 
#
# elsif($largo > ($ancho *2)){
#  $porcentX=(($largo*100)/$ancho )/2;
#    
# }
 # else{
 # $porcentX=(($largo*100)/$ancho )/2;
 #   
 #}
  

######################
#
#  Variables para
#  definir 
#  forma de flecha
#
#####################
my $colorInt='#0099CC';
my $colorLine='#000066';
#$uno=57.20617;#?????
#$uno=($largo*75)/100;#?????
# EJE x --------------------------------------
my $longHeadArrow=(($largo*75)/100);#coord inicial de cabeza de flecha
my $uno=$longHeadArrow;
my $otherLong=$maxX;# coord final de cabeza de flecha

my $coordBody=$x; # coord inicial body eje x

### EJE Y-------------------------------------
my $longBODY=((($LONG)*80)/100)+$y; #anchoooooooo flecha coord final de arriba a abajo eje y
my $otraCoord=((($LONG)*20)/100)+$y;#anchoooooooo flecha coord inicial de arriba a abajo eje y

my $Other=$y;#coordenada inicial de arriba a abajo pico trasero flecha eje y
my $long=$maxY; #coordenada final de arriba a abajo pico trasero flecha eje y

my $coor=$LONG/2+$y; # coordenada y de la punta de la flecha

#####################

#--------moviendo en X---------------

#$longHeadArrow=$longHeadArrow+$factorDeMov;
#$otherLong=$otherLong+$factorDeMov;
#$coordBody=$coordBody+$factorDeMov;
#------------------------------------

#open (OUT, ">AUTprobe.svg") or die $!;

print  qq|
  <path
     d="M $uno,$longBODY L $coordBody,$longBODY L $coordBody,$otraCoord L $longHeadArrow,$otraCoord L $longHeadArrow,$Other C $longHeadArrow,$Other $otherLong,$coor $otherLong,$coor L $longHeadArrow, $long L $longHeadArrow,$longBODY z"
     id="path2451"
     style="fill:$colorInt;fill-opacity:1;stroke:$colorLine;stroke-width:2;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" />
</svg>
|;

#system "firefox AUTprobe.svg";


}#end sub


