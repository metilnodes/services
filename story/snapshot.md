# Story snapshot

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
### Download story snapshot

```
wget -O story_snapshot.lz4 http://storysnapshot.metilnodes.tech/downloads/story_snapshot.lz4

```
### Download story-geth snapshot
```
wget -O geth_snapshot.lz4 http://storysnapshot.metilnodes.tech/downloads/geth_snapshot.lz4

```

### Decompress story snapshot
```
lz4 -c -d story_snapshot.lz4 | tar -xv -C $HOME/.story/story

```
### Decompress story-geth snapshot
```
lz4 -c -d geth_snapshot.lz4 | tar -xv -C $HOME/.story/geth/iliad/geth

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
