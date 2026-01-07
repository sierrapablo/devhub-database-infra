pipeline {
  agent any

  parameters {
    gitParameter(
      name: 'BRANCH_NAME',
      type: 'PT_BRANCH',
      defaultValue: 'develop',
      branchFilter: 'origin/(.*)',
      description: 'Selecciona la rama para ejecutar el formateo',
      sortMode: 'DESCENDING_SMART',
      selectedValue: 'DEFAULT'
    )
  }

  environment {
    GIT_USER_NAME = 'Jenkins CI'
    GIT_USER_EMAIL = 'jenkins[bot]@noreply.jenkins.io'
  }

  stages {
    stage('Checkout') {
      steps {
        sshagent(credentials: ['github']) {
          script {
            echo "Ejecutando formateo en la rama: ${params.BRANCH_NAME}"
            sh """
              git config user.name "${env.GIT_USER_NAME}"
              git config user.email "${env.GIT_USER_EMAIL}"

              git fetch --all
              git checkout ${params.BRANCH_NAME}
              git pull
            """
          }
        }
      }
    }

    stage('Terraform Init') {
      steps {
        dir('terraform') {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Format') {
      steps {
        dir('terraform') {
          sh 'terraform fmt'
        }
      }
    }

    stage('Terraform Validate') {
      steps {
        dir('terraform') {
          sh 'terraform validate'
        }
      }
    }

    stage('Git Commit') {
      steps {
        sshagent(credentials: ['github']) {
          script {
            sh '''
              if ! git diff --quiet; then
                git add .
                git commit -m "chore: terraform format and validate"
                git push
              else
                echo "No changes detected. Skipping commit."
              fi
            '''
          }
        }
      }
    }
  }

  post {
    success {
      echo """
        ==========================================
        TERRAFORM FORMAT AND VALIDATE SUCCESSFUL
        ==========================================
        Duration: ${currentBuild.durationString}
        ==========================================
      """
    }
    failure {
      echo """
        ==========================================
        TERRAFORM FORMAT AND VALIDATE FAILED
        ==========================================
        Duration: ${currentBuild.durationString}
        ==========================================
      """
    }
    always {
      echo 'Attempting to clean up workspace...'
      cleanWs()
    }
  }
}