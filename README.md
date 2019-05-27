# Evomining docker image:
========================================  
This is a quick guide but further information can be found at https://github.com/nselem/EvoMining/wiki  

## EvoMining Installation guide

1. Install docker engine   
2. Download nselem/evomining docker image  
3. Run EvoMining    

Follow the steps, and type the commands into your terminal, do not type $.  
   
---
    
### 1. Install docker engine  
EvoMining runs on docker, if you have docker engine installed skip this step.  

`$ curl -fsSL https://get.docker.com/ | sh `  
*if you don’t have curl follow [Curl installation](#curl-installation)  
  
Then type:  
    `$ sudo usermod -aG docker <your-user>`  
Remember to substitute <your-user> with your user name    
Example: `nsm@Leia`  
User: nsm    

* This are Linux minimal docker installation guide, if you don't use Linux or you are looking for a detailed tutorial on Linux/Windows/Mac docker engine installation please consult [Docker getting Starting](https://docs.docker.com/linux/step_one/). 
    
  
###### Important step:   
Log out from your ubuntu session (restart your machine) and get back in into your user session before the next step.
You may need to restart your computer and not just log out from your session in order to changes to take effect.
  
Test your docker engine with the command:    
`$ docker run hello-world`    

---  
  
### 2 Download EvoMining images from DockerHub  
Pull evomining docker image from dockerHub with the following command:   
`$ docker pull nselem/evomining:latest  `    
if you already have EvoMining docker images skip this step.  

##### Important    
`docker pull ` may be slow depending on your internet connection, at this step nselem/evomining docker-image is being downloaded. Pull is run only once to download EvoMining images.

It is posible to check that EvoMining images is installed by typing:  
`$ docker images`    
> REPOSITORY           |TAG           |IMAGE ID        |CREATED       |SIZE     |
>----------------------|--------------|----------------|--------------|---------|
> nselem/evomining  | latest       |  954ca43b8a23  |4 months ago  | 2.58GB  |
   
---   
   
## 3 Run evomining image  

### 3.1 Run evomining image
Place yourself at your working directory.    
 `$ docker run --rm -i -t -v $(pwd):/var/www/html/EvoMining/exchange -p 80:80 nselem/evomining:latest /bin/bash`

sometimes the port 80 is bussy, on that case you can use other ports like 8080 or 8084:    
`$ docker run --rm -i -t -v $(pwd):/var/www/html/EvoMining/exchange -p 8080:80 nselem/evomining:latest /bin/bash`  
`$ docker run --rm -i -t -v $(pwd):/var/www/html/EvoMining/exchange -p 8084:80 nselem/evomining:latest /bin/bash`  

### 3.2 Set databases  
Initialize EvoMining pipeline on the interactive shell of the EvoMining docker image.  
To run a default data included on docker distribution use:  
`# perl startEvoMining.pl`  
  
To run EvoMining with your own databases use the modifiers:  
`# perl startEvoMining.pl -g <genome-DB> -r <myRastIds> -c <central-DB> -n <natural-DB> -a <antismash_db>`   
Or follow the example tutorial.    

### 3.3 View your results  
Open EvoMining web interface and follow the steps until the tree visualization.  
If you are running EvoMining on your local machine.   
`http://localhost/EvoMining/html/index.html`   
   
or, if you are running EvoMining on a remote machine.   
`http://<yourip>/EvoMining/html/index.html`  

### 3.4 Common fails  
  
Some computers does not have writing permision and does not let EvoMining run, go one level up of your directory and change permissions    
`sudo chmod +x mydir`   
`sudo chmod +w mydir`   

---   
  
### Curl installation
- `$ which curl`
- `$ sudo apt-get update`
- `$ sudo apt-get install curl`
