pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your code from the GitHub repository
                checkout scm
		sh 'sudo yum install wget unzip -y'
            }
        }

        stage('Install Terraform') {
            steps {
                script {
                    def terraformVersion = '0.15.0'
                    def downloadURL = "https://releases.hashicorp.com/terraform/${terraformVersion}/terraform_${terraformVersion}_linux_amd64.zip"
                    sh "sudo wget '${downloadURL}'"
                    sh 'unzip terraform_0.15.0_linux_amd64.zip'
		    sh 'echo $"export PATH=\$PATH:$(pwd)" >> ~/.bash_profile'
                    sh 'source ~/.bash_profile'
		    sh 'sudo mv terraform /usr/local/bin/'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                // Initialize Terraform
                sh 'terraform init'
            }
        }

        stage('Terraform Apply') {
            steps {
                // Apply Terraform configuration
                sh 'terraform apply -auto-approve'
            }
        }

        // Add any additional stages as needed (e.g., tests, notifications)
    }
}

