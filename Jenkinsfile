pipeline {
    agent {
        label 'aws-ec2'
    }
    environment {
        AWS_CREDENTIALS = credentials('aws-devops-credentials')
    }
    stages {
        stage('Initialize Terraform') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Apply Terraform') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Build Java Application') {
            steps {
                git 'https://github.com/vir2ozz/certask.git'
                sh 'mvn clean package'
            }
        }
        stage('Run Ansible Playbook') {
            steps {
                ansiblePlaybook(
                    playbook: 'ansible/deploy.yml',
                    inventory: 'ansible/hosts',
                    credentialsId: 'aws-devops-credentials'
                )
            }
        }
    }
    post {
        always {
            sh 'terraform destroy -auto-approve'
        }
    }
}
