pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '20'))
    }

    parameters {
        string(
            name: 'SSH_INGRESS_CIDR',
            defaultValue: '',
            description: 'CIDR allowed to reach port 22, e.g. 203.0.113.10/32. Required.'
        )
        string(
            name: 'KEY_NAME',
            defaultValue: 'dschool',
            description: 'Name of the existing EC2 key pair.'
        )
        booleanParam(
            name: 'DESTROY_AFTER',
            defaultValue: true,
            description: 'Tear the environment down when the build finishes.'
        )
    }

    environment {
        TF_IN_AUTOMATION = 'true'
        TF_INPUT         = '0'
        STATE_BUCKET     = credentials('tf-state-bucket')
        LOCK_TABLE       = credentials('tf-lock-table')
    }

    stages {

        stage('Validate parameters') {
            steps {
                script {
                    if (!params.SSH_INGRESS_CIDR?.trim()) {
                        error 'SSH_INGRESS_CIDR is required - refusing to open SSH to the world.'
                    }
                }
            }
        }

        stage('Terraform init and plan') {
            steps {
                sh '''
                    terraform init -reconfigure \
                        -backend-config="bucket=${STATE_BUCKET}" \
                        -backend-config="dynamodb_table=${LOCK_TABLE}"
                    terraform fmt -check
                    terraform validate
                    terraform plan -out=tfplan \
                        -var="ssh_ingress_cidr=${SSH_INGRESS_CIDR}" \
                        -var="key_name=${KEY_NAME}"
                '''
            }
        }

        stage('Terraform apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Generate Ansible inventory') {
            steps {
                script {
                    def tf   = readJSON text: sh(script: 'terraform output -json', returnStdout: true)
                    def user = tf.ssh_user.value

                    writeFile file: 'inventory.ini', text: """\
                        [build]
                        ${tf.build_host_public_ip.value} ansible_user=${user}

                        [stage]
                        ${tf.stage_host_public_ip.value} ansible_user=${user}
                    """.stripIndent()

                    env.APP_URL = tf.app_url.value
                    echo "Application will be published at ${env.APP_URL}"
                }
            }
        }

        stage('Wait for SSH') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh-file', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                        for host in $(awk '/^[0-9]/ {print $1}' inventory.ini); do
                            until ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 \
                                      -i "${SSH_KEY}" ubuntu@"${host}" true 2>/dev/null; do
                                echo "waiting for ${host}..."
                                sleep 5
                            done
                        done
                    '''
                }
            }
        }

        stage('Build and deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh-file', keyFileVariable: 'SSH_KEY')]) {
                    sh 'ansible-playbook -i inventory.ini playbook.yml --private-key="${SSH_KEY}"'
                }
            }
        }

        stage('Smoke test') {
            steps {
                sh 'curl --fail --silent --show-error --retry 6 --retry-delay 5 "${APP_URL}" > /dev/null'
                echo "Application is responding at ${env.APP_URL}"
            }
        }
    }

    post {
        cleanup {
            script {
                if (params.DESTROY_AFTER) {
                    sh '''
                        terraform destroy -auto-approve \
                            -var="ssh_ingress_cidr=${SSH_INGRESS_CIDR}" \
                            -var="key_name=${KEY_NAME}"
                    '''
                } else {
                    echo 'DESTROY_AFTER is false - the environment is still running and billable.'
                }
            }
        }
        always {
            archiveArtifacts artifacts: 'inventory.ini,*.war', allowEmptyArchive: true
            cleanWs()
        }
    }
}
