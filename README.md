# In contruction Docker Evomining using docker image:
========================================
## EvoMining Installation guide

0. Install docker engine   
1. Download nselem/evoMining docker-image  (pending)  
2. Run EvoMining    

Follow the steps, and type the commands into your terminal, do not type $.  

### 1. Install docker engine  
EvoMining runs on docker, if you have docker engine installed skip this step. This are Linux minimal docker installation guide, if you don't use Linux or you look for a detailed tutorial on Linux/Windows/Mac Docker engine installation please consult [Docker getting Starting] (https://docs.docker.com/linux/step_one/).  

`$ curl -fsSL https://get.docker.com/ | sh `  
*if you don’t have curl search on this document curl installation  
Then type:  
    `$ sudo usermod -aG docker your-user`  
Remember to substitute your-user with your user name 
Example: nsm@Leia:    
User: nsm  
###### Important step:  
Log out from your ubuntu session (restart your machine) and get back in into your user session before the next step.
You may need to restart your computer and not just log out from your session in order to changes to take effect.

Test your docker engine with the command:  
`$ docker run hello-world`  

###1 Download EvoMining images from DockerHub
`$ docker pull nselem/evomining:latest  `   (pending)  

#####Important  
`docker pull ` may be slow depending on your internet connection, because nselem/evodivmet docker-image is being downloaded, its only this time won’t happen again.  

## 2 Run evomining image  

`docker run -i -t -v /home/nelly/GIT/EvoMining/:/var/www/html -p 80:80 newevomining /bin/bash  `

Database sample  
los17  

### 2.1 Start apache  
`sudo service apache2 start  `
  
### 2.2 Set apache time  

on file: /etc/apache2/apache2.conf  
change line  
Timeout 300  
to:   
Timeout 6000000  
  
### 2.3 Setdatabases  

`vim globals $GENOMES="los17"  `
run reparaheader :walking:   
`perl reparaHEADER.pl  `  
On your browser go to:
`http://localhost/html/evoMining/indexORIG.html`   

Note: if you have your apache on port 80, just switch your local port to 8080 or another in order that EvoMining can run. 

### curl installation
- `$ which curl`
- `$ sudo apt-get update`
- `$ sudo apt-get install curl`
