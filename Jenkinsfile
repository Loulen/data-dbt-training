import com.betclic.cicd.enums.Environment

pipeline {
    agent none

    //see https://www.jenkins.io/doc/book/pipeline/syntax/#options
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        disableResume()
        timeout(time: 1, unit: 'HOURS')
        skipDefaultCheckout()
        skipStagesAfterUnstable()
        preserveStashes(buildCount:5)
    }

    stages {
        stage('Build') {
            agent any
            steps {
                echo "======== Git checkout ========"
                checkout scm
                
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
