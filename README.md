# v2ray
## 启动服务端
```
docker run -d --net host -e port=22 guojiank/v2ray
```
- `-e port=22`暴露22端口
## 启动客户端
```
docker run -d --net host -e socks5port=1080 -e port=22 -e server=your-server-ip guojiank/v2ray
```
- 监听本地socks5协议的1080端口
- `-e port=22`连接服务的22端口
- `-e server=your-server-ip`海外服务器ip