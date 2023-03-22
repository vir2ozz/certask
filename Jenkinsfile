pipeline {
    agent {
        label 'jenkins_agent'
    }
    stages {
        stage('Provision AWS instance') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'devops_aws']]) {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Build and deploy Java application') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh_aws', keyFileVariable: 'SSH_KEY')]) {
                    ansiblePlaybook(
                        credentialsId: 'ssh_aws',
                        inventory: 'aws_instance.jenkins_agent.public_ip',
                        playbook: 'playbook.yml',
                        extraVars: [
                            'ansible_user': 'ubuntu',
                            'ansible_ssh_private_key_file': "${SSH_KEY}"
                        ]
                    )
                }
            }
        }
    }
}
