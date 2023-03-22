pipeline {
    agent {
        label 'aws-agent'
    }
    environment {
        AWS_CREDENTIALS = credentials('devops_aws')
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
                node {
                    sh 'cd certask && terraform init'
                    sh 'cd certask && terraform apply -auto-approve'
                }
            }
        }
        stage('Configure Ansible') {
            steps {
                node {
                    script {
                        def instance_ip = sh(returnStdout: true, script: 'cd certask && terraform output -raw instance_ip').trim()
                        writeFile file: 'certask/inventory.ini', text: "${instance_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=${SSH_CREDENTIALS}"
                    }
                }
            }
        }
        stage('Deploy Application') {
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
            node {
                sh 'cd certask && terraform destroy -auto-approve'
            }
        }
    }
}
