#!/bin/bash
###
 # @Author: asdevao 1097802349@qq.com
 # @Date: 2024-12-30 22:03:37
 # @LastEditors: asdevao 1097802349@qq.com
 # @LastEditTime: 2025-01-02 16:29:22
 # @FilePath: \mini_program\apps\run_mysql_docker.sh
 # @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
### 

# 拉取镜像
docker pull mysql:8.0

# 检查是否已存在同名容器，如果存在则删除
container_id=$(docker ps -a -q -f name=mysql)

if [ -n "$container_id" ]; then
  echo "容器 mysql 已经存在，正在删除..."
  docker rm -f mysql
else
  echo "没有找到容器 mysql，继续创建..."
fi

# 创建必要的目录（如果不存在）
mkdir -p /usr/local/docker_data/mysql/data
mkdir -p /usr/local/docker_data/mysql/conf
mkdir -p /usr/local/docker_data/mysql/conf/conf.d
mkdir -p /usr/local/docker_data/mysql/logs
mkdir -p /usr/local/docker_data/mysql/sql

# 更改目录权限
sudo chown -R 999:999 /usr/local/docker_data/mysql/data
sudo chown -R 999:999 /usr/local/docker_data/mysql/logs
sudo chown -R 999:999 /usr/local/docker_data/mysql/conf
sudo chown -R 999:999 /usr/local/docker_data/mysql/sql

# 将当前目录下的 mini_program.sql 文件复制到挂载目录
cp ./mini_program.sql /usr/local/docker_data/mysql/sql/

# 启动 MySQL 容器并连接到 my_network 网络
docker run -d \
  --name mysql \
  --network my_network \
  -p 5102:3306 \
  -h mysql_mini_program \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -v /usr/local/docker_data/mysql/data:/var/lib/mysql \
  -v /usr/local/docker_data/mysql/conf:/etc/mysql/ \
  -v /usr/local/docker_data/mysql/logs:/var/log/mysql \
  -v /usr/local/docker_data/mysql/sql:/docker-entrypoint-initdb.d/ \
  mysql:8.0

# 等待 MySQL 容器启动并初始化
echo "等待 MySQL 容器启动..."
sleep 5  # 等待 MySQL 启动

# 进入 MySQL 容器并创建数据库
echo "进入 MySQL 容器并创建 mini_program 数据库..."
docker exec -i mysql mysql -u root -p123456 -e "CREATE DATABASE IF NOT EXISTS mini_program;"  

# 查看容器日志
docker logs mysql