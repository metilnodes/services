### Instal go

```
cd $HOME && \
ver="1.22.0" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile && \
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bash_profile && \
source ~/.bash_profile && \
go version
```
### Install Cosmovisor and init

```
source $HOME/.bash_profile
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@latest
cosmovisor version
```
```
export DAEMON_NAME=story
echo "export DAEMON_NAME=story" >> $HOME/.bash_profile
export DAEMON_HOME=$HOME/.story/story
echo "export DAEMON_HOME=$HOME/.story/story" >> $HOME/.bash_profile
cosmovisor init $(whereis -b story | awk '{print $2}')
```

###  Create the backup directory

```
mkdir -p $DAEMON_HOME/cosmovisor/backup
echo "export DAEMON_DATA_BACKUP_DIR=$DAEMON_HOME/cosmovisor/backup" >> $HOME/.bash_profile
echo "export DAEMON_ALLOW_DOWNLOAD_BINARIES=false" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Create a directory and download new version of story:

```
mkdir -p $HOME/.story/story/cosmovisor/genesis/bin
mkdir -p $HOME/.story/story/cosmovisor/upgrades/v0.13.0/bin
cd $HOME
rm story-linux-amd64
wget https://github.com/piplabs/story/releases/download/v0.13.0/story-linux-amd64
chmod +x story-linux-amd64
sudo cp $HOME/story-linux-amd64 $HOME/.story/story/cosmovisor/upgrades/v0.13.0/bin/story
```

### Add Upgrade Information for new version

```
echo '{"name":"v0.13.0","time":"0001-01-01T00:00:00Z","height":858000}' > $HOME/.story/story/cosmovisor/upgrades/v0.13.0/upgrade-info.json
```

### Verify the Setup

```
ls -l /root/.story/story/cosmovisor/current
$HOME/.story/story/cosmovisor/upgrades/v0.13.0/bin/story version
cat $HOME/.story/story/cosmovisor/upgrades/v0.13.0/upgrade-info.json
```

### Update service file:

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
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```

### Restart service

```
sudo systemctl daemon-reload
sudo systemctl restart story && sudo systemctl status story
```
