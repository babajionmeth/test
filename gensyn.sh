#!/bin/bash
cat << "EOF"
 _           _            _ _                                _   _     
| |__   __ _| |__   __ _ (_|_)   ___  _ __    _ __ ___   ___| |_| |__  
| '_ \ / _` | '_ \ / _` || | |  / _ \| '_ \  | '_ ` _ \ / _ \ __| '_ \ 
| |_) | (_| | |_) | (_| || | | | (_) | | | | | | | | | |  __/ |_| | | |
|_.__/ \__,_|_.__/ \__,_|/ |_|  \___/|_| |_| |_| |_| |_|\___|\__|_| |_|
                       |__/                                            

EOF
echo "✨ Welcome to the Gensyn Setup Wizard ✨"
echo "please read the readme file once before going further by clicking on the link "
if [[ $EUID -ne 0 ]]; then 
echo '⚠️ You must be root: Run the script again as root.
RUN "sudo -i" to switch to root and rerun the script.'
fi
while true; do 
    echo ""
    echo "🧠 Choose an option:"
    echo "1️⃣ Download the dependencies"

    echo "2️⃣ Download the node"
    echo "3️⃣ Setup the config for the CPU node"
    echo "4️⃣ Download tunnels for better logins"
    echo "5️⃣ Enable autologin (after 1st login)"
    echo "6️⃣ Delete or reinstall node"
    echo "7️⃣ Watch logs"
    echo "8️⃣ 🚀 START the node"
    echo "9️⃣ 🔐 Login Gensyn"
    echo "🔟 Exit"
    read -p "Enter the choice (1-10): " choice
    case $choice in 
    1) 
         echo "⬇️ Downloading dependencies..."
    sudo apt-get update && sudo apt-get upgrade -y && \
    curl -sSL https://raw.githubusercontent.com/zunxbt/installation/main/node.sh | bash &&\
    sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl screen git yarn && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && sudo apt update && sudo apt install -y yarn 
    sleep 1
    echo "✅ Success"
    ;;
    
    2)
        echo "⬇️ Downloading the node files..."
    wget https://github.com/gensyn-ai/rl-swarm/archive/refs/tags/v0.4.3.tar.gz && \
    tar -xvzf v0.4.3.tar.gz 
    cd rl-swarm-0.4.3
    sleep 1
    echo "✅ Downloading and extraction completed (node version: 0.4.3)"
    ;;
    
    3)
        echo "⚙️ Setting up config for the CPU node..."
    sleep 1
    
    float="float32"
    sed -i "s|torch_dtype:.*|torch_dtype: \"$float\"|" "$HOME/rl-swarm-0.4.3/hivemind_exp/configs/mac/grpo-qwen-2.5-0.5b-deepseek-r1.yaml"
    gradient="false"
    sed -i "s|gradient_checkpointing:.*|gradient_checkpointing: \"$gradient\"|" "$HOME/rl-swarm-0.4.3/hivemind_exp/configs/mac/grpo-qwen-2.5-0.5b-deepseek-r1.yaml"
    device="1"
    sed -i "s|per_device_train_batch_size:.*|per_device_train_batch_size: \"$device\"|" "$HOME/rl-swarm-0.4.3/hivemind_exp/configs/mac/grpo-qwen-2.5-0.5b-deepseek-r1.yaml"
    ;;
    
    4)
        echo "⬇️ Downloading tunnels for better login..."
    npm install -g localtunnel && \
    cd ~
curl -LO https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x cloudflared-linux-amd64 
    echo "✅ Success"
    ;;
    
    5)
        echo "🔓 Enabling autologin feature after 1st login..." 
    sed -i "s|^rm -r \$ROOT_DIR/modal-login/temp-data/.*|# &|" run_rl_swarm.sh
        echo "✅ Success"
        ;;

    6)
        echo "🗑️ Deletion in progress. Make sure you have already backed up your swarm.pem file before deleting the node files.
The process will start in 10 seconds. To stop, press Ctrl+C."
        sleep 10 
        sudo rm -rf /root/rl-swarm-0.4.3/
        echo "🗑️ Deletion complete."
        ;;

    7)
        echo "👀 You will be logged into the screen in 5 seconds. To exit, press Ctrl+A then D."
    sleep 5
    screen -d -r swarm
    ;;

    8)
        echo "🧘‍♂️ Starting node... please be patient"
        sleep 1 
        echo "🔐 NOTE: If autologin is enabled, you’ll only login once."
        sleep 2
        echo "🕔 Starting node in 5 seconds..."
        sleep 5
        screen -S swarm -dm bash -c 'cd ~/rl-swarm-0.4.3 && python3 -m venv .venv && source .venv/bin/activate && ./run_rl_swarm.sh'
        echo "✅ Node started in a detached screen session named 'swarm'. run screen -d -r swarm to view it"
        echo "🔢 Please select the following parameters on the node:"
        sleep 1
        echo "   - MATH A"
        sleep 1
        echo "   - para in billion: 0.5"
        sleep 1
        echo "👀 Watch the node screen. If it says 'Waiting for the userdata.json to be created' press 9 after 5 seconds."
        sleep 1
        ;;
    9) 
        echo "🌐 Starting tunnel for login..."
        
        
        url=$(lt --port 3000 --print-requests 2>&1 | grep -o 'https://[0-9a-zA-Z.-]*\.loca\.lt' | head -n 1)
        echo "🔗 Login URL: $url"
        echo "🧠 Open the link above and login. Then press 'y' to continue."
        read done 
        if [[ $done == "y" ]]; then 
            break
        fi
        ;;
    10) 
        echo "🚪 Exiting now..."
        sleep 1
    
        exit 0
        ;;
    esac
done
