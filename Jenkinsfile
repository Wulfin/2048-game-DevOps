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
                git branch: 'feature/remote-deployement-terraform-ansible', url: 'https://github.com/Wulfin/2048-game-DevOps.git'
            }
        }

        // stage('TRIVY FS SCAN') {
        //     steps {
        //         sh "trivy fs ."
        //     }
        // }        

        stage ("provisioning"){
            environment{
                AWS_ACCESS_KEY_ID = ''
                AWS_SECRET_ACCESS_KEY = ''
            }
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'aws', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]){
                        dir("terraform"){
                            env.AWS_ACCESS_KEY_ID = AWS_ACCESS_KEY_ID
                            env.AWS_SECRET_ACCESS_KEY = AWS_SECRET_ACCESS_KEY

                            sh "terraform init"
                            sh "terraform apply --auto-approve"
                            
                            def tfOutput = sh(script: 'terraform output ', returnStdout: true).trim()
                            echo "Terraform Output: ${tfOutput}"
                        }
                    }
                }
            }
        }

        // stage ("configuring"){
        //     steps {
        //         script {
                

        //         }
        //     }
        // }    
    }
}