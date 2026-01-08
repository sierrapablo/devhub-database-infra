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
    string(name: 'EXTERNAL_PORT', defaultValue: '5432', description: 'Puerto externo del contenedor.')
    string(name: 'INTERNAL_PORT', defaultValue: '5432', description: 'Puerto interno del contenedor.')
    string(name: 'POSTGRES_USERNAME', defaultValue: 'postgres', description: 'Usuario por defecto de la base de datos.')
    string(name: 'POSTGRES_PASSWORD', defaultValue: 'postgres', description: 'Contraseña del usuario por defecto de la base de datos.')
  }

  environment {
    GIT_USER_NAME = 'Jenkins CI'
    GIT_USER_EMAIL = 'jenkins[bot]@noreply.jenkins.io'

    TF_VAR_environment = "${params.ENVIRONMENT}"
    TF_VAR_postgres_external_port = "${params.EXTERNAL_PORT}"
    TF_VAR_postgres_internal_port = "${params.INTERNAL_PORT}"
    TF_VAR_postgres_username = "${params.POSTGRES_USERNAME}"
    TF_VAR_postgres_password = "${params.POSTGRES_PASSWORD}"
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

    stage('Prepare Terraform Plan Name') {
      steps {
        script {
          env.TF_HAS_CHANGES = "false"
          env.TFPLAN_TS = sh(script: 'date +%Y%m%d%H%M', returnStdout: true).trim()
          def raw = "tfplan.${params.TAG}-${params.ENVIRONMENT}-${env.TFPLAN_TS}"
          env.TFPLAN_NAME = raw.replaceAll('[^A-Za-z0-9._-]', '_')
        }
      }
    }

    stage('Terraform Init') {
      steps {
        dir('terraform') {
          sh 'terraform init -input=false'
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
          script {
            def code = sh(script: "terraform plan -input=false -detailed-exitcode -out=${env.TFPLAN_NAME}", returnStatus: true)
            if (code == 0) {
              env.TF_HAS_CHANGES = "false"
              echo "No changes detected."
            } else if (code == 2) {
              env.TF_HAS_CHANGES = "true"
              echo "Changes detected."
            } else {
              error "terraform plan failed"
            }
          }
        }
      }
    }

    stage('Register tfplan') {
      when { expression { return env.TF_HAS_CHANGES == "true" } }
      steps {
        dir('terraform') {
          sh """
            set -e
            if command -v sha256sum >/dev/null 2>&1; then
              sha256sum '${env.TFPLAN_NAME}' > '${env.TFPLAN_NAME}.sha256'
            else
              shasum -a 256 '${env.TFPLAN_NAME}' > '${env.TFPLAN_NAME}.sha256'
            fi

            printf '%s\n' \
              "tag=${params.TAG}" \
              "environment=${params.ENVIRONMENT}" \
              "tfplan=${env.TFPLAN_NAME}" \
              "build_url=${env.BUILD_URL}" \
              "build_number=${env.BUILD_NUMBER}" \
              "timestamp=${env.TFPLAN_TS}" \
              > '${env.TFPLAN_NAME}.meta'
          """
          archiveArtifacts artifacts: "${env.TFPLAN_NAME},${env.TFPLAN_NAME}.sha256,${env.TFPLAN_NAME}.meta", fingerprint: true
        }
      }
    }

    stage('Terraform Apply') {
      when { expression { return env.TF_HAS_CHANGES == "true" } }
      steps {
        input message: "Deploy tag ${params.TAG}?", ok: 'Deploy'
        dir('terraform') {
          sh "terraform apply -input=false -auto-approve ${env.TFPLAN_NAME}"
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
        Environment: ${params.ENVIRONMENT}
        Terraform plan: ${env.TFPLAN_NAME ?: 'N/A'}
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
        Environment: ${params.ENVIRONMENT}
        Failed at stage: ${env.STAGE_NAME}
        Terraform plan: ${env.TFPLAN_NAME ?: 'N/A'}
        Duration: ${currentBuild.durationString}
        ==========================================
      """
    }
    always {
      dir('terraform') {
        sh '''
          echo "Attempting to clean tfplan..."
          [ -n "$TFPLAN_NAME" ] && rm -f "$TFPLAN_NAME" "$TFPLAN_NAME".sha256 "$TFPLAN_NAME".meta || true
          rm -f tfplan tfplan.* || true
        '''
      }
    }
  }
}