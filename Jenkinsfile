pipeline {
    agent any
    environment {
        AWS_CREDENTIALS = credentials('devops-student_aws')
        SSH_CREDENTIALS = credentials('ssh_aws')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/vir2ozz/certask.git'
            }
        }
        stage('Terraform Init & Apply') {
            steps {
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Configure Ansible') {
            steps {
                script {
                    def instance_ip = sh(returnStdout: true, script: 'terraform output -raw instance_ip').trim()
                    writeFile file: 'inventory.ini', text: "${instance_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=${SSH_CREDENTIALS}"
                }
            }
        }
        stage('Deploy Application') {
            steps {
                ansiblePlaybook(
                    playbook: 'playbook.yml',
                    inventory: 'inventory.ini',
                    installation: 'system',
                    credentialsId: 'ssh_aws'
                )
            }
        }
    }
    post {
        always {
            node('any') {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
    
}
