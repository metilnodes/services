![alt text](https://github.com/metilnodes/metilnodes/blob/main/logo/storyservices.png)


# Story 
> [!WARNING]
> Important upgrades: ****story binary v1.3.0** at block **height 6.008.000**, expected on June 25, 2025 | **story-geth binary v1.1.0**
> 
> [Install last upgrade](https://github.com/metilnodes/services/blob/main/story/update.md)

##  One-liner for automate Installation

Run the script for quick installation, choose "Install node", add a name for your node and wait for the installation to finish
```
wget -q -O story.sh https://raw.githubusercontent.com/metilnodes/services/refs/heads/main/story/story.sh && sudo chmod +x story.sh && ./story.sh
```
### What One-liner can:
1. Node installation
2. Download and apply archive snapshot
3. Download and apply pruned snapshot
4. Node upgrading + latest version checker for story and story-geth
5. Showing logs
6. Sync status checker

## Manual Installation

### Install dependencies
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl make build-essential git mc wget jq htop lz4 nano tmux btop tar clang gcc libleveldb-dev -y
```

### Install GO
```
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
```
### Download Story-Geth binary v1.1.0
```
cd $HOME
rm -rf story-geth
git clone https://github.com/piplabs/story-geth.git
cd story-geth
git checkout v1.1.0
make geth
sudo mv build/bin/geth  $HOME/go/bin/
source $HOME/.bash_profile
story-geth version
```

### Download Story binary v1.3.0
```
cd $HOME
git clone https://github.com/piplabs/story
sudo chmod +x $HOME/story
cd story
git checkout v1.3.0
go build -o story ./client 
sudo mv $HOME/story/story $HOME/go/bin
source $HOME/.bash_profile
story version
```

### Init Aenid node
```
story init --network aeneid --moniker "Your_moniker_name"

```

### Create service file story-geth
```
sudo tee /etc/systemd/system/story-geth.service > /dev/null <<EOF
[Unit]
Description=Story Geth Client
After=network.target

[Service]
User=root
ExecStart=/root/go/bin/story-geth --aenid --syncmode full --http --http.api eth,net,web3,engine --http.vhosts '*' --http.addr 0.0.0.0 --http.port 8545 --ws --ws.api eth,web3,net,txpool --ws.addr 0.0.0.0 --ws.port 8546
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```

### Create service file story
```
sudo tee /etc/systemd/system/story.service > /dev/null <<EOF
[Unit]
Description=Story Consensus Client
After=network.target

[Service]
User=root
ExecStart=/root/go/bin/story run
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```

### Launch service files

```
sudo systemctl daemon-reload
sudo systemctl enable story
sudo systemctl enable story-geth
sudo systemctl start story-geth
sudo systemctl start story
```

### Check logs
```
sudo journalctl -u story-geth -f -o cat
sudo journalctl -u story -f -o cat
```

### Check sync status
If the result is 'false', the node is synchronized
```
curl localhost:26657/status | jq

```

### [Install Snapshot](https://github.com/metilnodes/services/blob/main/story/snapshot.md)

## Create validator
Check your validator key
```
story validator export

```
Export EVM private key
```
story validator export --export-evm-key

```
Create validator

```
story validator create --stake 1024000000000000000000 --private-key "your_private_key" --moniker "your_moniker_name"

```
```diff
!!Important!! Backup your validator key: $HOME/.story/story/config/priv_validator_key.json
```

Validator Staking
```
story validator stake \
   --validator-pubkey "VALIDATOR_PUB_KEY_IN_BASE64" \
   --stake 1024000000000000000000 \
   --private-key xxxxxxxxxxxxxx
```

### Delete node
```
sudo systemctl stop story-geth
sudo systemctl stop story
sudo systemctl disable story-geth
sudo systemctl disable story
sudo rm /etc/systemd/system/story-geth.service
sudo rm /etc/systemd/system/story.service
sudo systemctl daemon-reload
sudo rm -rf $HOME/.story
sudo rm $HOME/go/bin/story-geth
sudo rm $HOME/go/bin/story
```
