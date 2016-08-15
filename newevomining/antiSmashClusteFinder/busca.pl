#open(FIND,"lista.buscar")or die $!;
#while(<FIND>){
# chomp;
# $hash{$_}=$_;
#}
#close FIND;

open(LIST,"AntiSMASH_CF_peg_Annotation_FULL.txt")or die $!;
while(<LIST>){
 chomp;
 @a=split(/\t/, $_);
 #if(exists $hash{$a[1]}){
    system "grep '$a[1]' /home/evoMining/newevomining/8830_TueApr2016/blast/seqf/distance.69.only";
  #$hash{$a[1]}=$a[1];
  #print "$a[1]";
  #  <STDIN>;
 #}

}
close LIST;

#open(FIND,"/home/evoMining/newevomining/DB/listaIDproteinsTODOSEVO")or die $!;
#while(<FIND>){
# chomp;
# if(exists $hash{$_}){
#    print "$_";
#    <STDIN>;
# }
#}
#close FIND;
