> [!WARNING]
> **Upgrade height Story-Geth: 1,243,000 . Please don`t upgrade story binary before the specified height**
>

##  One-liner for automate upgrade

Run the script for quick installation, choose "Upgrade", add a name for your node and wait for the installation to finish
```
wget -q -O story.sh https://raw.githubusercontent.com/metilnodes/services/refs/heads/main/story/story.sh && sudo chmod +x story.sh && ./story.sh
```

## Manual update

### Upgrade story-geth binary v0.11.0
```
cd $HOME
sudo systemctl stop story-geth
rm geth-linux-amd64
wget https://github.com/piplabs/story-geth/releases/download/v0.11.0/geth-linux-amd64
chmod +x geth-linux-amd64
mv $HOME/geth-linux-amd64 $HOME/go/bin/story-geth
source $HOME/.bash_profile
story-geth version
```
### Restart service
```
sudo systemctl restart story-geth
sudo journalctl -u story-geth -f -o cat
```

### Upgrade story-geth binary v0.13.0

```
cd $HOME
sudo systemctl stop story
rm story-linux-amd64
wget https://github.com/piplabs/story/releases/download/v0.13.0/story-linux-amd64
chmod +x story-linux-amd64
cp $HOME/story-linux-amd64 $HOME/go/bin/story
source $HOME/.bash_profile
story version
```
### Restart service
```
sudo systemctl restart story
sudo journalctl -u story -f -o cat
```

## Cosmovisor auto upgrade

### Install Cosmovisor

```
source $HOME/.bash_profile
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@latest
```
### Init Cosmovisor

```
export DAEMON_NAME=story
echo "export DAEMON_NAME=story" >> $HOME/.bash_profile
export DAEMON_HOME=$HOME/.story/story
echo "export DAEMON_HOME=$HOME/.story/story" >> $HOME/.bash_profile
```

### Initialize Cosmovisor with DAEMON_HOME

```
cosmovisor init $(whereis -b story | awk '{print $2}')
```

```
mkdir -p $DAEMON_HOME/cosmovisor/backup
echo "export DAEMON_DATA_BACKUP_DIR=$DAEMON_HOME/cosmovisor/backup" >> $HOME/.bash_profile
echo "export DAEMON_ALLOW_DOWNLOAD_BINARIES=false" >> $HOME/.bash_profile
source $HOME/.bash_profile
mkdir -p $HOME/.story/story/cosmovisor/genesis/bin
mkdir -p $HOME/.story/story/cosmovisor/upgrades/v0.13.0/bin
```

### Stop node

```
sudo systemctl stop story
```

### Download Story binary

```
cd $HOME
rm story-linux-amd64
wget https://github.com/piplabs/story/releases/download/v0.13.0/story-linux-amd64
chmod +x story-linux-amd64
sudo cp $HOME/story-linux-amd64 $HOME/.story/story/cosmovisor/upgrades/v0.13.0/bin/story
echo '{"name":"v0.13.0","time":"0001-01-01T00:00:00Z","height":858000}' > $HOME/.story/story/cosmovisor/upgrades/v0.13.0/upgrade-info.json
```

### Verify the Setup

```
ls -l /root/.story/story/cosmovisor/current
$HOME/.story/story/cosmovisor/genesis/bin/story version
$HOME/.story/story/cosmovisor/upgrades/v0.13.0/bin/story version
cat $HOME/.story/story/cosmovisor/upgrades/v0.13.0/upgrade-info.json
```

### Update service file

```
sudo tee /etc/systemd/system/story.service > /dev/null <<EOF
[Unit]
Description=Story Consensus Client
After=network.target

[Service]
User=root
Environment="DAEMON_NAME=story"
Environment="DAEMON_HOME=/root/.story/story"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=true"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="DAEMON_DATA_BACKUP_DIR=/root/.story/story/data"
Environment="UNSAFE_SKIP_BACKUP=true"
ExecStart=/root/go/bin/cosmovisor run run
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

```
sudo systemctl daemon-reload
sudo systemctl start story && sudo systemctl status story
```

### Set schedule for upgrade
```
source $HOME/.bash_profile
cosmovisor add-upgrade v0.13.0 $HOME/.story/story/cosmovisor/upgrades/v0.13.0/bin/story --force --upgrade-height 858000
```
