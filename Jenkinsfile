pipeline {
    agent { 
        node {
            label 'docker-agent-ansible'
            }
      }
    triggers {
        pollSCM '* * * * *'
    }
    environment {
        ANSIBLE_VAULT = ''
    }
    stages {
        stage('Get Credentials') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'ansible-vault', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    // Access credentials as environment variables
                    // sh 'echo "Username: $USERNAME Password: $PASSWORD"'
                    
                    // // Save credentials in a variable
                    // script {
                    //     env.ANSIBLE_VAULT = "${PASSWORD}"
                    // }
                    sh '''
                    cd mySetupRoles
                    touch ./.vaultpass
                    chown jenkins:jenkins ./.vaultpass
                    chmod 640 ./.vaultpass
                    echo "${PASSWORD}" > ./.vaultpass
                    '''
                }
            }
        }
        stage('Ansible | Provision') {
            steps {
                echo "Starting Provision..."
                sh '''
                pwd
                cd mySetupRoles
                pwd
                which ansible-playbook
                mkdir -p /home/jenkins/log
                echo "" > /home/jenkins/log/ansible.log
                /usr/bin/ansible-playbook --vault-id ./.vaultpass ./run-provisions.yml
                '''
            }
        }
        stage('SSH') {
            steps {
                // SSH into remote system and execute script
                withCredentials([sshUserPrivateKey(credentialsId: 'private-key-ctrl', keyFileVariable: 'SSH_KEY', passphraseVariable: '', usernameVariable: 'SSH_USER')]) {
                    script {
                        // sshScript remote: 'ibrahim@192.168.14.254', 
                        //           user: "${SSH_USER}", 
                        //           keyFile: "${SSH_KEY}", 
                        //           script: "cd /home/ibrahim/sandbox/ansible-for-devops/mySetupRoles && ./run.sh"
                        bash "ssh -i ${SSH_KEY} ${SSH_USER}@192.168.14.254 '/home/ibrahim/sandbox/ansible-for-devops/mySetupRoles/run.sh'"
                    }
                }
            }
        }
            
        stage('Test') {
            steps {
                echo "Testing.."
                sh '''
                #cd myapp
                #python3 hello.py
                #python3 hello.py --name=Brad
                '''
            }
        }
        stage('Deliver') {
            steps {
                echo 'Deliver....'
                sh '''
                echo "doing delivery stuff.."
                '''
            }
        }
    }
}