pipeline {
    agent none
    stages {
        stage('Provision AWS infrastructure') {
            agent {
                label 'aws-ec2'
            }
            steps {
                git 'https://github.com/your-terraform-repo.git'
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Build and Deploy Application') {
            agent {
                label 'aws-ec2'
            }
            steps {
                git 'https://github.com/your-ansible-repo.git'
                ansiblePlaybook(
                    playbook: 'build_and_deploy.yml',
                    inventory: 'inventory.ini'
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
