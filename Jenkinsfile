pipeline {
    agent any
    stages {
        stage('Terraform init & apply') {
            steps {
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Prepare Ansible inventory') {
            steps {
                script {
                    def instance1_ip = sh(script: "terraform output -raw instance1_ip", returnStdout: true).trim()
                    def instance2_ip = sh(script: "terraform output -raw instance2_ip", returnStdout: true).trim()
                    def inventoryContent = """
                        [instance1]
                        ${instance1_ip}

                        [instance2]
                        ${instance2_ip}
                    """
                    writeFile file: 'inventory.ini', text: inventoryContent
                }
            }
        }
        stage('Run Ansible playbook') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh-file', keyFileVariable: 'SSH_KEY')]) {
                    sh 'ansible-playbook -i inventory.ini playbook.yml --private-key=${SSH_KEY} -u ubuntu'
                }
            }
        }
    }
    post {
        always {
            sh 'terraform destroy -auto-approve'
        }
    }
}
