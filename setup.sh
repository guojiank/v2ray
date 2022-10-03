#!/usr/bin/env bash

set -e

PORT=33
VERSION=v5.1.0

ufw disable
mkdir /opt/v2ray -p
mkdir /usr/local/etc/v2ray -p

cd /opt/v2ray
wget -nv -c https://github.com/v2fly/v2ray-core/releases/download/$VERSION/v2ray-linux-64.zip
unzip -f v2ray-linux-64
cp -r /opt/v2ray/systemd/system/* /etc/systemd/system/

cat >/usr/local/etc/v2ray/config.json<<EOF
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

[ -f /usr/local/bin/v2ray ] && rm -f /usr/local/bin/v2ray
ln -s /opt/v2ray/v2ray /usr/local/bin/v2ray

systemctl daemon-reload
systemctl restart v2ray
systemctl enable v2ray
