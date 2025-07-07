#!/bin/bash

echo -e '\033[0;33m' 
echo -e ' __  __ _____ _____ ___ _     _   _  ___  ____  _____ ____  '
echo -e '|  \/  | ____|_   _|_ _| |   | \ | |/ _ \|  _ \| ____/ ___| '
echo -e '| |\/| |  _|   | |  | || |   |  \| | | | | | | |  _| \___ \ '
echo -e '| |  | | |___  | |  | || |___| |\  | |_| | |_| | |___ ___) |'
echo -e '|_|  |_|_____| |_| |___|_____|_| \_|\___/|____/|_____|____/ .com'
echo -e '\e[0m'

# text and color
text="Installing Story node"
color="\e[37m"  # Зелёный цвет
reset="\e[0m"   # Сброс цвета

function sub_option1() {
    echo "Install story update"
# Story binary
Story_BIN="$HOME/go/bin/story"

# Current version
current_version=$($HOME/go/bin/story version | grep -oP '(?<=Version: )\d+\.\d+\.\d+')

# Latest version
latest_version=$(curl -s "https://api.github.com/repos/piplabs/story/releases/latest" | grep -oP '(?<="tag_name": "v)\d+\.\d+\.\d+')

# Compare versions
if [ "$current_version" != "$latest_version" ]; then
    echo "Available new version for Story!"
    echo "Current version: $current_version"
    echo "Latest version available: $latest_version"
    
    read -p "Do you wanna install update? (y/n): " update_choice

    if [ "$update_choice" == "y" ]; then
        echo "Installing new version..."
        # Update
        sudo systemctl stop story
cd $HOME
rm -rf story
git clone https://github.com/piplabs/story
cd $HOME/story
git checkout $latest_version
go build -o story ./client
sudo mv $HOME/story/story $(which story)
source $HOME/.bash_profile
sudo systemctl restart story && sudo journalctl -u story -f

        echo "Updated!"
    else
        echo "Cancelled."
    fi
else
    echo "Installed last version for Story: $current_version"

fi
}

function sub_option2() {
    echo "Install story-geth update"

STORY_GETH_BIN="$HOME/go/bin/story-geth"

# Current version
current_version=$($HOME/go/bin/story-geth version | grep -oP '(?<=Version: )\d+\.\d+\.\d+')

latest_version=$(curl -s "https://api.github.com/repos/piplabs/story-geth/releases/latest" | grep -oP '(?<="tag_name": "v)\d+\.\d+\.\d+')

# Compare versions
if [ "$current_version" != "$latest_version" ]; then
    echo "Available new version for Story-geth!"
    echo "Current version: $current_version"
    echo "Latest version available: $latest_version"
    
    read -p "Do you wanna install update? (y/n): " update_choice

    if [ "$update_choice" == "y" ]; then
        echo "Installing new version..."
        # update
        sudo systemctl stop story-geth
        cd $HOME/go/bin/
        rm geth-linux-amd64
        wget https://github.com/piplabs/story-geth/releases/download/v0.10.1/geth-linux-amd64
        sudo chmod +x $HOME/geth-linux-amd64
        sudo mv $HOME/geth-linux-amd64 $HOME/go/bin/story-geth
        source $HOME/.bash_profile
        sudo systemctl start story-geth
        echo "Updated!"
    else
        echo "Cancelled."
    fi
else
    echo "Installed last version for geth: $current_version"

fi


}




