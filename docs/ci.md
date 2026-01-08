# Directorio CI/CD

Este directorio contiene los pipelines de Integracion Continua y Despliegue Continuo (CI/CD) del proyecto, ejecutados desde Jenkins.

## Indice

- [Pipeline de release (`release.Jenkinsfile`)](#pipeline-de-release-releasejenkinsfile)
- [Pipeline de deploy (`deploy.Jenkinsfile`)](#pipeline-de-deploy-deployjenkinsfile)
- [Pipeline de format (`format.Jenkinsfile`)](#pipeline-de-format-formatjenkinsfile)
- [Pipeline de SonarQube (`sonarqube.Jenkinsfile`)](#pipeline-de-sonarqube-sonarqubejenkinsfile)

## Pipelines

### Pipeline de release (`release.Jenkinsfile`)

Automatiza el versionado y release siguiendo una estrategia basada en Gitflow.

#### Parametros

- **`BUMP`**: Tipo de incremento de version semantica (`MAJOR`, `MINOR`, `PATCH`).

#### Pasos del flujo

1. **Leer version actual** desde `package.json`.
2. **Calcular nueva version** segun `BUMP`.
3. **Crear rama de release** desde `develop`.
4. **Actualizar `package.json`**, commitear y hacer push.
5. **Merge a `main`** con `--no-ff`.
6. **Crear tag** con la nueva version.
7. **Generar notas** a partir del historial de commits.
8. **Crear release en GitHub** via API.
9. **Sincronizar `develop`** con `main`.
10. **Limpieza** de la rama de release.

#### Requisitos

- `package.json` debe contener un campo `version` valido (`major.minor.patch`).
- Credenciales SSH en Jenkins con ID `github`.
- Token `github-repo-pat` para crear releases en GitHub.

### Pipeline de deploy (`deploy.Jenkinsfile`)

Despliega un tag concreto ejecutando Terraform y, si aplica, crea la base de datos.

#### Parametros

- **`TAG`**: Tag a desplegar (obligatorio).
- **`ENVIRONMENT`**: Entorno (`prod`, `dev`).
- **`EXTERNAL_PORT`**: Puerto externo del contenedor.
- **`INTERNAL_PORT`**: Puerto interno del contenedor.
- **`POSTGRES_USERNAME`**: Usuario de Postgres.
- **`POSTGRES_PASSWORD`**: Password de Postgres.

#### Pasos del flujo

1. **Checkout** del tag seleccionado.
2. **Validar parametros** (puertos enteros).
3. **Preparar nombre de tfplan** con timestamp.
4. **Terraform init, fmt y validate**.
5. **Terraform plan** y registro del plan si hay cambios.
6. **Terraform apply** con aprobacion manual.
7. **Asegurar base de datos** en el contenedor de Postgres.
8. **Limpieza** de artefactos de plan.

#### Requisitos

- Credenciales SSH en Jenkins con ID `github`.
- Docker disponible en el nodo de Jenkins para ejecutar `psql` via contenedor.

### Pipeline de format (`format.Jenkinsfile`)

Formatea y valida Terraform en una rama seleccionada. Si hay cambios, commitea y hace push.

#### Parametros

- **`BRANCH_NAME`**: Rama objetivo (por defecto `develop`).

#### Pasos del flujo

1. **Checkout** de la rama.
2. **Terraform init**.
3. **Terraform fmt**.
4. **Terraform validate**.
5. **Commit y push** si hay cambios.

#### Requisitos

- Credenciales SSH en Jenkins con ID `github`.

### Pipeline de SonarQube (`sonarqube.Jenkinsfile`)

Ejecuta el analisis estatico en `develop` con SonarQube.

#### Pasos del flujo

1. **Checkout** de `develop`.
2. **Detectar version** desde `package.json`.
3. **Analisis SonarQube** con `sonar-scanner`.

#### Requisitos

- Credenciales SSH en Jenkins con ID `github`.
- Configuracion de SonarQube en Jenkins (`withSonarQubeEnv('sonarqube')`).
- Herramienta `sonar-scanner` instalada en Jenkins.
