use globals;

$faa_list=$FAA_LIST; #from globals
$genomes=$GENOMES; #from globals

print "ls DB/$genomes/*.faa \| while read line\; do perl 1.1.Genome_RAST_to_Evo.pl \$line DB/$genomes/$faa_list \; done";


`ls DB/$genomes/*.faa \| while read line\; do perl 1.1.Genome_RAST_to_Evo.pl \$line DB/$genomes/$faa_list \; done`;

#`cat DB/$genomes/*.evo3>$genomes.fasta`;
