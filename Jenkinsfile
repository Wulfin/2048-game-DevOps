pipeline {
    agent any
    tools{
        ansible 'ansible'
    }
    stages {
        stage('cleanws') {
            steps {
                cleanWs()
            }
        }

        stage('checkout'){
            steps{
                git branch: 'main', url: 'https://github.com/Wulfin/2048-game-DevOps.git'
            }
        }

        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs ."
            }
        }        

        stage ("provisioning"){
            environment{
                AWS_ACCESS_KEY_ID = ''
                AWS_ACCESS_KEY_SECRET = ''
            }
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'aws', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_ACCESS_KEY_SECRET')]){
                        dir("terraform"){
                            sh "terraform init"
                            sh "terraform apply --auto-approve"
                            
                            def tfOutput = sh(script: 'terraform output ', returnStdout: true).trim()
                            echo "Terraform Output: ${tfOutput}"
                        }
                    }
                }
            }
        }

        stage ("configuring"){
            steps {
                
            }
        }    
    }
}