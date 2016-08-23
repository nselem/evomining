#!/usr/bin/perl -w

use IO::Tee;    
use CGI;                             

   my $q = new CGI;     
open (STDOUT, "| tee file1 file2 file3") or die "Teeing off: $!\n";
   print $q->header,                    
         $q->start_html('hello world'), 
         $q->h1('hello world'),         
         $q->end_html;                  

# close(STDOUT)                            or die "Closing: $!\n";

