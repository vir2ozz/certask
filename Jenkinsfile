pipeline {
  agent {
    label 'aws'
  }
  stages {
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
    stage('Run Ansible Playbook') {
      steps {
        script {
          def appInstanceIP = sh(script: 'terraform output -raw app_instance_public_ip', returnStdout: true).trim()
          def dockerInstanceIP = sh(script: 'terraform output -raw docker_instance_public_ip', returnStdout: true).trim()
          withCredentials([
            sshUserPrivateKey(credentialsId: 'ssh_aws', keyFileVariable: 'SSH_KEY')
          ]) {
            sh "ansible-playbook -i '${appInstanceIP},' -u ubuntu --private-key='${SSH_KEY}' playbook.yml --extra-vars 'app_instance=${appInstanceIP} docker_instance=${dockerInstanceIP}'"
          }
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
