

#------------apache CGI path--------------
$APACHE_CGI_PATH="/var/www/html/EvoMining/cgi-bin"; #evom-0-3ORIG.pl	#evomBlastNp2.0ORIG.pl #alignGcontextORIG.pl
$APACHE_HTML_PATH="/var/www/html/EvoMining/html";

#-------------RAST_to_Evo conf -----------------------

$FAA_LIST="AleIds.RAST";




#---------Genomes names made by  reparaHEADER.pl-----------------------------

#$GENOMES="los1244"; #reparaHEADER.pl
#$GENOMES="los87"; #reparaHEADER.pl
#$GENOMES="los30"; #reparaHEADER.pl
$GENOMES="los17"; #reparaHEADER.pl
#$GENOMES="los30B"; #reparaHEADER.pl
#$GENOMES="enterobacteria"; #reparaHEADER.pl and master.pl


$boolGENOMES_DB=1;

#--- Generados con /var/www/newevomining/DB/reparaHEADER.pl------------------ 
$TFM1A = "hashOrdenNombres1_$GENOMES.db" ;#evom-0-3ORIG.pl
$TFM2A = "hashOrdenNombres2_$GENOMES.db" ;#evom-0-3ORIG.pl
$TFM3A = "hashOrdenNombres3_$GENOMES.db" ;#evom-0-3ORIG.pl
#----------------------------------------------------------------------------

#-----central pathways---------------------
##### Central Pathways DB (Query file with Mycobacterium and Coelicolor central pathways information 
##will be blastagainst genome DB to identify expanded enzyme families)
$boolCENTRAL_DB=0;
$VIA_MET="ALL_curado.fasta";#evom-0-3ORIG.pl 	#evomBlastNp2.0ORIG.pl

#$VIA_MET="tRAPs_centrales_Jun2016.txt";
## Result of the previous blast will be stored on:
## Blast central pathways vs Genomes  (Will be used on heatplot and for the red color)
$BLAST_FILE="pscp$GENOMES.blast"; #evom-0-3ORIG.pl

#------------------------------------------------------------------------------
######## Natural products data Base
$boolNP_DB=1;
#$NP_DB="NP_DB_NOVEMBER2014clean.txt"; 	#evomBlastNp2.0ORIG.pl
$NP_DB="MiBIG_DB.faa"; 	#evomBlastNp2.0ORIG.pl
#$NP_DB="susanaNP.faa"; 	#evomBlastNp2.0ORIG.pl

#$NP_DB="MiBIG_DBplusPAU.faa";
#-------------------------------------------------------------------------------
 $TFM = "hashMETCENTRAL$GENOMES.db" ; #bbh.pl
 
#-----------------Cluster finder and AntiSmash----------------------------------

$ANTISMASH="AntiSMASH_CF_peg_Annotation_FULL.txt";
#-------------------------------------------------------------------------------
