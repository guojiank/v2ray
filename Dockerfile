FROM guojiank/alpine:latest

COPY . /ss

WORKDIR /ss


# 定义服务器ip地址
# 不写-e server=xxx 表示启动服务器端
# 默认启动 服务端
ENV server=
ENV port=33
ENV socks5port=1080

CMD "./run.sh"
