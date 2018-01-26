3.2 After genome assembly, the annotation is standardized by the Rapid Annotation using Subsystem Technology (RAST) platform. Upload DNA contigs to RAST to annotate them and download the annotation file.
3.2.1 Access RAST either by its web interface following directions at http://rast.nmpdr.org/rast.cgi or by myrast command line docker image.  
3.2.1.1 To use myRAST docker image for the first time download the docker image from the dockerhub typing the following at the command line:  
`docker pull nselem/myrast`  
3.2.1.2 To annotate a genome once the myRAST docker image is installed, run the image on the same folder where the genome fasta file is located:  
   `docker run -i -t -v $(pwd):/home nselem/myrast /bin/bash`  
Upload the genome using you RAST account, employ the command:  
svr_submit_RAST_job -user <user> -passwd <pass> -fasta <file> -domain Bacteria -bioname "Organism name" -genetic_code 11 -gene_caller rast  
3.2.1.3 Create a folder GENOMES and download there the aminoacid and annotation files from RAST servers by typing:  
`svr_retrieve_RAST_job <user> <password> <jobId> table_txt > $<jobId>.txt`  
`svr_retrieve_RAST_job <user> <password> <jobId> amino_acid > $<jobId>.faa`  
Note: To optimize uploading/downloading time by interacting with several genomes on batch follow directions at https://github.com/nselem/myrast.  

