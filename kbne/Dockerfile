# ==========================================================
# 第一阶段：构建器 (Builder Stage) - 下载 Xray 和 Supercronic
# ==========================================================
FROM ubuntu:22.04 AS builder

WORKDIR /app

# 优化下载和清理操作，使用 '&&' 连接命令以减少镜像层数
RUN set -x && \
    for i in 1 2 3; do apt-get update && break || sleep 5; done && \
    apt-get install -y --no-install-recommends wget unzip ca-certificates && \
    # 下载 Xray-core V25.10.15
    wget https://github.com/XTLS/Xray-core/releases/download/v25.10.15/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip && \
    rm -f Xray-linux-64.zip && \
    mv xray xy && \
    # 下载 supercronic
    wget -O supercronic https://github.com/aptible/supercronic/releases/latest/download/supercronic-linux-amd64 && \
    chmod +x supercronic && \
    # 清理 apt 缓存
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# ==========================================================
# 第二阶段：最终镜像 (Final Stage) - Nginx, Xray, Supercronic
# ==========================================================
FROM ubuntu:22.04

#自行更改项目
LABEL org.opencontainers.image.source="https://github.com/justlagom/koyebne"

# 定义环境变量uuid
#定义环境变量项目域名用于保活
ENV TZ=Asia/Shanghai \
    UUID=自定义变量uuid \
    DOMAIN=自定义变量

COPY entrypoint.sh /entrypoint.sh
COPY app /app

# 核心修复和优化：清理特殊字符并合并安装/清理步骤
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    # 注意: supervisor 是必须的
    apt-get install -y --no-install-recommends \
        tzdata curl ca-certificates wget vim net-tools unzip iputils-ping telnet git iproute2 nginx supervisor && \
    # 配置时区
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    # 清理 apt 缓存
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # 用户和权限设置
    chmod +x /entrypoint.sh && \
    chmod -R 777 /app && \
    useradd -u 1000 -g 0 -m -s /bin/bash user

# 从 builder 阶段复制可执行文件到最终镜像的 PATH 目录
COPY --from=builder /app/xy /usr/local/bin/xy
COPY --from=builder /app/supercronic /usr/local/bin/supercronic

#暴露端口
EXPOSE 7860

ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord", "-c", "/app/supervisor/supervisord.conf"]
