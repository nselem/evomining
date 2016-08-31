use strict;
use warnings;


################################################################
## Input a fasta file from Rast (With jobId.faa as name)
## output fasta file in EvoMining format
###################################################################
## Variables 

my $condicion=1;
my $file=$ARGV[0]; #Job Id
my $file2=$ARGV[1]; #RastIDs with orgnisms name
my $output_path=$ARGV[2]; #output path
my %GENOME;

#####################################################################
#### main program __________________________________________
print "Genome $file\nRAST IDS $file2\noutput path $output_path\n";
my $Org=readRastGenomeFile($file,\%GENOME);  ## 
my $OrgName=readOrgName($Org,$file2);  ## Return organism name
printEvo(\%GENOME,$Org,$OrgName,$file,$output_path); ## Print file

##################### Subs ##############################3
sub printEvo{
    my $refGENOME=shift;
    my $Org=shift;
    my $OrgName=shift;
    my $file=shift;
    my $output_path=shift;
    
    my @st=split(" ",$OrgName);
    print "$OrgName\n";
    my $NCBI; ## OR BGC now that we expandaded DB's
    my $file3=$file;
    $file3=~s/faa/txt/;

    foreach my $key (sort keys %{$refGENOME}){
    	my $out=`grep   '\.$key\t' $file3`;
	chomp $out;
	$out=~s/\\//g;
	$out=~s/\|//g;
	$out=~s/\//\_/g;
	$out=~s/\&/\_/g;
	$out=~s/\-/\_/g;
	$out=~s/\)/\_/g;
	$out=~s/\(/\_/g;
        $out =~ s/\]|\[//g;
        $out =~ s/\+//g;
        $out =~ s/\r//g;
        $out =~ s/\://g;
        $out =~ s/  / /g;
        $out =~ s/ /_/g;
        $out =~ s/\'/_/g;
        $out =~ s/\,//g;
        $out =~ s/\;//g;

	my $type;
	if($out=~/peg\.$key\t/){$type="peg";}
	elsif($out=~/rna\.$key\t/){
		$type="rna";
		print "type $type\n key $key\n"; 
		}
	else{$type=$out;}
#	print "out $out\n ";

       my @st2=split(/\t/,$out); #Function

	if($st[1]){
    		$NCBI=$st[$#st];
    		$OrgName=~s/$NCBI//;
		}
    	else{
		$NCBI=$st2[0];
		}
	
		system("perl -p -i -e 's/.*[0-9]*.[0-9]*.*.[0-9]*/>gi\|$Org.$key\|$Org\|$NCBI\|$st2[7]\|$OrgName\|/ if /$type.$key\n/' $file ");
     }
    }
##################################################

sub readOrgName{
	## Reads Id file return organism name
    my $Org=shift;
    my $file2=shift;
    my $name;
    open(FILE, "$file2") or die "Couldnt open Fasta $file2 $!\n";

    foreach my $line (<FILE>){
        chomp $line;
#        print "$line\n";
        my @st=split("\t",$line);
        if ($line =~/$Org/){
 #           print"$st[0]\t$st[1]\t$st[2]\n";
            $name=$st[2];
            last;
            }
        }
    return $name;
    close FILE;
    }


#####################################################
sub readRastGenomeFile{
	## Files a hash with fasta sequences key peg number, and return organisms number
    my $file=shift;  ## JobId.txt
    my $refGENOME=shift;
    my $orgNum;
    my $id="";
    if (-e "$file\.evo"){
	system("rm $file");
	exit;
	}
    open(FILE, "$file") or die "Couldnt open Fasta $file $!";
    foreach my $line (<FILE>){
        chomp $line;
        if ($line=~ />/ ){
            my $newline=$line;
            $newline=~s/>fig\|//;
            $newline=~s/\./\t/g;
            my @st=split("\t",$newline);
            #print "$st[0] \t $st[1] \t $st[3] \n";           
            $orgNum = join(".", $st[0], $st[1]);
            $id=$st[3]; ## gen id /could be rna or peg
            }
        else{
            if(!exists $refGENOME->{$id}){$refGENOME->{$id}="";}
            $refGENOME->{$id}=$refGENOME->{$id}.$line."\n";
            }
        }

    close FILE;
    return $orgNum;   
    }
