pipeline{
    agent {
        node {
            label 'agent-1'
        }
    }
    options {
        timeout(time: 1, unit: 'HOURS')
        disableConcurrentBuilds()
        ansiColor('xterm')
    }
    stages{
        stage('VPC'){
            steps{
                sh """
                    cd 01-vpc/
                    terraform apply -auto-approve
                """
            }
        }
        stage('SG'){
            steps{
                sh """
                    cd 01-sg/
                    terraform apply -auto-approve
                """
            }
        }
        stage('VPN'){
            steps{
                sh """
                    cd 03-vpn/
                    terraform apply -auto-approve
                """
            }
        }
        stage('DB and ALB') {
            parallel {
                stage('Databases'){
                    sh '''
                        cd 04-databases
                        terraform apply -auto-approve
                    '''
                }
                  stage('App ALB'){
                    sh '''
                        cd 05-app-alb
                        terraform apply -auto-approve
                    '''
                }
            }
        }
    }

    post {
        always{
            echo 'I will run always'
            deleteDir()
        }
    }


}