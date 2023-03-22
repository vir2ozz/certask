pipeline {
  agent {
    label 'aws'
  }

  stages {
    stage('Build') {
      steps {
        git branch: 'master', url: 'https://github.com/vir2ozz/certask.git'
        sh 'mvn clean package'
      }
    }
    stage('Deploy to AWS') {
      environment {
        TF_WORKSPACE = "dev"
      }
      steps {
        withAWS(region: 'us-east-1', credentials: 'devops') {
          sh 'terraform init'
          sh 'terraform apply -auto-approve'
        }
      }
    }
    stage('Deploy to Docker') {
      environment {
        ANSIBLE_CONFIG = '.'
      }
      steps {
        withCredentials([string(credentialsId: 'ansible-ssh-key', variable: 'ansible_ssh_private_key_file')]) {
          ansiblePlaybook(
            playbook: 'deploy-to-docker.yml',
            inventory: 'hosts.ini',
            extras: "-e 'env=dev'"
          )
        }
      }
    }
  }
}
