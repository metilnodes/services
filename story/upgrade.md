> [!WARNING]
> **Upgrade height: 858000. Please don`t upgrade story binary before the specified height**
>

##  One-liner for automate upgrade

Run the script for quick installation, choose "Upgrade", add a name for your node and wait for the installation to finish
```
wget -q -O story.sh https://raw.githubusercontent.com/metilnodes/services/refs/heads/main/story/story.sh && sudo chmod +x story.sh && ./story.sh
```

## Manual update

### Upgrade story-geth binary v0.10.1
```
cd $HOME
sudo systemctl stop story-geth
rm geth-linux-amd64
wget https://github.com/piplabs/story-geth/releases/download/v0.10.1/geth-linux-amd64
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

### Cosmovisor auto upgrade
in process
