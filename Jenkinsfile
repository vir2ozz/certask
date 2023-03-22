pipeline {
  agent any

  stages {
    stage('Checkout code') {
      steps {
        git url: 'https://github.com/vir2ozz/certask.git'
      }
    }

    stage('Terraform Init') {
      steps {
        sh 'terraform init'
      }
    }

    stage('Terraform Apply') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }

    stage('Build Java App') {
      steps {
        sh 'mvn clean install'
      }
    }

    stage('Update Ansible Inventory') {
      steps {
        script {
          def app_instance_ip = sh(returnStdout: true, script: 'terraform output -raw app_instance_ip')
          writeFile file: 'inventory', text: "app_instance ansible_host=${app_instance_ip} ansible_user=ubuntu ansible_ssh_private_key_file=ssh_aws.pem"
        }
      }
    }

    stage('Deploy Java App') {
      steps {
        withCredentials([
          sshUserPrivateKey(
            keyFileVariable: 'SSH_PRIVATE_KEY',
            passphraseVariable: '',
            usernameVariable: 'USERNAME',
            credentialsId: 'ssh_aws'
          )
        ]) {
          writeFile file: 'ssh_aws.pem', text: SSH_PRIVATE_KEY
          sh 'chmod 600 ssh_aws.pem'
          sh 'ansible-playbook playbook.yml -i inventory'
        }
      }
    }
  }
}
