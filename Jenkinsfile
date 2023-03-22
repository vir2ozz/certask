pipeline {
    agent {
        label 'aws-ec2'
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                    env.AWS_ACCESS_KEY_ID = 'AKIA5M4V4GFC47QOD6VK'
                    env.AWS_SECRET_ACCESS_KEY = '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'
                    env.AWS_DEFAULT_REGION = 'us-east-1'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                terraform.init(
                    credentialsId: 'devops_aws',
                    sourceDir: 'terraform'
                )
            }
        }

        stage('Terraform Apply') {
            steps {
                terraform.apply(
                    credentialsId: 'devops_aws',
                    sourceDir: 'terraform',
                    environment: [AWS_ACCESS_KEY_ID: env.AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY: env.AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION: env.AWS_DEFAULT_REGION]
                )
            }
        }

        stage('Ansible Setup') {
            steps {
                ansiblePlaybook(
                    playbook: 'ansible/playbook.yml',
                    inventory: 'ansible/hosts.ini',
                    credentialsId: 'ssh_aws',
                    extras: '-e aws_access_key=${AWS_ACCESS_KEY_ID} -e aws_secret_key=${AWS_SECRET_ACCESS_KEY} -e aws_region=${AWS_DEFAULT_REGION}'
                )
            }
        }
        
        stage('Cleanup') {
            steps {
                terraform.destroy(
                    credentialsId: 'devops_aws',
                    sourceDir: 'terraform',
                    environment: [AWS_ACCESS_KEY_ID: env.AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY: env.AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION: env.AWS_DEFAULT_REGION]
                )
            }
        }
    }
}
