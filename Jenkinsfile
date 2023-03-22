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
                def javaBuilderIp = "${env.TERRAFORM_OUTPUTS['java_builder_public_ip']['value']}"
                def appInstanceIp = "${env.TERRAFORM_OUTPUTS['app_instance_public_ip']['value']}"
                sh "echo '[java_builder]\n${javaBuilderIp} ansible_user=ubuntu\n\n[app_instance]\n${appInstanceIp} ansible_user=ubuntu\n' > inventory.ini"

                // Load the SSH private key
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh_aws', keyFileVariable: 'KEY_FILE')]) {
                    sh 'cp $KEY_FILE ssh_key.pem'
                    sh 'chmod 400 ssh_key.pem'
                }

                // Run the Ansible playbook
                sh 'ansible-playbook -i inventory.ini playbook.yml --private-key ssh_key.pem'
            }
        }
    }

    post {
        always {
            sh 'rm -f ssh_key.pem'
        }
    }
}
