# 锁定 Alpine 3.20
FROM alpine:3.20

# 安装基础包 + wget 和 unzip 来处理游戏数据包
RUN apk update && \
    apk add --no-cache minetest minetest-server wget unzip ca-certificates

# 1. 创建游戏存放目录
# 2. 从 GitHub 下载最基础的 minetest_game
# 3. 解压并清理临时文件
RUN mkdir -p /usr/share/minetest/games/minetest_game && \
    wget https://github.com/minetest/minetest_game/archive/refs/heads/master.zip -O /tmp/game.zip && \
    unzip /tmp/game.zip -d /tmp/ && \
    cp -r /tmp/minetest_game-master/* /usr/share/minetest/games/minetest_game/ && \
    rm -rf /tmp/game.zip /tmp/minetest_game-master

# 保持原来的用户设置
RUN mkdir -p /var/lib/minetest/.minetest/worlds/world && \
    chown -R minetest: /var/lib/minetest

COPY minetest.conf /etc/minetest/minetest.conf

EXPOSE 30000/udp

USER minetest

# 注意：这里 gameid 对应我们创建的文件夹名字 minetest_game
CMD ["minetestserver", "--config", "/etc/minetest/minetest.conf", "--gameid", "minetest_game"]