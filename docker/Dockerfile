# 锁定 Alpine 3.20 版本
FROM alpine:3.20

# 安装 Minetest Server (这一步其实已经悄悄创建了 minetest 用户)
RUN apk update && \
    apk add --no-cache minetest minetest-server

# 创建运行游戏所需的目录
# 👇 终极修复点：使用 minetest: (注意后面的冒号)，系统会自动匹配它默认的用户组
RUN mkdir -p /var/lib/minetest/.minetest/worlds/world && \
    chown -R minetest: /var/lib/minetest

# 将我们自定义的配置文件复制到容器内部
COPY minetest.conf /etc/minetest/minetest.conf

# 暴露 30000 UDP 端口
EXPOSE 30000/udp

# 切换到非 root 用户运行
USER minetest

# 容器启动时执行的命令
CMD ["minetestserver", "--config", "/etc/minetest/minetest.conf"]