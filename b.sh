#!/bin/bash

# Script para instalar herramientas de hacking ético usando Flatpak
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

# Paso 1: Instalar Flatpak si no está instalado
mensaje "Verificando e instalando Flatpak..."
if ! command -v flatpak &>/dev/null; then
    dnf install -y flatpak
    if [ $? -ne 0 ]; then
        log_error "No se pudo instalar Flatpak."
        exit 1
    fi
    mensaje "Flatpak instalado correctamente."
fi

# Paso 2: Agregar el repositorio Flathub
mensaje "Agregando el repositorio Flathub..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
if [ $? -ne 0 ]; then
    log_error "No se pudo agregar el repositorio Flathub."
    exit 1
fi

# Paso 3: Instalar herramientas de hacking ético desde Flathub
mensaje "Instalando herramientas de hacking ético desde Flathub..."

# Lista de herramientas disponibles en Flathub
TOOLS=(
    "org.nmap.Zenmap"          # Nmap GUI
    "org.wireshark.Wireshark"  # Wireshark
    "com.github.scrapy.Scrapy" # Scrapy
    "org.sqlmap.Sqlmap"        # Sqlmap
    "org.metasploit.Metasploit" # Metasploit Framework
    "org.hydra.Hydra"          # Hydra
    "org.aircrack.AircrackNg"  # Aircrack-ng
    "org.hashcat.Hashcat"      # Hashcat
    "org.nikto.Nikto"          # Nikto
    "org.burpsuite.BurpSuite"  # Burp Suite
    "org.john.John"            # John the Ripper
    "org.wfuzz.Wfuzz"          # Wfuzz
    "org.dirb.Dirb"            # Dirb
    "org.gobuster.Gobuster"    # Gobuster
    "org.sublist3r.Sublist3r"  # Sublist3r
    "org.commix.Commix"        # Commix
    "org.skipfish.Skipfish"    # Skipfish
    "org.whatweb.WhatWeb"      # WhatWeb
    "org.arachni.Arachni"      # Arachni
    "org.openvas.OpenVAS"      # OpenVAS
    "org.snort.Snort"          # Snort
    "org.ossec.Ossec"          # OSSEC
    "org.fail2ban.Fail2Ban"    # Fail2Ban
    "org.httrack.Httrack"      # HTTrack
    "org.rkhunter.Rkhunter"    # Rkhunter
    "org.clamav.ClamAV"        # ClamAV
    "org.sshguard.Sshguard"    # Sshguard
    "org.modsecurity.ModSecurity" # ModSecurity
    "org.kali.KaliTools"       # Kali Tools (colección completa)
)

# Instalar cada herramienta
for tool in "${TOOLS[@]}"; do
    mensaje "Instalando $tool..."
    flatpak install -y flathub "$tool"
    if [ $? -ne 0 ]; then
        log_error "Error al instalar $tool."
    else
        mensaje "$tool instalado correctamente."
    fi
done

# Paso 4: Limpiar cachés y archivos temporales
mensaje "Limpiando cachés y archivos temporales..."
flatpak repair
if [ $? -ne 0 ]; then
    log_error "Error al limpiar las cachés de Flatpak."
fi

# Paso 5: Mostrar el estado final del sistema
mensaje "Estado final del sistema después de la instalación:"
flatpak list

echo "Proceso de instalación completado."
