pipeline {
    agent any
    environment {
        AWS_CREDENTIALS = credentials('ubuntu_aws')
        SSH_CREDENTIALS = credentials('ssh_aws')
    }
    stages {
        stage('Build and Deploy') {
            steps {
                // Clone the repository
                git 'https://github.com/vir2ozz/certask.git'

                // Load the Terraform outputs
                script {
                    def terraformOutputs = sh(script: 'terraform output -json', returnStdout: true).trim()
                    env.TERRAFORM_OUTPUTS = terraformOutputs
                }

                // Prepare the inventory.ini file
                sh "echo '[java_builder]\n$(terraformOutput('java_builder_public_ip')) ansible_user=ubuntu\n\n[app_instance]\n$(terraformOutput('app_instance_public_ip')) ansible_user=ubuntu\n' > inventory.ini"

                // Load the SSH private key
                withCredentials([sshUserPrivateKey(credentialsId: 'dschool.pem', keyFileVariable: 'KEY_FILE')]) {
                    sh 'cp $KEY_FILE dschool.pem'
                }

                // Run the Ansible playbook
                sh 'ansible-playbook -i inventory.ini playbook.yml --private-key dschool.pem'
            }
        }
    }

    post {
        always {
            sh 'rm -f dschool.pem'
        }
    }
}
