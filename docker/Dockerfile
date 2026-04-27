# 使用超轻量级的 Alpine Linux 作为基础镜像
FROM alpine:latest

# 安装 Minetest Server
RUN apk update && \
    apk add --no-cache minetest minetest-server

# 创建运行游戏所需的用户组和目录
RUN mkdir -p /var/lib/minetest/.minetest/worlds/world && \
    chown -R minetest:minetest /var/lib/minetest

# 将我们自定义的配置文件复制到容器内部
COPY minetest.conf /etc/minetest/minetest.conf

# 暴露 30000 UDP 端口
EXPOSE 30000/udp

# 切换到非 root 用户运行（K8s 安全最佳实践）
USER minetest

# 容器启动时执行的命令
CMD ["minetestserver", "--config", "/etc/minetest/minetest.conf"]