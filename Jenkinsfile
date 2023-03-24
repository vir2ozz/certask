pipeline {
    agent any

    stages {
        stage('Init') {
            steps {
                git 'https://github.com/vir2ozz/certask.git'
            }
        }
        stage('Terraform') {
            steps {
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Ansible') {
            steps {
                sh 'ansible-playbook -i aws_ec2.yml playbook.yml'
            }
        }
    }
}
