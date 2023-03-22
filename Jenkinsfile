pipeline {
    agent { label 'aws-agent' }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('devops_aws')
        AWS_SECRET_ACCESS_KEY = credentials('XrwB+wFM2qoe4cLoXcFPwaevnxQTKTEqCnChBBFV')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }
    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Build Java App') {
            steps {
                git url: 'https://github.com/vir2ozz/certask.git'
                sh 'mvn clean install'
            }
        }
        stage('Configure Ansible') {
            steps {
                script {
                    def instance_ip = sh(script: "terraform output -json | jq -r '.app_ip.value'", returnStdout: true).trim()
                    writeFile file: 'inventory.ini', text: "app ansible_host=${instance_ip} ansible_user=ubuntu ansible_ssh_private_key_file=credentials('ssh_aws')"
                }
            }
        }
        stage('Run Ansible Playbook') {
            steps {
                ansiblePlaybook(
                    inventory: 'inventory.ini',
                    playbook: 'playbook.yml'
                )
            }
        }
    }
    post {
        always {
            deleteDir()
        }
    }
}
