FROM alpine:3.20

# 修复点 1：增加安装 minetest-game (这是最基础的游戏内容包)
RUN apk update && \
    apk add --no-cache minetest minetest-server minetest-game

# 保持原来的用户和目录设置
RUN adduser -D minetest
RUN mkdir -p /var/lib/minetest/.minetest/worlds/world && \
    chown -R minetest: /var/lib/minetest

COPY minetest.conf /etc/minetest/minetest.conf

EXPOSE 30000/udp

USER minetest

# 修复点 2：在启动命令中显式指定 --gameid minetest
CMD ["minetestserver", "--config", "/etc/minetest/minetest.conf", "--gameid", "minetest"]