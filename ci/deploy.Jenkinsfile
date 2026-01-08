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

    choice(name: 'ENVIRONMENT', choices: ['prod', 'dev'], description: 'Qué entorno desplegar.')
    string(name: 'EXTERNAL_PORT', default: '', description: 'Puerto externo del contenedor.')
    string(name: 'INTERNAL_PORT', default: '', description: 'Puerto interno del contenedor.')
  }

  environment {
    GIT_USER_NAME = 'Jenkins CI'
    GIT_USER_EMAIL = 'jenkins[bot]@noreply.jenkins.io'

    TF_VAR_environment = "${params.ENVIRONMENT}"
    TF_VAR_postgres_external_port = "${params.EXTERNAL_PORT}"
    TF_VAR_postgres_internal_port = "${params.INTERNAL_PORT}"
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

    stage('Validate Terraform Params') {
      steps {
        script {
          if (!params.EXTERNAL_PORT?.isInteger() || !params.INTERNAL_PORT?.isInteger()) {
            error "Ports must be integers. EXTERNAL_PORT=${params.EXTERNAL_PORT}, INTERNAL_PORT=${params.INTERNAL_PORT}"
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

    stage('Terraform Validate'){
      steps {
        dir('terraform') {
          sh '''
            terraform fmt -check
            terraform validate
          '''
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir('terraform') {
          sh 'terraform plan -out=tfplan'
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        input message: "Deploy tag ${params.TAG}?", ok: 'Deploy'
        dir('terraform') {
          sh 'terraform apply -auto-approve tfplan'
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