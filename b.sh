#!/bin/bash

# Script para actualizar completamente un sistema e instalar herramientas de hacking ético sin EPEL
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

# Función para registrar errores
function log_error() {
    echo "ERROR: $1"
}

# Paso 1: Actualizar los repositorios de paquetes
mensaje "Actualizando los metadatos de los repositorios..."
dnf makecache --refresh
if [ $? -ne 0 ]; then
    log_error "Error al actualizar los metadatos de los repositorios."
    exit 1
fi

# Paso 2: Actualizar todos los paquetes instalados
mensaje "Iniciando la actualización de todos los paquetes..."
dnf update -y
if [ $? -ne 0 ]; then
    log_error "Error durante la actualización de los paquetes."
    exit 1
fi

# Paso 3: Instalar herramientas indispensables para hacking ético
mensaje "Instalando herramientas de hacking ético..."

# Herramientas básicas disponibles en los repositorios base
dnf install -y nmap wireshark tcpdump net-tools whois traceroute bind-utils python3 python3-pip git curl wget

# Instalar sqlmap manualmente desde GitHub
if ! command -v sqlmap &>/dev/null; then
    mensaje "Instalando sqlmap desde GitHub..."
    git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git /opt/sqlmap
    if [ $? -ne 0 ]; then
        log_error "Error al clonar el repositorio de sqlmap."
    else
        ln -s /opt/sqlmap/sqlmap.py /usr/local/bin/sqlmap
        mensaje "sqlmap instalado correctamente."
    fi
fi

# Instalar Metasploit Framework manualmente
if ! command -v msfconsole &>/dev/null; then
    mensaje "Instalando Metasploit Framework..."
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
    chmod +x msfinstall && \
    ./msfinstall
    if [ $? -ne 0 ]; then
        log_error "Error al instalar Metasploit Framework."
    else
        mensaje "Metasploit Framework instalado correctamente."
    fi
fi

# Instalar herramientas adicionales disponibles en los repositorios base
dnf install -y john hashcat hydra nikto aircrack-ng

# Instalar dependencias adicionales para algunas herramientas
pip3 install --upgrade pip
pip3 install requests paramiko scapy

# Paso 4: Limpiar cachés y archivos temporales
mensaje "Limpiando cachés y archivos temporales..."
dnf clean all
if [ $? -ne 0 ]; then
    log_error "Error al limpiar las cachés."
fi

# Paso 5: Verificar si hay paquetes obsoletos o huérfanos
mensaje "Buscando paquetes obsoletos o huérfanos..."
package-cleanup --orphans
if [ $? -ne 0 ]; then
    log_error "Error al buscar paquetes obsoletos."
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
