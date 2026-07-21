pipeline {
    agent any

    environment {
        DOCKERHUB_USER  = "anushark"
        DOCKERHUB_CREDS = credentials('dockerhub-creds')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Determine Environment') {
            steps {
                script {
                    def branch = (env.GIT_BRANCH ?: 'main').replaceFirst(/^origin\//, '')
                    env.TARGET_ENV = (branch == 'main' || branch == 'master') ? 'prod' : 'dev'
                    echo "Detected branch: ${branch} -> Target Docker Hub repo: ${DOCKERHUB_USER}/${env.TARGET_ENV}"
                }
            }
        }

        stage('Build Image') {
            steps {
                sh "docker build -t ${DOCKERHUB_USER}/${TARGET_ENV}:${BUILD_NUMBER} . && docker tag ${DOCKERHUB_USER}/${TARGET_ENV}:${BUILD_NUMBER} ${DOCKERHUB_USER}/${TARGET_ENV}:latest"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh "echo ${DOCKERHUB_CREDS_PSW} | docker login -u ${DOCKERHUB_CREDS_USR} --password-stdin && docker push ${DOCKERHUB_USER}/${TARGET_ENV}:${BUILD_NUMBER} && docker push ${DOCKERHUB_USER}/${TARGET_ENV}:latest"
            }
        }

        stage('Deploy') {
            steps {
                sh "docker stop devops-build-app || true; docker rm devops-build-app || true; docker run -d --name devops-build-app --restart unless-stopped -p 80:80 ${DOCKERHUB_USER}/${TARGET_ENV}:latest"
            }
        }
    }

    post {
        success {
            echo "Pipeline succeeded. Image pushed to ${DOCKERHUB_USER}/${env.TARGET_ENV}."
        }
        failure {
            echo "Pipeline failed (target env: ${env.TARGET_ENV})."
        }
    }
}
