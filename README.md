#Evomining using docker image:
========================================
## EvoMining Installation guide

0. Install docker engine   
1. Download nselem/newevomining docker image  
2. Run EvoMining    

Follow the steps, and type the commands into your terminal, do not type $.  

### 1. Install docker engine  
EvoMining runs on docker, if you have docker engine installed skip this step.  

`$ curl -fsSL https://get.docker.com/ | sh `  
*if you don’t have curl follow [Curl installation](#curl-installation)
Then type:  
    `$ sudo usermod -aG docker your-user`  
Remember to substitute your-user with your user name    
Example: `nsm@Leia`  
User: nsm    

* This are Linux minimal docker installation guide, if you don't use Linux or you are looking for a detailed tutorial on Linux/Windows/Mac docker engine installation please consult [Docker getting Starting](https://docs.docker.com/linux/step_one/). 
    
  
###### Important step:   
Log out from your ubuntu session (restart your machine) and get back in into your user session before the next step.
You may need to restart your computer and not just log out from your session in order to changes to take effect.
  
Test your docker engine with the command:    
`$ docker run hello-world`    

### 1 Download EvoMining images from DockerHub  
`$ docker pull nselem/newevomining:latest  `    
  
##### Important    
`docker pull ` may be slow depending on your internet connection, because nselem/evodivmet docker-image is being downloaded, its only this time won’t happen again.    

## 2 Run evomining image  

#1 Run evomining image
 `docker run -i -t -v /home/yourvolume:/var/www/html/EvoMining/exchange -p 80:80 nselem/newevomining:latest /bin/bash`

#2 Set databases  
`perl startevomining -g mygenomes -r myRastIds`  

#3 View your results
If you are running EvoMining on your local machine.   
`http://localhost/html/EvoMining/index.html`   
   
or, if you are running EvoMining on a remote machine.   
`http://yourip/html/EvoMining/index.html`  
and follow the steps.  

### Curl installation
- `$ which curl`
- `$ sudo apt-get update`
- `$ sudo apt-get install curl`
