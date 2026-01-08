# Modulos de Terraform

Los modulos de Terraform son paquetes autocontenidos de configuracion que se gestionan como una unidad. En este repositorio se usan para separar la red, el volumen y el contenedor de Postgres.

Puedes encontrar mas informacion en la [documentacion oficial de Terraform](https://www.terraform.io/language/modules).

## Uso

1. Crea un nuevo modulo en el directorio `terraform/modules`.
2. Anade el modulo en `terraform/main.tf`.
3. Declara las variables en `terraform/variables.tf` y, si aplica, en `terraform/locals.tf`.

## Modulos disponibles

### Network

- **Ruta**: `terraform/modules/network`
- **Descripcion**: Crea o referencia una red Docker para la base de datos.

### Volume

- **Ruta**: `terraform/modules/volume`
- **Descripcion**: Crea un volumen Docker para los datos de Postgres.

### Postgres

- **Ruta**: `terraform/modules/postgres`
- **Descripcion**: Despliega un contenedor Docker de Postgres con red y volumen.
