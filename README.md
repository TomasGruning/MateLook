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


```bash
USAGE
    $ ./install.sh [options] -t <theme> 

OPERATIONS
    -t --theme <theme>  specify the theme

OPTIONS
	-s --set           set the theme without re-installing the resources
    -l --list          list availables themes 
```

> [!NOTE]
> Por defecto se instala el tema _Canta_
>

# Temas
 * __Canta__
 * __Dracula__
 * __Cloudy__
 * __Blood__
 * __Shine__
 * __Ocean__
