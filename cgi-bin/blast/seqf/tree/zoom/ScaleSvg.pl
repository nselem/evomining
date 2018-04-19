#!/usr/bin/perl
use strict;
## It is asumed that the svg is parsed before to s/>/>\n/

my $file= $ARGV[0]; ##$OUTPUT_PATH/blast/seqf/tree/$numFile.pp.svg
my @parts=split("blast",$file);


my $path="$parts[0]|$parts[1]";
#######modificado Christian 11/02/16##########


#####################fin Christian########################
 
#`perl -p -i -e 's/// $file'`;
my $w=500; ##Desired new w

# Obtain width From Line <svg width='200'
## Store this vaue on $W
my $W=GetWidth($file);

# Create new svg with $scale=$w/$W
my $scale=$w/$W;

my $HorTran=$w/3;
NewSvg($file,$HorTran);

sub NewSvg{
	print "Opening New\n";
	my $file=shift;
	my $HorTrans=shift;

	if (-e "$file.new"){unlink("$file.new");}
	open(ORIGINAL, "$file") or die "Couldn't open SVG file $file $!";
	open(NEW, ">$file.new") or die "Couldn't open new SVG file $file.new $!";
	
	my $previous="";

	while (my $line=<ORIGINAL>){
		chomp $line;
	
		if($line=~/svg\swidth/){
           		$line ="<svg width='$w' height='$w' version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'> <script xlink:href=\"/EvoMining/html/js/SVGPan.js\"/>";
## Agregar linea javaScript
		#	print "$line\n";
			}
		if($line=~/\/defs/){
			## Agregar  viewId    ### Size and center trees using main graph <g>
           		$line ="</defs> <g id=\"viewport\" transform='translate($HorTrans) scale($scale,$scale)'>";
		#	print "$line\n";
			}
			if($line=~/<\/svg>/){
		        	$line ="</g> </svg>";
		#	print "$line\n";
			}
			
		if($line=~/\<text class=\'leaf-label\'/){
			$previous=$line;
			$previous =~ s/\<text/\<a xlink\:href=\"\/EvoMining\/cgi-bin\/sendtoDrawContext\.pl\?XXXX\|$path\" target=\"iframe_abajo\"\>\<text/;
			$line="";
			}	
		
                if($line=~/\<\/text\>/ and $line=~/.*[a-zA-Z].*\<\/text\>/){
		 	my $ID=$line;
			
			if($ID=~/BGC/){
				
				#my $ID2=$ID;
				my @idSIN= split(/ /,$ID);
				$previous=~s/\/EvoMining\/cgi-bin\/sendtoDrawContext\.pl\?XXXX\|$path\" target=\"iframe_abajo\"/http:\/\/mibig\.secondarymetabolites\.org\/repository\/$idSIN[0]\/index\.html#cluster-1/;
				$previous=~s/iframe_abajo/_blank/;
				#$previous=~s/BGC0000013/siiii*$ID*/;
				$previous=~s /\|\/seqf\/tree\/\d+\.pp\.svg//;
				
				$line=$previous."\n"."<title>".$line;
				$line =~ s/\<\/text\>/\<\/title\>$ID\<\/a\>/;
				$previous="";
				}
			else{			
				if($ID=~/--/){$ID=~s/--.+//;}
				$ID=~s/\<\/text\>//;
				$line =~ s/\<\/text\>/\<\/title\>$ID\<\/text\>\<\/a\>/;
				$previous=~s/XXXX/$ID/;
				#$line=~$file.$line;
	#			$line=$previous."\n".$line;
				$line=$previous."\n"."<title>".$line;
				$previous="";
				}

			}
		print NEW "$line\n";
		}
	close ORIGINAL;
	close NEW;
	}

#below line </defs> insert: $line="<g transform='scale(.03,.03)'>"
# Sunstitute last ine for $final_line="</g> </svg>";

sub GetWidth{
	my $file=shift;
	my $width=0;
	open(ORIGINAL, "$file") or die "Couldn't open SVG file $!";
	while (my $line=<ORIGINAL>){
		chomp $line;
		if($line=~/svg\swidth/){
			#print "$line\n";
			my @sp=split("width='",$line);
			my @sp1=split("'",$sp[1]);
			#print"Split: $sp[1]\n";
			#print"Split: $sp1[0]\n";
			$width=$sp1[0];		
			print "width=$width\n";
			last;
			}	
		}
	close ORIGINAL;
	return $width;
	}

