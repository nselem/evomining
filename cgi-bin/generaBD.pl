use globals;
$genomes=$GENOMES; #from globals

`mkdir DB/$genomes`;
open(LIST,"DB/$genomes.lista") or die $!;
open(OUT,">DB/$genomes/$genomes.fasta") or die $!;
open(BD,"DB/Todos.EVO3") or die $!;


while(<LIST>){
chomp;
 $hash{$_}=$_;
 #print "---$_\n";
 #<STDIN>;
}
close LIST;
print "hash loaded\n";
#
#<STDIN>;

while(<BD>){
chomp;
 if($_ =~ />/){
   @a =split(/\|/, $_);
  # print "$a[5]\n";
   if(exists $hash{$a[5]}){
     $header=$_;
     $flag=1;
     print OUT "$_\n";
    #<STDIN>;
   }
   else {
      $flag=0;
   }
 }
 else{
   if ($flag==1){
     print OUT "$_\n";
   }
 
 }


}#end while
print "Done\n";
close OUT;
close BD;
