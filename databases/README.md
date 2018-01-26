# Databases available  
- Natural DB: my_nat_los10  
- Central DB: mycent_los10  
- Genomic DB: Follow instructions  
Genomic DB is available at RAST EvoMining account.  
To download 1246 Actinobacteria genomes use myrast docker interface.  

To use myRAST docker image for the first time download the docker image from the dockerhub typing the following at the command line:  
`docker pull nselem/myrast`  

Create a folder genome-DB and download there the aminoacid and annotation files from RAST servers by typing:  
`cd genome-DB`  
`svr_retrieve_RAST_job <user> <password> <jobId> table_txt > $<jobId>.txt`  
`svr_retrieve_RAST_job <user> <password> <jobId> amino_acid > $<jobId>.faa`    
Note: To optimize uploading/downloading time by interacting with several genomes on batch 
`cut -f1 Rast_ID | while read line; do svr_retrieve_RAST_job <user> <password> $line amino_acid > $line.txt ; done`  

# Constructing custom genomic-DB

3.2 After genome assembly, the annotation is standardized by the Rapid Annotation using Subsystem Technology (RAST) platform. Upload DNA contigs to RAST to annotate them and download the annotation file.
3.2.1 Access RAST either by its web interface following directions at http://rast.nmpdr.org/rast.cgi or by myrast command line docker image.  
3.2.1.1 To use myRAST docker image for the first time download the docker image from the dockerhub typing the following at the command line:  
`docker pull nselem/myrast`  
3.2.1.2 To annotate a genome once the myRAST docker image is installed, run the image on the same folder where the genome fasta file is located:  
   `docker run -i -t -v $(pwd):/home nselem/myrast /bin/bash`  
Upload the genome using you RAST account, employ the command:  
svr_submit_RAST_job -user <user> -passwd <pass> -fasta <file> -domain Bacteria -bioname "Organism name" -genetic_code 11 -gene_caller rast   
3.2.1.3 Download genomes as explained before.  
