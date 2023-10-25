#!/bin/bash
chmod +x "$0"

msg() {
	printf "\n%s: %b\n" "$0" "$*"
}
err() {
	msg "Error:" "$*" >&2
}

usage() {
	printf '\n'
  cat <<- EOF
	USAGE
	  $ $0 [options]
  $ $0 [options] -t <theme> 

	OPERATIONS
	  -t --theme <theme>  specify the theme

	OPTIONS
	  -h --help          show this page
  -s --set           set the theme without re-installing the resources
  -l --list          list availables themes 
	EOF
  printf '\n'

	exit "${1:-0}"
}

list_themes() {
  local -a themes=("canta" "dracula" "cloudy" "blood" "shine" "ocean")
  
  printf '\n'
  for theme in "${themes[@]}"; do
		printf ' %s\n' "$theme"
	done
  printf '\n'

  exit 0
}

is_valid_theme() {
  local -a themes=("canta" "dracula" "cloudy" "blood" "shine" "ocean")
  local theme="$1"
  
  for i in "${themes[@]}"; do
		[ "$i" == "$theme" ] || continue
		return 0
	done

  return 1
}

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

  echo -e " Extensiones instaladas\n\n"
}

theme=canta
set=0
list=0
args=()

for arg; do
	case "$arg" in
		--help)           args+=( -h ) ;;
		--list)           args+=( -l ) ;;
		--theme)          args+=( -t ) ;;
    --set)          args+=( -s ) ;;
		--[0-9a-zA-Z]*)
			err "illegal option -- '$arg'"
			usage 2
			;;
		*) args+=("$arg")
	esac
done

set -- "${args[@]}"  

while getopts ":slht:" option; do
  case $option in
  t)
    theme="$OPTARG"
    ;;
  l|--list)
    list_themes
    ;;
  s)
    set=1
    ;;
  h ) 
    usage 0 
    ;;
	: ) 
    err "option requires an argument -- '-$OPTARG'"
		usage 2
		;;
	\?) 
    err "illegal option -- '-$OPTARG'"
		usage 2
		;;
  esac
done
shift $((OPTIND - 1))

# Verifica que se haya proporcionado un argumento válido
is_valid_theme "$theme" || {
  msg "'$theme' not found. Using default 'canta'"
}

# Asigna valores según la opción seleccionada
if [ "$theme" == "dracula" ]; then
  library="Dracula"
  gtk="Dracula-alt-style"
  icons_color="indigo"
  cursor="Dracula-cursors"
  new_color_theme="Monokai +Purple"

elif [ "$theme" == "cloudy" ]; then
  library="Cloudy"
  gtk="Cloudy-Solid-Grey-Dark"
  icons_color="grey"
  cursor="capitaine-cursors-light-r3"
  new_color_theme="Monokai +Graphite"

elif [ "$theme" == "blood" ]; then
  library="Vimix"
  gtk="vimix-dark-ruby"
  icons_color="red"
  cursor="oreo_spark_red_cursors"
  new_color_theme="Monokai +Red"

elif [ "$theme" == "ocean" ]; then
  library="Fluent"
  gtk="Fluent-round-Dark"
  icons_color="blue"
  cursor="oreo_spark_blue_cursors"
  new_color_theme="Monokai +Blue"

elif [ "$theme" == "shine" ]; then
  library="Orchis"
  gtk="Orchis-Yellow-Dark"
  icons_color="yellow"
  cursor="oreo_spark_lime_cursors"
  new_color_theme="Monokai +Yellow"

else
  library="Canta"
  gtk="Canta-dark"
  icons_color="green"
  cursor="oreo_spark_green_cursors"
  new_color_theme="Monokai +Green"

fi

# ELimina basura
rm -f ~/Descargas/Mars.jar

# Resto del script (código para configurar temas, íconos, fondos, etc.)

# Instala el paquete de iconos
if [ $set == 0 ]; then
  wget -qO- https://git.io/papirus-icon-theme-install | DESTDIR="$HOME/.icons" sh
  wget -qO- https://git.io/papirus-folders-install | env PREFIX=$HOME/.local sh
fi
bash /home/estudiantes/.local/bin/papirus-folders -u -C "$icons_color"

cp -R "$(dirname "$0")/$library/$gtk" ~/.themes
cp -R "$(dirname "$0")/$library/$cursor" ~/.icons

if [ $set == 0 ]; then
  instalar_fira_code
fi

# Aplica el tema
gsettings set org.mate.interface gtk-theme "$gtk"
gsettings set org.mate.Marco.general theme "$gtk"
gsettings set org.mate.interface icon-theme "Papirus-Dark"
sed -i "s|^Icon=.*|Icon=/home/estudiantes/.icons/Papirus-Dark/128x128/places/folder-backup.svg|" /home/estudiantes/Escritorio/DATOS.desktop
gsettings set org.mate.peripherals-mouse cursor-theme "$cursor"
mate-panel --replace &

# Aplica el fondo de pantalla
cp "$(dirname "$0")/$library/$library.png" ~/Imágenes
gsettings set org.mate.background picture-filename ~/Imágenes/"$library".png

if [ $set == 0 ]; then
  # Configura la terminal
  dconf write /org/mate/terminal/profiles/default/use-custom-default-size 'true'
  dconf write /org/mate/terminal/profiles/default/default-size-columns 106
  dconf write /org/mate/terminal/profiles/default/default-size-rows 29
  dconf write /org/mate/terminal/profiles/default/cursor-shape "'ibeam'"
  dconf write /org/mate/terminal/profiles/default/scrollbar-position "'hidden'"
  echo -e "\n Terminal Configurada\n"

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
