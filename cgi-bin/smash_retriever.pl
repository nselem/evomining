#!/usr/bin/perl
use strict;
use warnings;
###########################################################################
#       `perl smash_retriever.pl`
#       On a dir with directory outputs of antismash docker of rast gbk files    
#	author Pablo Cruz Morales
#	edited by Nelly Sélem
#       nselem84@gmail.com
####################################################################################
my $cluster_flag=0;

my @bgc=qx/find .\/* -type f -iname "*.cluster*.gbk"/;
extractinfo(@bgc);

###############3 subs ##################################
sub extractinfo{
	my @bgc=@_;
	foreach (@bgc){
		my $cluster_flag=0;
		my $cluster_class;
		chomp $_;
		#NZ_NBYK01000026.cluster010.gbk
		#unknown.cluster001.gbk
		$_=~/(.\/(.+)\/.+.)(cluster\d+).gbk/;
		#print "$_";
		#my $pause=<STDIN>;
    		my $cluster_number="$3";
		my $job_id="$2";
		open FILE, $_ or die "I cannot open $_ \n";
 		foreach my $line(<FILE>){
        		if ($line=~/\     cluster         /){
            			$cluster_flag=1;
				
        			}
	        	if ($line=~/\/product=/ && $cluster_flag==1){
		            $line=~/(\/product=")(.+)(")/;
        		    $cluster_class=$2;
	       	     	    $cluster_flag=0;
       		    		}
		        if ($line=~/SEED\:fig\|/){
       		 	    $line=~/(.+SEED\:fig\|)(.+)(")/;
	        	    my $peg_id="$2";
			    $peg_id=~s/\.peg//;
				if($cluster_class){print "$job_id\t$peg_id\t$cluster_class\t$cluster_number\n";}
            	    	    }
    			}
		}
	}
