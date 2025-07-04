#!/bin/bash
cat << "EOF"

░█░█░▀█▀░█▀█░█▀▀░█░█░█░█░█░█░█░█░█░█░█▀▀░█▀▄░█░█░█░█░█▀█
░█▀▄░░█░░█░█░█░░░█▀█░█░█░█▀▄░█▄█░█░█░█▀▀░█▀▄░█░█░█▀▄░█▀█
░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀░░▀▀▀░▀░▀░▀░▀             

EOF
apt update && apt upgrade -y 
echo "✨ Welcome to the Auto gpu setup scipt  ✨"
set -e
trap 'echo "❌ Error on line $LINENO: $BASH_COMMAND"; exit 1' ERR

if [[ $EUID -ne 0 ]]; then 
    echo "please be in the root dir sir .Run 'sudo -i' to switch to root and rerun the script."
    exit 0
fi 

while true; do
    echo "1.Download the dependencies"
    echo "2.Download the curl package"
    echo "3.Download the other packagees"
    echo "4.Exit"

    read -p "Enter your choice (1-4): " choice

    case $choice in
        1) 
            echo "checking if sudo is installed"
            if ! command -v sudo &> /dev/null; then
                echo " sudo is not installed running as root?"
                apt install sudo -y 
                if [[ $? -ne 0 ]]; then 
                    echo "sudo installation failed " 
                    apt --fix-missing -y && apt install sudo -y
                fi 
            else 
                sudo apt-get update && sudo apt-get upgrade -y
            fi 
            echo "success"
            read -p "Press enter to continue..."
            ;;
        2)
            echo "⬇️ Downloading curl package"
            if ! command -v curl &>/dev/null; then
                echo "curl is not installed. Installing now..."
                sudo apt install curl -y || { echo "Failed to install curl"; exit 1; }
            else
                echo "curl is already installed: $(curl --version | head -n 1)"
            fi
            read -p "Press enter to continue..."
            ;;
       
        3) 
            echo "downloading other small dependencies"
            sudo apt install -y \
  build-essential \
  software-properties-common \
  curl \
  wget \
  git \
  unzip \
  ca-certificates \
  lsb-release \
  gnupg \
  apt-transport-https \
  nano \
  htop \
  net-tools \
  pciutils
            echo "✅ All dependencies installed successfully."
            read -p "Press enter to continue..."
            ;;
        4)  echo "Exiting now..."
            sleep 1 
            break
            ;;
        *) 
            echo "Invalid choice. Please select a number between 1 and 6."
            ;;
    esac
done
