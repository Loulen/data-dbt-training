import com.betclic.cicd.enums.Environment

pipeline {
    agent none

    //see https://www.jenkins.io/doc/book/pipeline/syntax/#options
    options {
        buildDiscarder(logRotator(numToKeepStr: '20'))
        disableConcurrentBuilds()
        disableResume()
        timeout(time: 1, unit: 'HOURS')
        skipDefaultCheckout()
        skipStagesAfterUnstable()
        preserveStashes(buildCount:10)
    }

    stages {
        stage('Build') {
            agent any
            steps {
                echo "======== Git checkout ========"
                checkout scm
                
                withVersioning {
                    unstable 'please add your build step and remove this line'
                }
            }
            post{
                cleanup {
                    cleanWs()
                }
            }
        }

        stage("Deploy Dev"){
            when { beforeAgent true; not { anyOf { branch "release/*"; branch "PR**" } } }
            agent any
            steps{
                echo "======== Executing deployment ========"
                unstable 'please add you deployment step and remove this line'
            }
            post{
                cleanup {
                    cleanWs()
                }
            }
        }

        stage("Tests Dev"){
            when { beforeAgent true; not { anyOf { branch "release/*"; branch "PR**" } } }
            agent { label 'cicd' }
            steps{
                echo "======== executing Integ. and Accept. Tests ========"
                unstable 'tests not implemented'
                //runTests(['tags':''])
            }
            post{
                cleanup {
                    cleanWs()
                }
            }
        }

        stage("Deploy Stage 1"){
            when { beforeAgent true; branch 'master' }
            agent any
            steps{
                echo "======== Executing deployment ========"
                unstable 'please add you deployment step and remove this line'
            }
            post{
                cleanup {
                    cleanWs()
                }
            }
        }
        
        stage("Tests Stage1"){
            when { beforeAgent true; branch 'master' }
            agent any
            steps{
                echo "======== Executing Integ., Accept. and end-to-end tests========"
                unstable 'tests not implemented'
                //runTests(['tags':''])
            }
            post{
                cleanup {
                    cleanWs()
                }
            }
        }
        
        stage("Deploy Stage 2"){
            when { beforeAgent true; anyOf { branch 'master'; branch 'release/*' } }
            agent any
            steps{
                echo "======== Executing deployment ========"
                unstable 'please add you deployment step and remove this line'
            }
            post{
                success{
                    createGithubPreRelease()
                }
                cleanup {
                    cleanWs()
                }
            }
        }
        
        stage("Tests Stage2"){
            when { beforeAgent true; anyOf { branch 'master'; branch 'release/*' } }
            agent any
            steps{
                echo "======== Executing Integ., Accept., end-to-end and load tests ========"
                unstable 'tests not implemented'
                //runTests(['tags':''])
            }
            post{
                cleanup {
                    cleanWs()
                }
            }
        }

        stage("Input Deploy Prod"){
            agent none
            when { anyOf { branch 'master'; branch 'release/*' } }
            steps{
                timeout(3) {
                    input 'Deploy prod ?'
                }
            }
        }
        
        stage("Create IT Change"){
            agent any
            when { beforeAgent true; anyOf { branch 'master'; branch 'release/*' } }
            steps{
                echo "========== IT Change creation =========="
                createITChange()
            }
            post{
                cleanup {
                    cleanWs()
                }
            }
        }
          
        stage("Check IT Change status"){
            agent none
            when { beforeAgent true; anyOf { branch 'master'; branch 'release/*' } }
            steps{
                checkITChangeStatus()
            }
        }

        stage("Deploy Prod"){
            when { beforeAgent true; anyOf { branch 'master'; branch 'release/*' } }
            agent any
            steps{
                echo "========executing deployment========"
                unstable 'please add you deployment step and remove this line'
            }
            post{
                always{
                    updateITChange()
                }
                success{
                    createGithubRelease()
                }
                cleanup {
                    cleanWs()
                }
            }
        }
    }
}
