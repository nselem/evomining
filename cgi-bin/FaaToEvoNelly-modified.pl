#!/bin/perl -w

## I want to extract CDS entrys and ids from a geneBankFile
use Bio::SeqIO;

## This script also need annotation RAST file txt 
my $file=$ARGV[0]; # Job Id fasta file
my $rastFile=$ARGV[1]; ##Organism Name
my $outputpath=$ARGV[2];

my @st0=split('/',$file);
my $genoId=$st0[$#st0];
$genoId=~s/\.faa//;
my $txtFile="RAST/$genoId\.txt";
$txtFile=~s/faa/txt/;
my $temp=`grep $genoId $rastFile`;
#system ("echo grep $genoId $rastFile");
#print "output path $file.evo\n";
#my $pause=<STDIN>;
chomp $temp;
my @st=split(/\t/,$temp);
my $orgName=$st[2];
#print "OrgName $orgName\n";
#print "text file $txtFile";

my %ANOTATION;
##########################
 if (-e "$file\.evo"){
        exit;
        }
###############################
open(FILE, "$txtFile"), or die "Fail with $txtFile\n $!";
foreach my $line (<FILE>){
	chomp $line;
	#print "Line $line\n";
	my @st=split(/\t/,$line);
	$st[1]=~s/fig\|//g;
#	$st[1]=~s/\.peg\./_/g;
#	$st[1]=~s/\./_/g;
	$ANOTATION{$st[1]}=$st[7];
	#print "$st[1]-> $st[7]\n";
	#print "$st[1]#$ANOTATION{$st[1]}!\n";
	
	}

$seqio_obj = Bio::SeqIO->new(-file => "$file",  -format => "fasta" );
my $out= Bio::SeqIO->new(-file=> ">$file\.evo",-format=> 'Fasta');

while( my $seq = $seqio_obj->next_seq ) {
	my $ID=$seq->id;
	#print "ID: $ID \n";
	my $genId=$ID;
	$ID=~s/fig\|//g;
	#print "ID: #$ID#\n";
	$genId=~s/.peg//;
	$genId=~s/fig\|//;
	#print "genId: #$genId#\n";

        my @st=split(/\./,$genId);
        #print "OrgName: $orgName\n";
	my @NCBI=split(/\s/,$orgName);
	#foreach my $part (@NCBI){print "NCBI $part,\n";} 
	my $ncbi=$NCBI[$#NCBI];
	#print "ncbi: $ncbi\n";
	my $function=$ANOTATION{$ID};
	#print "function: $function\n";	
	#my $pause=<STDIN>;
	$function=~s/;//g;
	$function=~s/\|//g;
	$function=~s/\&//g;
	$orgName=~s/\(|\)/_/;
	#print "$ID -> $function\n";
#>gi|6666666.278093.1|6666666.278093|WC3796|Coenzyme F420-dependent N5,N10-methylene tetrahydromethanopterin reductase and related flavin-dependent oxidoreductases|James WC3796
        my $newId= "gi|".$genId."|".$st[0].".".$st[1]."|".$ncbi."|".$function."|".$orgName;
        #print "gi|".$genId."|".$st[0].".".$st[1]."|".$ncbi."|".$function."|".$orgName."\n";
	#my $pause=<STDIN>;
	$newId=~s/ /_/g;
$seq->display_id("$newId");
$out->write_seq($seq);	

#   print $seq->seq() . "\n"; 
 }
$seqio_obj->close();
$out->close();
exit;
