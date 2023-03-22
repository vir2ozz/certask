pipeline {
    agent {
        label 'aws-agent'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/vir2ozz/certask.git']]
                ])
            }
        }
        stage('Terraform Init & Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    credentialsId: 'devops_aws',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh 'cd certask && terraform init'
                    sh 'cd certask && terraform apply -auto-approve'
                }
            }
        }
        stage('Build Java Application') {
            steps {
                sh 'mvn clean package'
                sh 'cp target/hello-1.0.war certask/hello-1.0.war'
            }
        }
        stage('Ansible Deployment') {
            steps {
                withCredentials([[
                    $class: 'SSHUserPrivateKey',
                    keyFileVariable: 'SSH_PRIVATE_KEY',
                    passphraseVariable: '',
                    usernameVariable: 'SSH_USERNAME',
                    credentialsId: 'ssh_aws'
                ]]) {
                    sh 'export ANSIBLE_HOST_KEY_CHECKING=False'
                    sh 'ansible-playbook -i "$(cd certask && terraform output -raw instance_public_ip)," -u ubuntu --private-key="${SSH_PRIVATE_KEY}" certask/playbook.yml'
                }
            }
        }
    }
    post {
        always {
            sh 'cd certask && terraform destroy -auto-approve'
        }
    }
}
