#!/usr/bin/perl
use CGI::Carp qw(fatalsToBrowser);
use CGI;
use Fcntl ; use DB_File ; $tipoDB = "DB_File" ; $RWC = O_CREAT|O_RDWR;
$tfm = "hashGBK.db" ;
$hand = tie  %hashGBK, $tipoDB , "$tfm" , 0 , 0644 ;
#my %Input;


my $query = new CGI;


print $query->header,
      $query->start_html(-style => {-src => '/newevomining/css/tabla2.css'} );

$numFile=$ENV{'QUERY_STRING'};
print qq |
<div class="expandedd">CONTEXT LIST$numFile</div>
|;
@split=split("-",$numFile);
$gi=$split[1];#$numFile;#$lin;#'509519237';
$vecinos=5;


@data=split("\t",$hashGBK{$gi});
$number=$data[3];
$org=$data[2];

print qq| <table class="segtabla" BORDER="1" CELLSPACING="1" ALIGN="center"  WIDTH="60">|;
print qq |<div class="subtitulo"><td>HIT =$gi</td></div>|;
#print "HIT =$number\t-$gi-\n";
print qq |<tr>|;
print qq |</tr>|;
print qq |<div class="subtitulo"><td>BACK</td></div>|;
#print "BACK:\n";

for(my $x=1; $x<=$vecinos; $x++){
  $otherNUM=$number-$x;
  $nume='p'.$otherNUM;
  @moredata=split("\t",$hashGBK{$nume});
  if($org eq $moredata[2]){
    #print "$otherNUM $hashGBK{$otherNUM}-----$org eq $moredata[2]\n";
    print qq |<tr>|;
    
    print qq |<div class="campo2"><td>$hashGBK{$nume}</td></div>|;
    #print "$otherNUM $hashGBK{$otherNUM}\n";
    print qq |</tr>|;
   } 
}
print qq |<tr>|;

print qq |<td BGCOLOR="#23238E" BORDER="1" CELLSPACING="1">|;
print qq |</td>|;

print qq |</tr>|;
print qq |<div class="subtitulo"><td>FOWARD</td></div>|;
#print "\nFOWARD:\n";
for(my $x=1; $x<=$vecinos; $x++){
  $otherNUM=$number+$x;
  $nume2='p'.$otherNUM;
  @moredata=split("\t",$hashGBK{$nume2});
  if($org eq $moredata[2]){
    #print "$otherNUM $hashGBK{$otherNUM}-----$org eq $moredata[2]\n";
    print qq |<tr>|;

    print qq |<div class="campo2"><td>$hashGBK{$nume2}</td></div>|;
    #print "$otherNUM $hashGBK{$otherNUM}\n";
    print qq |</tr>|;
  }
}
print qq |</table>|;
untie %hashGBK;
#open(OP, "/var/www/newevomining/blast/seqf/tree/$numFile.p.svg");
# while(<OP>){
#  $string=$string.$_;
# }

