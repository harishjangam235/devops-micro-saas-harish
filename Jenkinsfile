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
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                    sh '''
                    mvn clean verify sonar:sonar \
                    -Dsonar.projectKey=devops-micro-saas-harish \
                    -Dsonar.projectName=devops-micro-saas-harish \
                    -Dsonar.host.url=http://host.docker.internal:9000 \
                    -Dsonar.login=$SONAR_TOKEN
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:latest .'
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh 'docker tag $DOCKER_IMAGE:latest $DOCKER_IMAGE:latest'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    '''
                }
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
                docker run -d -p 8090:8080 --name micro-saas $DOCKER_IMAGE:latest
                '''
            }
        }

    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }

        failure {
            echo 'Pipeline failed!'
        }
    }
}
