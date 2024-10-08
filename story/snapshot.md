# Story snapshots (archive & prunned) + One-liner

### One-liner for apply snapshot
```
wget -q -O story.sh hhttps://raw.githubusercontent.com/metilnodes/services/refs/heads/main/story/story.sh && sudo chmod +x story.sh && ./story.sh
```

## Archive snapshot

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


## Pruned snapshot

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
