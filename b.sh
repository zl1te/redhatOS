#!/bin/bash

# Script para actualizar completamente un sistema Red Hat (RHEL) e instalar herramientas de hacking ético
# Autor: Tu Nombre
# Fecha: YYYY-MM-DD

# Verificar si el usuario tiene permisos de superusuario (root)
if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ejecutarse como root. Usa 'sudo' o inicia sesión como root."
   exit 1
fi

# Función para mostrar mensajes destacados
function mensaje() {
    echo "=================================================="
    echo "$1"
    echo "=================================================="
}

# Paso 1: Actualizar los repositorios de paquetes
mensaje "Actualizando los metadatos de los repositorios..."
dnf makecache --refresh
if [ $? -ne 0 ]; then
    echo "Error al actualizar los metadatos de los repositorios. Abortando."
    exit 1
fi

# Paso 2: Actualizar todos los paquetes instalados
mensaje "Iniciando la actualización de todos los paquetes..."
dnf update -y
if [ $? -ne 0 ]; then
    echo "Error durante la actualización de los paquetes. Abortando."
    exit 1
fi

# Paso 3: Instalar herramientas indispensables para hacking ético
mensaje "Instalando herramientas de hacking ético..."

# Herramientas básicas
dnf install -y nmap wireshark tcpdump net-tools whois traceroute bind-utils

# Frameworks y herramientas avanzadas
dnf install -y metasploit-framework john hashcat hydra nikto sqlmap aircrack-ng

# Herramientas de desarrollo y scripting
dnf install -y python3 python3-pip git curl wget

# Instalar dependencias adicionales para algunas herramientas
pip3 install --upgrade pip
pip3 install requests paramiko scapy

# Paso 4: Limpiar cachés y archivos temporales
mensaje "Limpiando cachés y archivos temporales..."
dnf clean all
if [ $? -ne 0 ]; then
    echo "Error al limpiar las cachés. Continuando sin detenerse."
fi

# Paso 5: Verificar si hay paquetes obsoletos o huérfanos
mensaje "Buscando paquetes obsoletos o huérfanos..."
package-cleanup --orphans
if [ $? -ne 0 ]; then
    echo "Error al buscar paquetes obsoletos. Continuando sin detenerse."
fi

# Paso 6: Reiniciar servicios afectados por las actualizaciones
mensaje "Reiniciando servicios afectados por las actualizaciones..."
needs-restarting -r
if [ $? -eq 1 ]; then
    echo "Se recomienda reiniciar el sistema para aplicar cambios críticos."
else
    echo "No es necesario reiniciar el sistema en este momento."
fi

# Paso 7: Mostrar el estado final del sistema
mensaje "Estado final del sistema después de la actualización:"
uname -r
dnf list updates

echo "Proceso de actualización e instalación completado."
