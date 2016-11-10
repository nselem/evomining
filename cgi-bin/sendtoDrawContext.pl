#!/usr/bin/perl

############ Este es el formuario 
use CGI::Carp qw(fatalsToBrowser);
use CGI;

my %Input;
my $cad;
my $query = new CGI;
my $idConcat= '';

print $query->header,
      $query->start_html(-style => {-src => '/EvoMining/html/css/tabla.css'} );
my @pairs = $query->param;

foreach my $pair(@pairs){
 	$Input{$pair} = $query->param($pair);
         $cad="$cad./$pair/|$Input{$pair}|";
         $cad2="$pair|$cad2";
	}	
$Input{'keywords'}=~ s/ /_/g;


my @datas=split(/\|/,$Input{'keywords'});
my @folder=split(/\//,$datas[2]);
$datas[3] =~ s/\/seqf\/tree\/(\d+)\.pp\.svg/$1/;
$clear=$folder[$#folder];
my $datos=$datas[0]."|".$folder[$#folder];
my $filee="$datas[2]$datas[3].idForcontext";

@clearString=split(/\|/,$cad2);
if($clearString[0] eq 'CLEAR'){
   open(OUT,">$clearString[1]");
   close OUT;
   $idConcat="";	
   #open(RAST,">RAST/RAST.ids");
   #close RAST;

}

if($datas[3] ne ''){
 open(OUT,">>$filee");
 print OUT "$datos\n";
 close OUT;

 open(ID,"$filee");

 while(<ID>){
   chomp;
   $idConcat="$idConcat"." "."$_";
 }
 close ID;
}

print qq |
<html>
 <head>
  <title>Contextos evoMining</title>
 </head>
 
 <body>
  <form action='drawContext.pl?$idConcat' method='post' target=''>
  <center><p>Genomic Context drawer<br>
Choose genes by cliking on its names</p> 
  <textarea name='message' rows='2' cols='70'>$idConcat
    </textarea>
  <input type='submit' name='Back' value='Go!'>
  <input type='button' onclick="location.href='sendtoDrawContext.pl?$filee&&&&CLEAR';" target= 'iframe_abajo' name='Clear' value='Clear'>
	 </form>
  </body>
</html>
|;

## Para mensajes insertar en html
#<center><p>Select genomic context *$Input{'keywords'}*:<br>Enter the genes that you wish to see separated by spaces.</p> 
#<br>$filee Entorno <br><br>Input $Input{'keywords'}<br>
#<br><br>cad $cad<br>
  
