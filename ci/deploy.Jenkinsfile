pipeline {
  agent any

  parameters {
    gitParameter(
      name: 'TAG',
      type: 'PT_TAG',
      defaultValue: '',
      description: 'Tag to deploy',
      sortMode: 'DESCENDING_SMART',
      selectedValue: 'TOP'
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
            if (!params.TAG || params.TAG == '') {
              error "The 'TAG' parameter is mandatory. Please select a valid tag."
            }
            sh """
              git config user.name "${env.GIT_USER_NAME}"
              git config user.email "${env.GIT_USER_EMAIL}"

              git fetch --tags --force
              git checkout ${params.TAG}
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

    stage('Terraform Plan') {
      steps {
        dir('terraform') {
          sh 'terraform plan'
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        input message: "Deploy tag ${params.TAG}?", ok: 'Deploy'
        dir('terraform') {
          sh 'terraform apply -auto-approve'
        }
      }
    }
  }

  post {
    success {
      echo """
        ==========================================
        DEPLOY SUCCESSFUL
        ==========================================
        Tag: ${params.TAG}
        Duration: ${currentBuild.durationString}
        ==========================================
      """
    }
    failure {
      echo """
        ==========================================
        DEPLOY FAILED
        ==========================================
        Tag: ${params.TAG}
        Duration: ${currentBuild.durationString}
        ==========================================
      """
    }
  }
}