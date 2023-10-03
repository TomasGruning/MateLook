#!/bin/bash
chmod +x "$0"

# Verifica que se haya proporcionado un argumento válido
if [ "$#" -ne 1 ] || ([ "$1" != "canta" ] && [ "$1" != "dracula" ] && [ "$1" != "cloudy" ]); then
  echo -e "\nUso: $0 [canta|dracula|cloudy]\n"
  exit 1
fi

set=false

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -s)
      set=true
      ;;
    *)
      ;;
  esac
  shift
done

# Función para descargar e instalar la fuente Fira Code
instalar_fira_code() {
  local fira_code_url="https://github.com/tonsky/FiraCode/releases/download/5.2/Fira_Code_v5.2.zip"
  local fira_code_zip="Fira_Code.zip"

  # Descarga el archivo ZIP de Fira Code
  wget -O "$fira_code_zip" "$fira_code_url"

  # Descomprime el archivo ZIP y mueve la fuente a la ubicación correcta
  unzip -o "$fira_code_zip" -d ~/.fonts

  rm "$fira_code_zip"

  # Actualiza la cache de fuentes
  fc-cache -f -v
  echo -e "\n Fuente instalada\n"
}

instalar_extensiones_vscode() {
  local extensions=("PKief.material-icon-theme" "tw.monokai-accent" "usernamehw.errorlens"
                    "DEVSENSE.phptools-vscode" "ecmel.vscode-html-css" "formulahendry.auto-close-tag"
                    "formulahendry.auto-rename-tag" "ritwickdey.LiveServer" "justusadam.language-haskell")

  for extension in "${extensions[@]}"; do
    code --install-extension "$extension"
    echo -e "\n"
  done

  echo -e " \nExtensiones instaladas\n"
}

# Asigna valores según la opción seleccionada
if [ "$1" == "canta" ]; then
  library="Canta"
  gtk="Canta-dark"
  icons_color="green"
  cursor="oreo-spark-green-cursors"
  new_color_theme="Monokai +Green"

elif [ "$1" == "dracula" ]; then
  library="Dracula"
  gtk="Dracula-alt-style"
  icons_color="indigo"
  cursor="Dracula-cursors"
  new_color_theme="Monokai +Purple"
  
elif [ "$1" == "cloudy" ]; then
  library="Cloudy"
  icons_color="grey"
  gtk="Cloudy-Solid-Grey-Dark"
  cursor="capitaine-cursors-light-r3"
  new_color_theme="Monokai +Graphite"

fi

# ELimina basura
rm -f ~/Descargas/Mars.jar


# Resto del script (código para configurar temas, íconos, fondos, etc.)

# Instala el paquete de iconos
if ["$set" = false]; then
  wget -qO- https://git.io/papirus-icon-theme-install | DESTDIR="$HOME/.icons" sh
  wget -qO- https://git.io/papirus-folders-install | env PREFIX=$HOME/.local sh
fi
bash /home/estudiantes/.local/bin/papirus-folders -C "$icons_color"

cp "$(dirname "$0")/$library/$gtk" ~/.themes
cp "$(dirname "$0")/$library/$cursor" ~/.icons

if ["$set" = false]; then
  instalar_fira_code
fi

# Aplica el tema
gsettings set org.mate.interface gtk-theme "$gtk"
gsettings set org.mate.Marco.general theme "$gtk"
gsettings set org.mate.interface icon-theme "Papirus-Dark"
sed -i "s|^Icon=.*|Icon=/home/estudiantes/.icons/Papirus-Dark/128x128/places/folder-backup.svg|" /home/estudiantes/Escritorio/DATOS.desktop
gsettings set org.mate.peripherals-mouse cursor-theme "$cursor"

# Aplica el fondo de pantalla
cp "$(dirname "$0")/$library/$library.png" ~/Imágenes
gsettings set org.mate.background picture-filename ~/Imágenes/"$library".png

# Configura la terminal
dconf write /org/mate/terminal/profiles/default/use-custom-default-size 'true'
dconf write /org/mate/terminal/profiles/default/default-size-columns 106
dconf write /org/mate/terminal/profiles/default/default-size-rows 29
dconf write /org/mate/terminal/profiles/default/cursor-shape "'ibeam'"
dconf write /org/mate/terminal/profiles/default/scrollbar-position "'hidden'"
echo -e " Terminal Configurada\n\n"

if ["$set" = false]; then
  instalar_extensiones_vscode
fi

# Aplica las configuraciones de VS_Code
cp "$(dirname "$0")/settings.json" ~/.config/Code/User

# Modificar el archivo JSON usando Python
archivo_json="$HOME/.config/Code/User/settings.json"

python3 - <<END
import json

# Ruta del archivo JSON
archivo_json = "$archivo_json"

# Nuevo valor que quieres establecer
new_color_theme = "$new_color_theme"

# Leer el archivo JSON
with open(archivo_json, 'r') as f:
    data = json.load(f)

# Modificar el valor del tema de color
data['workbench.colorTheme'] = new_color_theme

# Escribir el archivo JSON modificado
with open(archivo_json, 'w') as f:
    json.dump(data, f, indent=4)
END
