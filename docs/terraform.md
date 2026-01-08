# Infraestructura Terraform

Este directorio contiene la configuracion principal de Terraform. Actua como modulo raiz que orquesta la red Docker, el volumen persistente y el contenedor de Postgres.

## Indice

- [Arquitectura](#arquitectura)
- [Modulos](#modulos)
- [Requisitos](#requisitos)
- [Uso](#uso)

## Arquitectura

La infraestructura se define en el directorio `terraform/`:

- `main.tf`: Configuracion principal e instancias de modulos.
- `outputs.tf`: Outputs del modulo raiz.
- `variables.tf`: Variables de configuracion.
- `versions.tf`: Version de Terraform y proveedores.
- `providers.tf`: Configuracion de proveedores.
- `modules/`: Modulos reutilizables.

## Modulos

Los siguientes modulos se instancian desde `main.tf`:

### Network

- **Source**: `./modules/network`
- **Proposito**: Red Docker dedicada para la base de datos.
- **Configuracion**:
  - `name`: Nombre de la red.
  - `driver`: Driver de red (por defecto `bridge`).
  - `external`: Si la red es externa (no gestionada por Terraform).

### Volume

- **Source**: `./modules/volume`
- **Proposito**: Volumen persistente para los datos de Postgres.
- **Configuracion**:
  - `name`: Nombre del volumen.
  - `driver`: Driver de volumen (por defecto `local`).

### Postgres

- **Source**: `./modules/postgres`
- **Proposito**: Contenedor Docker de Postgres con red y volumen.
- **Configuracion**:
  - `name`: Nombre del contenedor.
  - `image`: Imagen de Postgres.
  - `network_name`: Red a la que se conecta.
  - `volume_name`: Volumen de datos.
  - `internal_port`: Puerto interno.
  - `external_port`: Puerto expuesto.
  - `database_name`: Nombre de la base de datos.
  - `username`: Usuario de Postgres.
  - `password`: Password de Postgres.

## Requisitos

[Terraform](https://www.terraform.io/downloads.html) instalado (version definida en `versions.tf`).

## Uso

1. **Inicializar**: Descarga proveedores y modulos.

   ```bash
   terraform init
   ```

2. **Planificar**: Vista previa de cambios.

   ```bash
   terraform plan
   ```

3. **Aplicar**: Crear/actualizar recursos.

   ```bash
   terraform apply
   ```