# Typing
for (( i=0; i<${#text}; i++ )); do
  echo -ne "${color}${text:$i:1}${reset}"
  sleep 0.041  # Pause
done
echo  # New line

#echo -e "\033[0;37mInstalling Story node\033[0m"
echo ""
sleep 1

echo -e "\033[0;33mChoose option and press enter:\033[0m"
echo -e "\033[0;37m1. Install node\033[0m"
echo -e "\033[0;37m2. Install archive snapshot\033[0m"
echo -e "\033[0;37m3. Install pruned snapshot\033[0m"
echo -e "\033[0;37m4. Upgrade\033[0m"
echo -e "\033[0;37m5. Show logs\033[0m"
echo -e "\033[0;37m6. Check sync status\033[0m"
echo -e "\033[0;37m7. Add peers and seeds\033[0m"
echo -e "\033[0;37m8. Explorer\033[0m"
echo -e "\033[0;37m9. Exit\033[0m"

read -p "Choose option: " option

if [ "$option" -eq 1 ]; then
    echo "Installing node"

exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
echo ''
else
  sudo apt update && sudo apt install curl -y 

 < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    source $HOME/.bash_profile
fi
sleep 1

NODE="story"
DAEMON_HOME="$HOME/.story/story"
DAEMON_NAME="story"
if [ -d "$DAEMON_HOME" ]; then
    new_folder_name="${DAEMON_HOME}_$(date +"%Y%m%d_%H%M%S")"
    mv "$DAEMON_HOME" "$new_folder_name"
fi
#CHAIN_ID="aenid"
#echo 'export CHAIN_ID='\"${CHAIN_ID}\" >> $HOME/.bash_profile

if [ ! $VALIDATOR ]; then
    read -p "Enter validator name: " VALIDATOR
    echo 'export VALIDATOR='\"${VALIDATOR}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1
cd $HOME
sudo apt update
sudo apt install curl git wget htop mc btop tmux build-essential jq make lz4 gcc unzip -y < "/dev/null"

echo -e 'Install Go' && sleep 1
cd $HOME
VER="1.23.1"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile
[ ! -d ~/go/bin ] && mkdir -p ~/go/bin
go version

echo -e 'Installation' && sleep 1

#sleep 1
cd $HOME
rm -rf bin
mkdir bin
cd bin
#git clone https://github.com/piplabs/story.git
#cd story
#git checkout v0.12.1
#make build

echo -e 'Download and Install Story Binary' && sleep 1
cd $HOME
wget https://github.com/piplabs/story/releases/download/v0.12.1/story-linux-amd64
sudo chmod +x $HOME/story-linux-amd64
sudo mv $HOME/story-linux-amd64 $HOME/go/bin/story
source $HOME/.bash_profile
story version

echo -e 'Download and Install Story-Geth Binary' && sleep 1
cd $HOME
wget https://github.com/piplabs/story-geth/releases/download/v0.10.0/geth-linux-amd64 
sudo chmod +x $HOME/geth-linux-amd64
sudo mv $HOME/geth-linux-amd64 $HOME/go/bin/story-geth
source $HOME/.bash_profile
story-geth version

echo -e 'Init aenid node' && sleep 1
story init --network aenid --moniker "${VALIDATOR}"
sleep 1

echo -e 'Create story-geth service file' && sleep 1

sudo tee /etc/systemd/system/story-geth.service > /dev/null <<EOF
[Unit]
Description=Story Geth Client
After=network.target

[Service]
User=$USER
ExecStart=$(which story-geth) --aenid --syncmode full --http --http.api eth,net,web3,engine --http.vhosts '*' --http.addr 0.0.0.0 --http.port 8545 --ws --ws.api eth,web3,net,txpool --ws.addr 0.0.0.0 --ws.port 8546
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

echo -e 'Create story service file' && sleep 1

sudo tee /etc/systemd/system/story.service > /dev/null <<EOF  
[Unit]
Description=Story consensus daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$(which story) run
Restart=always
RestartSec=3
LimitNOFILE=infinity
LimitNPROC=infinity

[Install]
WantedBy=multi-user.target
EOF


#echo -e 'Running a service' && sleep 1

source $HOME/.bash_profile
sudo systemctl daemon-reload
sudo systemctl enable story
sudo systemctl restart story
sudo systemctl enable story-geth
sudo systemctl restart story-geth
sleep 5

echo -e 'Check Story Status' && sleep 1
sudo systemctl status story --no-pager -l
sleep 3

echo -e 'Check Story-Geth Status' && sleep 1
sudo systemctl status story-geth --no-pager -l
sleep 3

story validator export --export-evm-key --evm-key-path $HOME/.story/.env
story validator export --export-evm-key >>$HOME/.story/story/config/wallet.txt
cat $HOME/.story/.env >>$HOME/.story/story/config/wallet.txt
sleep 3

echo -e 'Check Sync Status' && sleep 1
curl -s localhost:26657/status | jq

echo -e 'Installation complete, checking logs (For stop use Ctrl+C command)' && sleep 5
sudo journalctl -u story -f -o cat

elif [ "$option" -eq 2 ]; then

echo -e "\033[0;33mDownloading archive snapshot\033[0m"
sleep 1
sudo apt-get install wget lz4 -y
sleep 1
sudo systemctl stop story
sudo systemctl stop story-geth
sleep 1
cp $HOME/.story/story/data/priv_validator_state.json $HOME/.story/priv_validator_state.json.backup
sleep 1
rm -rf $HOME/.story/story/data
rm -rf $HOME/.story/geth/aenid/geth/chaindata
sleep 1
wget -O story_snapshot.lz4 http://storysnapshotarchive.metilnodes.tech/downloads/story_snapshot.lz4

sleep 2

wget -O geth_snapshot.lz4 http://storysnapshotarchive.metilnodes.tech/downloads/geth_snapshot.lz4

lz4 -c -d story_snapshot.lz4 | tar -xv -C $HOME/.story/story

sleep 2

lz4 -c -d geth_snapshot.lz4 | tar -xv -C $HOME/.story/geth/aenid/geth
sleep 1
source $HOME/.bash_profile
sleep 1
echo -e "\033[0;33mDecompress completed, starting services\033[0m"
sleep 1
mv $HOME/.story/priv_validator_state.json.backup $HOME/.story/story/data/priv_validator_state.json
sleep 1
sudo rm -v story_snapshot.lz4
sudo rm -v geth_snapshot.lz4

sleep 1
sudo systemctl start story
sudo systemctl start story-geth
sleep 1
sudo journalctl -u story -u story-geth -f | head -n 1000

elif [ "$option" -eq 3 ]; then
echo -e "\033[0;33mDownloading pruned snapshot\033[0m"
sleep 1

sudo apt-get install wget lz4 -y
sleep 1
sudo systemctl stop story
sudo systemctl stop story-geth
sleep 1
sudo cp $HOME/.story/story/data/priv_validator_state.json $HOME/.story/priv_validator_state.json.backup
sleep 1
sudo rm -rf $HOME/.story/geth/aenid/geth/chaindata
sudo rm -rf $HOME/.story/story/data
sleep 1
wget -O story_snapshot.lz4 https://storysnapshot.metilnodes.tech/downloads/story_snapshot.lz4

sleep 2

wget -O geth_snapshot.lz4 https://storysnapshot.metilnodes.tech/downloads/geth_snapshot.lz4

lz4 -c -d story_snapshot.lz4 | tar -xv -C $HOME/.story/story

sleep 2

lz4 -c -d geth_snapshot.lz4 | tar -xv -C $HOME/.story/geth/aenid/geth
sleep 1
source $HOME/.bash_profile
sleep 1
echo -e "\033[0;33mDecompress completed, starting services\033[0m"
sleep 1
mv $HOME/.story/priv_validator_state.json.backup $HOME/.story/story/data/priv_validator_state.json
sleep 1
sudo rm -v story_snapshot.lz4
sudo rm -v geth_snapshot.lz4
sleep 1
sudo systemctl start story
sudo systemctl start story-geth
sleep 1
sudo journalctl -u story -u story-geth -f | head -n 1000


elif [ "$option" -eq 4 ]; then
 # echo -e "\033[0;33mUpgrading in process...\033[0m"
echo -e "\033[0;33mChoose update\033[0m"
echo -e "\033[0;37m1. story\033[0m"
echo -e "\033[0;37m2. story-geth\033[0m"
    
    read -p "Choose update: " sub_choice
    
    case $sub_choice in
        1)
            sub_option1
            ;;
        2)
            sub_option2
            ;;
        *)
            echo "Incorrect"
            ;;
    esac


