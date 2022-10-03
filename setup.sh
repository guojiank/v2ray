#!/usr/bin/env bash

PORT=33
VERSION=v4.22.0

ufw disable
mkdir /opt/v2ray -p

cd /opt/v2ray || exit 1

rm -rf /opt/v2ray/*
wget -nv -c https://github.com/v2fly/v2ray-core/releases/download/$VERSION/v2ray-linux-64.zip
unzip  v2ray-linux-64

cat >/etc/systemd/system/v2ray.servie <<EOF
[Unit]
Description=V2Ray Service
After=network.target
Wants=network.target

[Service]
# This service runs as root. You may consider to run it as another user for security concerns.
# By uncommenting the following two lines, this service will run as user v2ray/v2ray.
# More discussion at https://github.com/v2ray/v2ray-core/issues/1011
# User=v2ray
# Group=v2ray
Type=simple
PIDFile=/run/v2ray.pid
ExecStart=/opt/v2ray/v2ray-linux-64/v2ray -config /etc/v2ray/config.json
Restart=on-failure
# Don't restart in the case of configuration error
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
EOF

mkdir -p /etc/v2ray
cat >/etc/v2ray/config.json<<EOF
{
  "log": {
    "loglevel": "debug"
  },
  "inbounds": [
    {
      "port": "$PORT",
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "ecf27a40-139c-46e5-81b6-6d41ee291a28",
            "level": 1,
            "alterId": 64
          }
        ]
      },
      "streamSettings": {
        "network": "mkcp",
        "kcpSettings": {
          "mtu": 1350,
          "tti": 20,
          "uplinkCapacity": 10,
          "downlinkCapacity": 100,
          "congestion": false,
          "readBufferSize": 2,
          "writeBufferSize": 2,
          "header": {
            "type": "none"
          }
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
EOF

systemctl daemon-reload
systemctl restart v2ray
systemctl enable v2ray
