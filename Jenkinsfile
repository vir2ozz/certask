pipeline {
    agent any

    stages {
        stage('Terraform') {
            steps {
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
                script {
                    appInstancePrivateKey = sh(script: 'terraform output -raw app_instance_private_key', returnStdout: true).trim()
                }
                withCredentials([sshUserPrivateKey(credentialsId: 'app-instance-key', keyFileVariable: 'KEY_FILE', passphraseVariable: '', usernameVariable: 'SSH_USER')]) {
                    writeFile file: "${KEY_FILE}", text: "${appInstancePrivateKey}"
                }
            }
        }
        stage('Ansible') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'app-instance-key', keyFileVariable: 'KEY_FILE', passphraseVariable: '', usernameVariable: 'SSH_USER')]) {
                    sh 'ansible-playbook -i inventory.ini playbook.yml --private-key ${KEY_FILE}'
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
