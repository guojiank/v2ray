#!/usr/bin/env sh

if [ -z $server ] ;then
    envsubst < config-server.json > config.json
    echo 'start ss server'
    echo 'server port:'${port}
else
    envsubst < config-client.json > config.json
    echo 'start ss client'
    echo 'socks5 port:'${socks5port}
fi

./v2ray-linux-64/v2ray -config config.json