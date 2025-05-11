pipeline {
    agent any

    environment {
        DEPLOY_DIR = '/var/www/jenkins-weather-app'
    }

    stages {
        stage('Setup Node') {
            steps {
                script {
                    // Install Node.js if not present
                    if (!sh(returnStatus: true, script: 'which node')) {
                        sh 'curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -'
                        sh 'sudo apt-get install -y nodejs'
                    }
                    sh 'node --version'
                    sh 'npm --version'
                }
            }
        }

        stage('Test') {
            steps {
                sh "chmod +x -R ${env.WORKSPACE}"
                sh './scripts/test.sh'
            }
        }

        stage('Build') {
            steps {
                sh 'npm install'
                sh './scripts/deliver-for-development.sh'
            }
        }

        stage('Deliver for Development') {
            when { branch 'development' }
            steps {
                sh """
                sudo rm -rf ${DEPLOY_DIR} || true
                sudo mkdir -p ${DEPLOY_DIR}
                sudo cp -r ${env.WORKSPACE}/build/* ${DEPLOY_DIR}/
                sudo chown -R www-data:www-data ${DEPLOY_DIR}
                """
            }
        }

        stage('Deploy for Production') {
            when { branch 'production' }
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input message: 'Confirm Production Deployment?'
                }
                sh './scripts/deploy-for-production.sh'
            }
        }
    }
}
