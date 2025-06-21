#!/bin/bash
exec > >(tee -i og-node-setup.log)
exec 2>&1
cat << "EOF"
 _           _            _ _                                _   _     
| |__   __ _| |__   __ _ (_|_)   ___  _ __    _ __ ___   ___| |_| |__  
| '_ \ / _` | '_ \ / _` || | |  / _ \| '_ \  | '_ ` _ \ / _ \ __| '_ \ 
| |_) | (_| | |_) | (_| || | | | (_) | | | | | | | | | |  __/ |_| | | |
|_.__/ \__,_|_.__/ \__,_|/ |_|  \___/|_| |_| |_| |_| |_|\___|\__|_| |_|
                       |__/                                            

EOF
while true; do 
    echo ""
    echo "1.Download dependencies"
    echo "2.Build the file"
    echo "3.remove the old data of the node"
    echo "4.Paste private key/change private key"
    echo "5.Paste rpc or change rpc"
    echo "6.Starting the node"
    echo "7.verif"
    echo "8.Watch the logs"
    echo "9.Exit"
read -p "choose one of the choice  from the following for the task" choice
case $choice in
    1)
echo "🧹 Deleting old node files..."
sudo rm -rf 0g-storage-node
if [[ $EUID -ne 0 ]]; then 
    echo 'please be a root user. Run "sudo -i" to be a root user '
    exit 1
else 
    echo "📦 Downloading dependencies..."
    sudo apt install curl iptables build-essential git wget lz4 jq make cmake gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev screen ufw -y 

fi

echo "installing rustup"
curl https://sh.rustup.rs -sSf | sh -s -- -y
echo "exporting to the shell" && \
source $HOME/.cargo/env && \
export PATH="$HOME/.cargo/bin:$PATH"
echo "🔍 Verifying Rust installation..."
rust_version=$(rustc --version 2>/dev/null)
    if [[ $rust_version == *"rustc"*  ]]; then
    echo "success"
else 
    echo "installation failed"
fi
echo "installing Go"

wget https://go.dev/dl/go1.24.3.linux-amd64.tar.gz && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf go1.24.3.linux-amd64.tar.gz && \
rm go1.24.3.linux-amd64.tar.gz && \
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc && \
source ~/.bashrc 

echo "🔍 Verifying Go installation..."
go_version=$(go version)

if [[ $go_version == *"go version"* ]]; then 
echo "success"
else 
    echo "failed"
fi

echo "📁 Cloning repository..."
git clone https://github.com/0glabs/0g-storage-node.git && \

cd 0g-storage-node && \
git checkout v1.0.0 && \
git submodule update --init 

echo "🔧 Building the node..."
;;
    2)
#cargo build --release 
sudo cp /root/og-storage-node-one-command-scipt-/0g-storage-node/
echo "⚙️ Setting up configuration..."
;;
    3)
rm -rf $HOME/0g-storage-node/run/config.toml && \
curl -o $HOME/0g-storage-node/run/config.toml https://raw.githubusercontent.com/Mayankgg01/0G-Storage-Node-Guide/main/config.toml 
;;
    
    4)
read -p "Enter your private key: " user_key
sed -i "s|miner_key = \"Your_Wallet_Private_key_Without_0x\"|miner_key = \"$user_key\"|" "$HOME/0g-storage-node/run/config.toml"
echo "🔄 Do you want to update the RPC endpoint to the latest? (y/n)"

read rpc 
if [[ $rpc == "y" ]]; then 
    echo "📝 Paste your custom RPC URL:"
read -p "enter your rpc which is currently active... to check the rpc status follow the link ... choose the one with less ping i.e with less ms" user_rpc
sed -i "s|blockchain_rpc_endpoint = \"https://evmrpc-testnet.0g.ai\"|blockchain_rpc_endpoint = \"$user_rpc\"|" "$HOME/0g-storage-node/run/config.toml"
    echo "✅ RPC updated successfully."
else 
    echo "⚠️ Using default RPC: https://evmrpc-testnet.0g.ai"
    ;;
    5)
fi 
echo "creating systemd service file"
sudo tee /etc/systemd/system/zgs.service > /dev/null <<EOF
[Unit]
Description=ZGS Node
After=network.target

[Service]
User=$USER
WorkingDirectory=$HOME/0g-storage-node/run
ExecStart=$HOME/0g-storage-node/target/release/zgs_node --config $HOME/0g-storage-node/run/config.toml
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
;;
    6)
echo "🚀 Starting the node..."
sudo systemctl daemon-reload && \
sudo systemctl enable zgs && \
sudo systemctl start zgs 
;;
    7)

echo "📡 Verifying node status..."
node_status=$(sudo systemctl status zgs)
if [[ $node_status == *"active"* ]]; then 
    echo "✅ Node is running."
else 
    echo "❌ Node failed to start."
fi
;;
    8)
echo "📄 Do you want to view node logs? (y/n)"
read logs

if [[ $logs == "y" ]]; then 
    echo "📢 To follow logs in another terminal, run:"
    node_log_file="$HOME/0g-storage-node/run/log/zgs.log.$(TZ=UTC date +%Y-%m-%d)"
    full_path=$(realpath "$node_log_file")
    echo "📄 Node log file located at:"
    echo "$full_path"
    echo "👉 Run this to view logs live:"
    echo "tail -f \"$full_path\""
else
    echo "🎉 Thanks for using the script. Happy farming!"
fi
;;
    9)
     echo "🚪 Exiting now..."
        sleep 1
    
        exit 0
        ;;
    esac
done
echo "💬 If the node doesn't work, send your script logs to Telegram: @rahuljaat2502"
