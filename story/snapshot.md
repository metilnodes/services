![alt text](https://github.com/metilnodes/metilnodes/blob/main/logo/storysnapshot.png)


# Story snapshots (archive & prunned) + One-liner

### One-liner for apply snapshot
```
wget -q -O story.sh https://raw.githubusercontent.com/metilnodes/services/refs/heads/main/story/story.sh && sudo chmod +x story.sh && ./story.sh
```

### Add peers
```
PEERS=$(curl -sS http://95.216.245.173:26657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | paste -sd, -)

sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.story/story/config/config.toml

systemctl restart story
```

### Add seeds
```
SEEDS=eeba908e8ff2889e8f94026874604badca5c9d83@2a01:95.216.245.173:26656,2df2b0b66f267939fea7fe098cfee696d6243cec@story-seed.mandragora.io:23656,434af9dae402ab9f1c8a8fc15eae2d68b5be3387@story-testnet-seed.itrocket.net:29656, 3f472746f46493309650e5a033076689996c8881@story-testnet.rpc.kjnodes.com:26659

sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" $HOME/.story/story/config/config.toml

sudo systemctl restart story
```
**
**

## Archive snapshot - manual install
Height of the snapshot: [Check Height](https://storysnapshotarchive.metilnodes.tech/downloads/height.txt)

### Install Tools
```
sudo apt-get install wget lz4 -y

```
### Backup priv_validator_state.json
```
sudo cp $HOME/.story/story/data/priv_validator_state.json $HOME/.story/priv_validator_state.json.backup

```

### Remove old data
```
sudo rm -rf $HOME/.story/geth/odyssey/geth/chaindata
sudo rm -rf $HOME/.story/story/data
```
### Download story archive snapshot

```
wget -O story_snapshot.lz4 https://storysnapshotarchive.metilnodes.tech/downloads/story_snapshot.lz4

```
### Download story-geth snapshot
```
wget -O geth_snapshot.lz4 https://storysnapshotarchive.metilnodes.tech/downloads/geth_snapshot.lz4
```

### Decompress story snapshot
```
lz4 -c -d story_snapshot.lz4 | tar -xv -C $HOME/.story/story

```
### Decompress story-geth snapshot
```
lz4 -c -d geth_snapshot.lz4 | tar -xv -C $HOME/.story/geth/odyssey/geth

```

### Restore priv_validator_state.json
```
mv $HOME/.story/story/priv_validator_state.json.backup $HOME/.story/story/data/priv_validator_state.json

```

### Delete downloaded snapshots
```
sudo rm -v story_snapshot.lz4
sudo rm -v geth_snapshot.lz4
```


### Restart node
```
sudo systemctl start story
sudo systemctl start story-geth
```
### Check logs
```
sudo journalctl -u story -f -o cat
sudo journalctl -u story-geth -f -o cat
```


## Pruned snapshot - manual install
Height of the snapshot: [Check Height](https://storysnapshot.metilnodes.tech/downloads/height.txt)

### Install Tools
```
sudo apt-get install wget lz4 -y

```
### Backup priv_validator_state.json
```
sudo cp $HOME/.story/story/data/priv_validator_state.json $HOME/.story/priv_validator_state.json.backup

```

### Remove old data
```
sudo rm -rf $HOME/.story/geth/odyssey/geth/chaindata
sudo rm -rf $HOME/.story/story/data
```
### Download story prunned snapshot

```
wget -O story_snapshot.lz4 https://storysnapshot.metilnodes.tech/downloads/story_snapshot.lz4

```
### Download story-geth snapshot
```
wget -O geth_snapshot.lz4 https://storysnapshot.metilnodes.tech/downloads/geth_snapshot.lz4

```

### Decompress story snapshot
```
lz4 -c -d story_snapshot.lz4 | tar -xv -C $HOME/.story/story

```
### Decompress story-geth snapshot
```
lz4 -c -d geth_snapshot.lz4 | tar -xv -C $HOME/.story/geth/odyssey/geth

```


### Restore priv_validator_state.json
```
mv $HOME/.story/story/priv_validator_state.json.backup $HOME/.story/story/data/priv_validator_state.json

```

### Delete downloaded snapshots
```
sudo rm -v story_snapshot.lz4
sudo rm -v geth_snapshot.lz4
```

### Restart node
```
sudo systemctl start story
sudo systemctl start story-geth
```
### Check logs
```
sudo journalctl -u story -f -o cat
sudo journalctl -u story-geth -f -o cat
```

