![alt text](https://github.com/metilnodes/metilnodes/blob/main/logo/storysnapshot.png)


# Story snapshots (archive & prunned) + One-liner

### One-liner for apply snapshot
```
wget -q -O story.sh https://raw.githubusercontent.com/metilnodes/services/refs/heads/main/story/story.sh && sudo chmod +x story.sh && ./story.sh
```

### Add peers
```
PEERS=$(curl -sS curl -sS http://78.46.60.145:26657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | paste -sd, -)

sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.story/story/config/config.toml

systemctl restart story
```

### Add seeds
```
SEEDS=8c1b516805e0c4631306032a0108e51339ab7cfd@78.46.60.145:26656,b6fb541c80d968931602710342dedfe1f5c577e3@story-seed.mandragora.io:23656,51ff395354c13fab493a03268249a74860b5f9cc@story-testnet-seed.itrocket.net:26656,5d7507dbb0e04150f800297eaba39c5161c034fe@135.125.188.77:26656

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
sudo rm -rf $HOME/.story/geth/iliad/geth/chaindata
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
lz4 -c -d geth_snapshot.lz4 | tar -xv -C $HOME/.story/geth/iliad/geth

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
sudo rm -rf $HOME/.story/geth/iliad/geth/chaindata
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
lz4 -c -d geth_snapshot.lz4 | tar -xv -C $HOME/.story/geth/iliad/geth

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

