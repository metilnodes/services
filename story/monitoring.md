# Story Grafana monitoring setup

## 1. Install Prometheus
```
cd $HOME
curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest | \
grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | wget -qi -
tar xfz prometheus-2.*.*tar.gz
rm $HOME/prometheus-2.*.*tar.gz
mv prometheus-2.* prometheus
sudo cp ~/prometheus/prometheus /usr/local/bin/
```
### Create service file for Prometheus
```
sudo tee /etc/systemd/system/prometheusd.service << EOF
[Unit]
Description=Prometheus 
After=network-online.target

[Service]
User=$USER
ExecStart=$(which prometheus) --config.file="$HOME/prometheus/prometheus.yml"
RestartSec=10
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

### Reload and start Prometheus
```
systemctl daemon-reload
sudo systemctl enable prometheusd.service
sudo systemctl restart  prometheusd.service
sudo systemctl status prometheusd.service
sudo journalctl -u prometheusd.service -fn 50 -o cat
```

## Install node exporter
```
cd $HOME
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
tar xzf node_exporter-1.6.1.linux-amd64.tar.gz
chmod +x node_exporter-1.6.1.linux-amd64/node_exporter
sudo mv ~/node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter-1.6.1.linux-amd64 node_exporter-1.6.1.linux-amd64.tar.gz
```
### Create service file for node exporter
```
sudo tee /etc/systemd/system/node-exporterd.service << EOF
[Unit]
Description=Node-Exporter 
After=network-online.target

[Service]
User=$USER
ExecStart=$(which node_exporter)
RestartSec=10
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### Reload and start node service
```
systemctl daemon-reload
sudo systemctl enable node-exporterd.service
sudo systemctl restart node-exporterd.service
sudo systemctl status node-exporterd.service
sudo journalctl -u node-exporterd.service -fn 50 -o cat
```
### Setup Prometheus config

```
nano $HOME/prometheus/prometheus.yml

```
add and save 
```
    static_configs:
      - targets: ["localhost:9090","localhost:9100"]

  - job_name: 'story'
    scheme: http
    metrics_path: /metrics
    static_configs:
      - targets: ['91.212.34.21:26660'] #IF VALIDATOR NODE LOCATED AT ANOTHER SERVER
#     - targets: ['localhost:26660'] #IF VALIDATOR NODE LOCATED ON THE SAME SERVER
```
! Make sure U got only one line of -targets: choose located at another or on the same server

```
sudo systemctl restart  prometheusd.service
sudo systemctl status prometheusd.service
```

## Install Grafana

```
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com beta main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install grafana-enterprise
```
### Reload and start node service

```
sudo systemctl daemon-reload
sudo systemctl enable grafana-servers
sudo systemctl start grafana-server
sudo systemctl status grafana-server
```

Grafana service file will be created at dir : /lib/systemd/system/grafana-server.service

After succes install we can setup our dashboard.

... In process
... In process
... In process
... In process
