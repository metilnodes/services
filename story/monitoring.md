# Story Grafana monitoring setup

## Install Prometheus
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
add text below and save 
```
    static_configs:
      - targets: ["localhost:9090","localhost:9100"]

  - job_name: 'prometheus'
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

### Install Grafana

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

### After succes install we can setup our dashboard.

Open config and change prometheus value to TRUE and restart your validator node!
```
 nano $HOME/.story/story/config/config.toml

```
![image](https://github.com/user-attachments/assets/1f2ba214-353f-47a5-919c-fc140d8f77ff)

### Connect to our Grafana web page

Open your browser and visit http://YOUR_IP:3000

![image](https://github.com/user-attachments/assets/238d0499-f3ab-4025-8b17-9bddeaae073e)
username/password : admin/admin (change it after first login)

On Home page click Connections - Data Sources - Add data source 

![image](https://github.com/user-attachments/assets/54c5eea5-de40-404d-ba32-0d3712fe67a2)

Click on Prometheus

![image](https://github.com/user-attachments/assets/25c23260-cbb5-4cda-9bd4-0348700aeda8)

In connection type: http://localhost:9090, setup name and click Save % test in the end of the page

![image](https://github.com/user-attachments/assets/be6399a9-69e6-48e3-820e-bf91fb88b324)
![image](https://github.com/user-attachments/assets/e5e6384a-ca9a-4d44-9d11-fc696c64d4d5)

-----
## Import Dashboad for monitoring

Go to Dashboards - New - Import
![image](https://github.com/user-attachments/assets/083ba753-a01e-4db6-8b62-8f885ee9832f)

You can Upload dshaboard Json file, Import via text or choose ID of prepared [Grafana dashboards](https://grafana.com/grafana/dashboards/)

![image](https://github.com/user-attachments/assets/e6e26678-0bc7-4478-a04f-f77e469c10d4)
