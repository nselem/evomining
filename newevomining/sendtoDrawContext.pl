#!/usr/bin/perl
############ Este es el formuario 
use CGI::Carp qw(fatalsToBrowser);
use CGI;
my %Input;
my $cad;
my $query = new CGI;
my $idConcat= '';
print $query->header,
      $query->start_html(-style => {-src => '/newevomining/css/tabla.css'} );
my @pairs = $query->param;

foreach my $pair(@pairs){
 	$Input{$pair} = $query->param($pair);
         $cad="$cad./$pair/|$Input{$pair}|";
        
	}	
$Input{'keywords'}=~ s/ /_/g;


my @datas=split(/\|/,$Input{'keywords'});
my @folder=split(/\//,$datas[2]);
$datas[3] =~ s/\/seqf\/tree\/(\d+)\.pp\.svg/$1/;
my $datos=$datas[0]."|".$folder[$#folder];
my $filee="$datas[2]$datas[3].idForcontext";

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
  <title>Conteeeeextos evoMining</title>
 </head>
 
 <body>
  <form action='/cgi-bin/newevomining/drawContext.pl?$idConcat' method='post' target=''>
  <center><p>Genomic Context drawer<br>
Choose genes by cliking on its names</p> 
  <textarea name='message' rows='2' cols='70'>$idConcat
    </textarea>
  <input type='submit' name='Back' value='Go!'>
  </form>
  </body>
</html>
|;
## Para mensajes inseretar en html
#<br>$filee Entorno <br>Input $Input{'keywords'}<br>
#<center><p>Select genomic context *$Input{'keywords'}*:<br>Enter the genes that you wish to see separated by spaces.</p> 
  
