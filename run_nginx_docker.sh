#!/bin/bash

# 拉取 nginx 镜像
docker pull nginx

# 检查容器是否存在并删除
docker ps -a | grep -q nginx_5101 && docker rm -f nginx_5101

# 创建必要的文件夹
mkdir -p /opt/project/nginx_5101/apps
mkdir -p /opt/project/nginx_5101/conf/conf.d
mkdir -p /opt/project/nginx_5101/log

# 创建网络（如果没有的话）
docker network inspect my_network > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "网络 my_network 不存在，正在创建..."
  docker network create my_network
else
  echo "网络 my_network 已存在，跳过创建..."
fi

# 启动 nginx 容器并连接到 my_network 网络
docker run -d --name nginx_5101 --network my_network -p 5101:80 \
-v /opt/project/nginx_5101/apps/dist:/usr/share/nginx/html \
-v /opt/project/nginx_5101/conf/conf.d:/etc/nginx/conf.d \
-v /opt/project/nginx_5101/conf/nginx.conf:/etc/nginx/nginx.conf \
-v /opt/project/nginx_5101/log:/var/log/nginx \
nginx

# 确保 dist 目录已经构建
if [ -d "dist" ]; then
  echo "正在拷贝前端构建文件到容器挂载目录..."
  cp -r ../dist /opt/project/nginx_5101/apps
  echo "代码文件成功拷贝到容器挂载目录。"
else
  echo "错误：dist 目录不存在，请先构建项目。"
  exit 1
fi

# 修改挂载目录的权限，确保 Nginx 有权限访问
echo "修改文件和目录的权限..."
sudo chmod -R 655:655 /opt/project/nginx_5101/apps
sudo chmod -R 655:655 /opt/project/nginx_5101/log
sudo chmod -R 655:655 /opt/project/nginx_5101/conf

# 输出 Nginx 容器日志查看是否有错误
echo "查看 Nginx 容器日志..."
docker logs nginx_5101
