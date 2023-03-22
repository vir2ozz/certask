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
                // Load the Terraform outputs
            script {
                def terraformOutputs = sh(script: 'terraform output -json', returnStdout: true).trim()
                env.TERRAFORM_OUTPUTS = readJSON text: terraformOutputs
            }

                // Prepare the inventory.ini file
                sh "echo '[java_builder]\n${env.TERRAFORM_OUTPUTS.java_builder_public_ip.value} ansible_user=ubuntu\n\n[app_instance]\n${env.TERRAFORM_OUTPUTS.app_instance_public_ip.value} ansible_user=ubuntu\n' > inventory.ini"

                // Run the Ansible playbook
                sh "ansible-playbook -i inventory.ini playbook.yml --private-key dschool.pem"


                // Run the Ansible playbook
                //sh 'ansible-playbook -i inventory.ini playbook.yml --private-key ssh_key.pem'
            }
        }
    }

    post {
        always {
            sh 'rm -f ssh_key.pem'
        }
    }
}
