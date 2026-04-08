pipeline {
    agent any

    tools {
        maven 'Maven'
    }

    environment {
        DOCKER_IMAGE = "harishj235/devops-micro-saas-harish"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git 'https://github.com/harishjangam235/devops-micro-saas-harish.git'
            }
        }

        stage('Build Application') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devops-micro-saas-harish .'
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh 'docker tag devops-micro-saas-harish $DOCKER_IMAGE:latest'
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push $DOCKER_IMAGE:latest'
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop micro-saas || true
                docker rm micro-saas || true
                docker run -d -p 8082:8080 --name micro-saas $DOCKER_IMAGE:latest
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check logs.'
        }
    }
}
