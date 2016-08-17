#!/usr/bin/perl
use CGI::Carp qw(fatalsToBrowser);
use CGI;
my $query = new CGI;
my @pairs = $query->param;

foreach my $pair(@pairs){
   $Input2{$pair} = $query->param($pair);
}

foreach my $x (keys %Input2){
 $aux="$aux.$x-$Input2{$x}++";
}




#web
print "Content-type: text/html\n\n";
print qq|
<html>
<head>
<meta content="text/html; charset=ISO-8859-1"
http-equiv="content-type">
<title></title>
</head>
<body>
<br>
|;
if($Input2{'email'} eq '' or $Input2{'Comment'} eq '' ){

print qq|
<h1>The following errors were found:</h1>
<ul>
|;
 if($Input2{'email'} eq ''){ 
       print qq|
       <li>Required value (<b>email</b>) is missing.</li>
       |;
       
 }
 if($Input2{'Comment'} eq ''){
       print qq|
       <li>Required value (<b>Comment</b>) is missing.</li>
       |;
 }
 # if($Input2{'email'} =~ m/@/){
 #      print qq|
 #      <li>Required value (<b>E-mail</b>) is in bad format.</li>
 #      |;
 #}
 
 print qq| 
  </ul>
  <div class="returnlink">Please correct these
  errors and send it again.</div>

|;
}
else{
print qq|
<h1>Thank you for your comments.</h1>
<p>Return and continue browsing on evomining<br>
|;
$date = `date`;
$pwd= `pwd`;
@divDate=split(/ /,$date);

$pid_fecha=$$."_".$divDate[0].$divDate[1].$divDate[2].$divDate[$#divDate];
#$outdir="$pid_fecha";
$dir="/var/www/newevomining/comments/$pid_fecha";
open(COMMENT, ">$dir") or die $dir;
print COMMENT "From :$Input2{'email'}:\nDate:$date\n$ENV{REMOTE_ADDR}\nTree:$Input2{'Referring'}\n$Input2{'Comment'}";
close COMMENT;
}

print qq|
<p><br>
</body>
</html>
|;

