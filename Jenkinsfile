pipeline {
  agent { label 'aws' }

  stages {
    stage('Terraform Init & Apply') {
      steps {
        sh 'terraform init'
        sh 'terraform apply -auto-approve'
      }
    }

    stage('Configure Ansible') {
      steps {
        sh 'echo "[instance1]\n$(terraform output -raw instance1_public_ip) ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/dschool.pem\n\n[instance2]\n$(terraform output -raw instance2_public_ip) ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/dschool.pem" > inventory.ini'
      }
    }

    stage('Run Ansible Playbook') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'dschool_pem', keyFileVariable: 'SSH_KEY_FILE', usernameVariable: 'SSH_USERNAME')]) {
          sh 'ansible-playbook -i inventory.ini playbook.yml --user=${SSH_USERNAME} --private-key=/home/ubuntu/dschool.pem'
}
        }
      }
    }

    stage('Destroy Terraform Infrastructure') {
      steps {
        sh 'terraform destroy -auto-approve'
      }
    }
  }
}
