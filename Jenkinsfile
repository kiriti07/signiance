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

    post {
        always {
            // Actions to always perform at the end, success or fail.
        }
        success {
            // Actions to perform only when the pipeline was successful.
            echo 'Operation successful!'
        }
        failure {
            // Actions to perform if there was a failure.
            echo 'Operation failed!'
        }
    }
}

