#!/usr/bin/perl
use strict;
use CGI::Carp qw(fatalsToBrowser);
use CGI;
my %Input;
my $cad;
my $query = new CGI;
print $query->header,
      $query->start_html(-style => {-src => '/EvoMining/html/css/tabla.css'} );
my @pairs = $query->param;

my $apacheHTMLpath="/EvoMining/exchange";
foreach my $pair(@pairs){
 	$Input{$pair} = $query->param($pair);
         #$cad="$cad./$pair/|$Input{$pair}|";
	}	


my @IdstoInput=split(" ",$Input{'message'});
my $folderSesion="";
my $path="";

my $allIds="";
my @unique = do { my %seen; grep { !$seen{$_}++ } @IdstoInput };

foreach my $ID (@unique){
#	my @div=split (/\|/,$IdstoInput[1]);
	my @div=split (/\|/,$ID);
	$allIds=$allIds.$div[0]." ";
	$path=$div[1];
	}
$allIds=~s/ $//;

$folderSesion=$path;
$path=~ s/\r|\s//g;
chomp($path);
open (ERROR, ">error3") or die $!;
print ERROR "|$path|$folderSesion|$allIds|";
#my $gen1=23;
#my $gen2=45;
my $out= `perl RAST/1.WriteInputsFromList.pl $folderSesion $allIds`;
my $out2= `perl RAST/2.Draw.pl $folderSesion`;

# Llamar el generador de texto de contexto
# Llamar al dibujador y el dibujador cambiara el cuadrito azul por el contexto

print qq |
<html>
 <head>
  <title>EvoMining Contexts <br></title>
 </head>
 <body>
 <object type="image/svg+xml" name="viewport2" data="$apacheHTMLpath/$path/Contextos.svg" width="100%" ></object> 
  </body>
</html>
|;
####### PAra mensajes insertar en head

 #AllIds ¡$allIds! <br>
 #FolderSesion ¡$folderSesion! <br>
 #Out: $out <br>

   #<center><p>Contextos evomining perl RAST/1.WriteInputsFromList.pl $folderSesion $allIds </p>
# <img src='$apacheHTMLpath/$path/Contextos.svg' onerror='this.src='/newevomining/test.png''> 
## Pendiente borrar todas las noches }.input }svg
#Div0 ¡$div[0]!<br>
# Div1 ¡$div[1]!<br>
 # Input $Input{'message'} <br>

  #IdstoInput[1] $IdstoInput[1] <br>
