This Jenkins project setup follows the Jenkins Docker install instructions 
provided by 'https://www.jenkins.io/doc/book/installing/docker/'.

I put the 'docker run' command instructions in a shell script since
those are runtime configuration commands and putting in bash 
scripts makes the project more portable.


Folder Structure
====================================

docker_project/
   |
   |
   |___ jenkins/
	   |
	   |
	   |___ Dockerfile.jenkins
	   |
	   |___ build.sh
	   |
	   |___ run.sh
	   |
	   |___ cleanup.sh 
