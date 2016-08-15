use Fcntl ; use DB_File ; $tipoDB = "DB_File" ; $RWC = O_CREAT|O_RDWR;
use globals;

$genomes=$GENOMES; #from globals
$antismash=$ANTISMASH; #from globals

my $tfmAsmash= "hashANTISAMASandCF$GENOMES.db" ;; #from globals


$handAM = tie my %hashANTISMASHid, $tipoDB , "$tfmAsmash" , $RWC , 0644 ;
print "$! \nerror tie para $tfmAM \n" if ($handAM eq "");

########################ANTISMASH###################################


  open(SMASH,"AntiSMASH_CF_peg_Annotation_FULL.txt");
#  open(SMASH,"antiSmashClusteFinder/AntiSMASH_CF_peg_Annotation_FULL.txt");

  while(<SMASH>){
    chomp;
    @asmash=split (/\t/,$_);

    $hashANTISMASHid{$asmash[1]}=$asmash[2];
    #print  "$asmash[1]-->$asmash[2]\n";
    #<STDIN>;
   
  }
  close SMASH;
  untie %hashANTISMASHid;
########
