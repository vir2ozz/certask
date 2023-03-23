pipeline {
    agent any

    stages {
        stage('Provision Infrastructure') {
            steps {
                git branch: 'master', url: 'https://github.com/vir2ozz/certask.git'
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Setup Instances') {
            steps {
                script {
                    def instance_ip1 = sh(returnStdout: true, script: 'terraform output -raw instance_1_ip').trim()
                    def instance_ip2 = sh(returnStdout: true, script: 'terraform output -raw instance_2_ip').trim()
                    writeFile file: 'inventory.ini', text: """
                    [instance_1]
                    ${instance_ip1} ansible_user=ubuntu ansible_ssh_private_key_file=ssh_aws.pem

                    [instance_2]
                    ${instance_ip2} ansible_user=ubuntu ansible_ssh_private_key_file=ssh_aws.pem
                    """
                }
                sshagent(credentials: ['ssh_aws']) {
                    sh 'scp -o StrictHostKeyChecking=no -i dschool.pem inventory.ini ubuntu@${instance_ip1}:~/inventory.ini'
                    sh 'scp -o StrictHostKeyChecking=no -i dschool.pem inventory.ini ubuntu@${instance_ip2}:~/inventory.ini'
                }
                sh 'ansible-playbook -i inventory.ini playbook.yml'
            }
        }
    }

    post {
        always {
            sh 'terraform destroy -auto-approve'
        }
    }
}
