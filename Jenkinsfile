pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/vir2ozz/certask.git'
            }
        }
        stage('Provision Infrastructure') {
            steps {
                script {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'devops_aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'],
                        sshUserPrivateKey(credentialsId: 'ssh_aws', keyFileVariable: 'SSH_PRIVATE_KEY')
                    ]) {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
        stage('Run Ansible Playbook') {
            steps {
                ansiblePlaybook(
                    inventory: 'ansible/hosts',
                    playbook: 'playbook.yml',
                    credentialsId: 'ssh_aws',
                    extras: '--private-key=${SSH_PRIVATE_KEY} -u ec2-user'
                )
            }
        }
    }
    post {
        always {
            script {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'devops_aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}
