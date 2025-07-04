#!/bin/bash
cat << "EOF"

░█░█░▀█▀░█▀█░█▀▀░█░█░█░█░█░█░█░█░█░█░█▀▀░█▀▄░█░█░█░█░█▀█
░█▀▄░░█░░█░█░█░░░█▀█░█░█░█▀▄░█▄█░█░█░█▀▀░█▀▄░█░█░█▀▄░█▀█
░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀░░▀▀▀░▀░▀░▀░▀             

EOF
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
    echo "3.Download the git package"
    echo "4.Exit"

    read -p "Enter your choice (1-10): " choice

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
                exit 1
            fi 
            echo "success"
            ;;
        2)
            echo "⬇️ Downloading curl package"
            if ! command -v curl &>/dev/null; then
                echo "curl is not installed. Installing now..."
                sudo apt install curl -y || { echo "Failed to install curl"; exit 1; }
            else
                echo "curl is already installed: $(curl --version | head -n 1)"
            fi
            ;;
        3) 
            echo "⬇️ Downloading Git " 
            check_existing_git() {
                if command -v git &>/dev/null; then
                    warn "Git is already installed: $(git --version | awk '{print $3}')"
                    read -rp "Do you want to reinstall/update Git? (y/N): " choice
                    if [[ "${choice,,}" == "y" ]]; then
                        return 0
                    else
                        info "Skipping Git installation."
                        exit 0
                    fi
                fi
            }

            install_git() {
                task "Identifying package manager"
                if command -v apt &>/dev/null; then
                    info "Detected APT package manager"
                    run_with_spinner "Updating package lists" sudo apt update -y || error "Failed to update packages"
                    run_with_spinner "Installing Git" sudo apt install git -y || error "Failed to install Git"
                    
                elif command -v dnf &>/dev/null; then
                    info "Detected DNF package manager"
                    run_with_spinner "Installing Git" sudo dnf install git -y || error "Failed to install Git"
                    
                elif command -v yum &>/dev/null; then
                    info "Detected YUM package manager"
                    run_with_spinner "Installing Git" sudo yum install git -y || error "Failed to install Git"
                    
                elif command -v pacman &>/dev/null; then
                    info "Detected Pacman package manager"
                    run_with_spinner "Installing Git" sudo pacman -S git --noconfirm || error "Failed to install Git"
                    
                elif command -v zypper &>/dev/null; then
                    info "Detected Zypper package manager"
                    run_with_spinner "Installing Git" sudo zypper install git -y || error "Failed to install Git"
                    
                else
                    error "Unsupported package manager. Install Git manually."
                fi
            }

            verify_installation() {
                task "Verifying installation"
                if command -v git &>/dev/null; then
                    success "Git successfully installed: $(git --version | awk '{print $3}')"
                else
                    warn "Git binary not found in PATH. Searching system..."
                    
                    local possible_paths=(
                        "/usr/bin/git"
                        "/usr/local/bin/git"
                        "/opt/homebrew/bin/git"
                        "/snap/bin/git"
                    )
                    
                    for path in "${possible_paths[@]}"; do
                        if [[ -x "$path" ]]; then
                            warn "Found Git at: $path"
                            info "You can add this to your PATH by running:"
                            info "echo 'export PATH=\"$(dirname "$path"):\$PATH\"' >> ~/.bashrc && source ~/.bashrc"
                            return
                        fi
                    done
                    
                    error "Git installation verification failed. Check manually with 'which git'"
                fi
            }
            check_existing_git && install_git && verify_installation
            ;;
        4) 
            echo "Exiting"
            sleep 1 
            exit 0 
            ;;
        5) 
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
            ;;
        6) 
            echo "Exiting now..."
            sleep 1 
            exit 0
            ;;
        *) 
            echo "Invalid choice. Please select a number between 1 and 6."
            ;;
    esac
done