elif [ "$option" -eq 5 ]; then

echo -e "\033[0;33mShowing Story & Story-geth logs (use Ctrl+C to stop showing)\033[0m"
sleep 1
sudo journalctl -u story -u story-geth -f

elif [ "$option" -eq 6 ]; then

echo -e "\033[0;33mIf the result is 'false', the node is synchronized\033[0m"
curl -s localhost:26657/status | jq .result.sync_info

elif [ "$option" -eq 7 ]; then
PEERS=$(curl -sS http://95.216.245.173:26657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | paste -sd, -)
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.story/story/config/config.toml
SEEDS=eeba908e8ff2889e8f94026874604badca5c9d83@2a01:95.216.245.173:26656,2df2b0b66f267939fea7fe098cfee696d6243cec@story-seed.mandragora.io:23656,434af9dae402ab9f1c8a8fc15eae2d68b5be3387@story-testnet-seed.itrocket.net:29656, 3f472746f46493309650e5a033076689996c8881@story-testnet.rpc.kjnodes.com:26659
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" $HOME/.story/story/config/config.toml
systemctl restart story
    echo "Peers and seeds added"
elif [ "$option" -eq 8 ]; then
    echo "Go to explorer via link below:"
echo -e "\033[0;33mhttps://testnet.storyscan.app/\033[0m"

elif [ "$option" -eq 9 ]; then
    echo "Installation canceled"

else
    echo "Incorrect, try again."
fi
