pipeline {
    agent any

    environment {
        REPO_URL   = "https://github.com/nataliyatraxler/my-microservice-project.git"
        IMAGE_TAG  = "build-${BUILD_NUMBER}"
        VALUES_FILE = "lesson-8-9/charts/django-app/values.yaml"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: "${env.REPO_URL}"
            }
        }

        stage('Build Docker Image (simulated)') {
            steps {
                echo "Building Docker image for Django..."
                sh """
                  echo "docker build -t django:${IMAGE_TAG} ."
                """
            }
        }

        stage('Push to ECR (simulated)') {
            steps {
                echo "Simulating push to ECR..."
                sh """
                  echo "docker tag django:${IMAGE_TAG} <ECR_REPO_URL>:${IMAGE_TAG}"
                  echo "docker push <ECR_REPO_URL>:${IMAGE_TAG}"
                """
            }
        }

        stage('Update Helm values.yaml') {
            steps {
                script {
                    sh """
                      echo "Updating image tag in \${VALUES_FILE}"
                      sed -i '' 's/^  tag:.*/  tag: "\${IMAGE_TAG}"/' "\${VALUES_FILE}"
                    """
                }
            }
        }

        stage('Commit & Push Changes') {
            steps {
                sh """
                  git config --global user.email "ci@jenkins"
                  git config --global user.name "Jenkins CI"

                  git status
                  git add "\${VALUES_FILE}" || echo "Nothing to add"

                  git commit -m "Update image tag to \${IMAGE_TAG}" || echo "Nothing to commit"

                  git push origin main || echo "Nothing to push"
                """
            }
        }
    }
}

