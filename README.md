# Script para configurar Ubuntu Mate y VS-Code

La idea de este repositorio es configurar la apariencia del excritorio de Ubuntu Mate y la configuracion de VS-Code.

> [!WARNING]
> No cambiar el nombre de ningun archivo ni carpeta para el correcto funcionamiento
>
> Nesecita tener instalado _python3_

# Caracteristicas

Aqui un lista de las distintas acciones del programa:
 * Instala el paquete de iconos _Papirus_ y le aplica su respectivo color a las carpetas segun el tema
 * Instala un tema para GTK, un cursor y un fondo de pantalla por cada tema
 * Instala la fuente _Fira Code_ para VS-Code
 * Configura la apariencia de la terminal
 * Edita el `settings.json` de VS-Code

# Uso

Primero hay que cambiar los permisos del script

```bash
chmod +x install.sh
```
Por defecto se instala el tema _Canta_, se puede cambiar con la flag `-t`

```bash
./install.sh -t [ dracula|canta|cloudy|blood|shine ]
```

> [!NOTE]
>Se puede agregar el argumento `-s` para no volver a instalar de vuelta los recursos 
