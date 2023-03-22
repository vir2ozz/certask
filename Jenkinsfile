pipeline {
    agent none
    environment {
        AWS_CREDENTIALS = credentials('devops_aws')
        SSH_CREDENTIALS = credentials('ssh_aws')
    }
    stages {
        stage('Checkout') {
            agent any
            steps {
                git branch: 'master', url: 'https://github.com/vir2ozz/certask.git'
            }
        }
        stage('Terraform Init & Apply') {
            agent any
            steps {
                sh 'cd certask && terraform init'
                sh 'cd certask && terraform apply -auto-approve'
            }
        }
        stage('Configure Ansible') {
            agent any
            steps {
                script {
                    def instance_ip = sh(returnStdout: true, script: 'cd certask && terraform output -raw instance_ip').trim()
                    writeFile file: 'certask/inventory.ini', text: "${instance_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=${SSH_CREDENTIALS}"
                }
            }
        }
        stage('Deploy Application') {
            agent any
            steps {
                ansiblePlaybook(
                    playbook: 'certask/playbook.yml',
                    inventory: 'certask/inventory.ini',
                    installation: 'system',
                    credentialsId: 'ssh_aws'
                )
            }
        }
    }
    post {
        always {
            agent any
            steps {
                sh 'cd certask && terraform destroy -auto-approve'
            }
        }
    }
}
