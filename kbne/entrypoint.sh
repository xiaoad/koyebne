#!/usr/bin/env sh

# 1. 替换 Xray 配置中的 UUID (使用您简洁的写法)
sed -i "s/UUID/$UUID/g" /app/xy/config.json

# 2. 替换 keepalive 脚本中的 DOMAIN
sed -i "s/DOMAIN_PLACEHOLDER/$DOMAIN/g" /app/keepalive.sh

# 3. 替换 Supervisor 配置中的 Cloudflared Token
sed -i "s|<YOUR_CLOUDFLARED_TUNNEL_TOKEN>|$CLOUDFLARED_TOKEN|g" /app/supervisor/supervisord.conf

# 4. 替换 Nginx 配置文件中的 PROXY_PATH
sed -i "s|PROXY_PATH_PLACEHOLDER_NGINX|$PROXY_PATH|g" /app/nginx/nginx.conf

# 5. 替换 Xray 配置文件中的 PROXY_PATH
# 假设 Xray 中的占位符是 "PROXY_PATH_PLACEHOLDER_XRAY"
sed -i "s|\\\"PROXY_PATH_PLACEHOLDER_XRAY\\\"|\\\"$PROXY_PATH\\\"|g" /app/xy/config.json

# 6. 设置 DNS (如您原脚本所示)
cp /etc/resolv.conf /etc/resolv.conf.bak
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# 7. 执行 CMD (即 supervisord)
exec "$@"
