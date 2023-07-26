# continuousdelivery-empty-jenkins-template
Template for new empty project for Jenkins

Empty Pipeline documentation : [here](https://jira.betclicgroup.com/wiki/x/ciRIC)

## Let's get started ? 

1) Add your code in src folder

2) the Jenkinsfile get your code but all other steps need to be complete. 

This pipeline contains a Jenkinsfile with the standard flow :
* Git checkout in first step, you need to add build process and stash files that only need for next deployment steps (as jar file)
* Deployment and test steps empty
* A manual step to validate production deployment


for more information about Jenkinsfile, go to [Jenkinsfile documentation](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/)

Jenkins in Betclic documentation : [here](https://jira.betclicgroup.com/wiki/x/bsTiBg)

## Contact 

To contact CICD Team, feel free to send a message on our Teams channel [here](https://teams.microsoft.com/l/channel/19%3af2eebcc7fb6e4523a9c79278a4707bdf%40thread.skype/Continuous%2520Delivery?groupId=74d69878-c2c0-4120-925e-93de5876289c&tenantId=349cb0f5-cf5b-4f4c-89f1-e13af5555b16)
