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
		sh 'yum install wget unzip curl -y'
            }
        }

        stage('Install Terraform') {
            steps {
                script {
                    def terraformVersion = '0.15.0'
                    def downloadURL = "https://releases.hashicorp.com/terraform/${terraformVersion}/terraform_${terraformVersion}_linux_amd64.zip"
                    sh "curl -o terraform.zip '${downloadURL}'"
                    sh 'unzip terraform.zip'
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

