$cluster_flag=0;

@bgc=qx/find .\/* -type f -iname "*_*region*.gbk"/;
foreach my $file (@bgc){
    	chomp $file;
	#    	print "file  $file\n";
	#    	my $pause=<STDIN>;
    	$file=~m/\.\/(\w*)\/(.+)\.(region\d*)\.gbk/;
	#print "File $file, 1 $1, 2 $2,3  $3 \n";

    	my $JobId=$1;
	my $cluster_number="$2\.$3";
	#	my $job_id="$2";

	#print "File $file, 1 $JobId, 2 $cluster_number \n";
	#my $pause=<STDIN>;

	open FILE, $file or die "I cannot open $file \n";
	
    	while ($line=<FILE>){
		chomp $line;
#		#print "line $line, $cluster_flag\n";
        	if ($line=~/\     cluster         / or $line=~/     protocluster    /){
    	        $cluster_flag=1;
#		exit;
        	}
        if ($line=~/\/product=/ && $cluster_flag==1){
            $line=~/(\/product=")(.+)(")/;
            $cluster_class=$2;
            $cluster_flag=0;
        }
        if ($line=~/SEED\:fig\|/){
            $line=~/(.+SEED\:fig\|)(.+)(")/;
            $peg_id="$2";
	    $peg_id=~s/\.peg\./\./;
            print "$JobId\t$peg_id\t$cluster_class\t$cluster_number\n";
            }
    }
}
