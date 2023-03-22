pipeline {
  agent any
  environment {
        AWS_CREDENTIALS = credentials('ubuntu_aws')
        SSH_CREDENTIALS = credentials('ssh_aws')
  }

  stages {
    stage('Terraform Init & Apply') {
      steps {
        sh 'terraform init'
        sh 'terraform apply -auto-approve'
      }
    }

    stage('Update Ansible Inventory') {
      steps {
        script {
          def java_builder_ip = sh(returnStdout: true, script: 'terraform output java_builder_public_ip').trim()
          def app_instance_ip = sh(returnStdout: true, script: 'terraform output app_instance_public_ip').trim()

          sh "sed -i 's/java_builder ansible_host=.*/java_builder ansible_host=${java_builder_ip}/' inventory.ini"
          sh "sed -i 's/app_instance ansible_host=.*/app_instance ansible_host=${app_instance_ip}/' inventory.ini"
        }
      }
    }

    stage('Run Ansible Playbook') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'ssh_aws', keyFileVariable: 'key_file')]) {
          sh "ansible-playbook -i inventory.ini playbook.yml --private-key ${key_file}"
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
