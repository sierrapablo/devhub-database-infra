# Infraestructura como Codigo con Terraform

Infraestructura como codigo para levantar una base de datos Postgres con Terraform y Docker.

[![Latest Release](https://img.shields.io/github/v/release/sierrapablo/devhub-database-infra?logo=github&style=flat-square)](https://github.com/sierrapablo/devhub-database-infra/releases)

> **Desarrollo activo**: Este proyecto esta en construccion. Las funciones, modulos y la arquitectura pueden cambiar.

## Descripcion general

Este repositorio contiene la infraestructura como codigo (IaC) para aprovisionar Postgres en Docker con red y volumen dedicados.

## Estructura del repositorio

El proyecto se organiza en los siguientes directorios:

| Directorio               | Descripcion                                                                                   | Documentacion                                     |
| ------------------------ | --------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| **`terraform/`**         | Definicion principal de infraestructura, con `main` y proveedores.                             | [Ver documentacion](./docs/terraform.md)          |
| **`terraform/modules/`** | Modulos reutilizables de Terraform.                                                           | [Ver documentacion](./docs/terraform-modules.md)  |
| **`ci/`**                | Pipelines de Jenkins para gestionar el ciclo de releases y versionado (Gitflow).              | [Ver documentacion](./docs/ci.md)                 |

### Caracteristicas

- **Arquitectura modular**: Modulos de Terraform para componentes reutilizables.
- **Provision de Postgres**: Contenedor Docker con volumen persistente y red dedicada.
- **Controles de calidad automatizados**:
  - **Validacion**: Verificacion de configuracion en Pull Requests.
  - **Formateo**: `terraform fmt` para consistencia de estilo.
- **Automatizacion de releases**:
  - **Estrategia Gitflow**: Versionado, tagging y changelog con Jenkins.

## Creditos

**Pablo Sierra** - _Trabajo inicial y mantenimiento_ - [sierrapablo](https://github.com/sierrapablo)

## Licencia

Este proyecto se licencia bajo **MIT** - ver [LICENSE](./LICENSE) para mas detalles.
