#!/bin/bash
# Titulo:       Pequeño script demo
# Fecha:        06/07/18
# Autor:        Carlos de la Torre
# Versión:      0.1
# Descripción:  Se usas para mostrar la manera de programar un script en una prueba de selección de personal
# Opciones: Ninguna
# Uso: miscript.sh <usuario> <directorio>

# Función para saber si se esta utilizando root
function is_root {
  if [[ $EUID -ne 0 ]]; then
      echo
      echo " Tiene que ejecutar este script con permisos de administrador";
      echo
      exit;
  fi
}

# Función que se encarga de borrar cualquier usuario en el sistema,
# de manera básica hay parametros que se omiten.
function delete_user() {
    if [ -z "$1" ]; then
        echo "usuario vacío"
	use;
    fi
    user=$(cat /etc/passwd | grep $1)
    if [ -z "$user" ]; then
       echo
       echo "El usuario no existe"
       echo
       exit;
    fi
    if [ -z "$2" ]; then
        echo "directorio vacio"
        use;
    fi
    echo "Se procederá a eliminar un usuario del sistema"
    echo -e "Usuario:\t$1"
    echo -e "Carpeta Home:\t$2"
    read -e -p "Esta Seguro? S/N " opt
    if [[ $opt == "y" ]] || [[ $opt == "Y" ]] || [[ $opt == "s" ]] || [[ $opt == "S" ]];then
	mkdir --parents /backup/$2
	tar -czvf $1.tar.gz $(getent passwd $1 | cut -d: -f6)
	mv -f $1.tar.gz /backup/$2/
	echo "Se ha almacenado una copia de la carpeta de usuario en: /backup/$2/$1.tar.gz"
	userdel -fr $1
    fi
}

# Función para mostrar la ayuda en caso de error
# Sin parámetros de entrada
function use() {
    echo
    echo "Modo de Uso:"
    echo -e "\t./miscript.sh <usuario> <directorio> "
    exit
}
is_root;
delete_user $1 $2;
