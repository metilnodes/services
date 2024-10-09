![alt text](https://github.com/metilnodes/metilnodes/blob/main/logo/storyservices.png)


# Story

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
### Download Story-Geth binary
```
cd $HOME
wget -O geth-linux-amd64-0.9.3-b224fdf.tar.gz https://story-geth-binaries.s3.us-west-1.amazonaws.com/geth-public/geth-linux-amd64-0.9.3-b224fdf.tar.gz 
tar xvf geth-linux-amd64-0.9.3-b224fdf.tar.gz
sudo chmod +x geth-linux-amd64-0.9.3-b224fdf/geth
sudo mv geth-linux-amd64-0.9.3-b224fdf/geth $HOME/go/bin/story-geth
source $HOME/.bash_profile
story-geth version
```

### Download Story binary
```
wget -O story-linux-amd64-0.10.1-57567e5 https://story-geth-binaries.s3.us-west-1.amazonaws.com/story-public/story-linux-amd64-0.10.1-57567e5.tar.gz
tar xvf story-linux-amd64-0.10.1-57567e5
sudo chmod +x story-linux-amd64-0.10.1-57567e5/story
sudo mv story-linux-amd64-0.10.1-57567e5/story $HOME/go/bin
source $HOME/.bash_profile
story version
```

### Init Iliad node
```
story init --network iliad --moniker "Your_moniker_name"

```

### Create service file story-geth
```
sudo tee /etc/systemd/system/story-geth.service > /dev/null <<EOF
[Unit]
Description=Story Geth Client
After=network.target

[Service]
User=root
ExecStart=/root/go/bin/story-geth --iliad --syncmode full --http --http.api eth,net,web3,engine --http.vhosts '*' --http.addr 0.0.0.0 --http.port 8545 --ws --ws.api eth,web3,net,txpool --ws.addr 0.0.0.0 --ws.port 8546
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
story validator create --stake 1000000000000000000 --private-key "your_private_key"

```
```diff
!!Important!! Backup your validator key: $HOME/.story/story/config/priv_validator_key.json
```

Validator Staking
```
story validator stake \
   --validator-pubkey "VALIDATOR_PUB_KEY_IN_BASE64" \
   --stake 1000000000000000000 \
   --private-key xxxxxxxxxxxxxx
```

