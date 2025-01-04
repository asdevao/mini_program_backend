#!/bin/bash
###
 # @Author: asdevao 1097802349@qq.com
 # @Date: 2024-12-30 22:03:37
 # @LastEditors: asdevao 1097802349@qq.com
 # @LastEditTime: 2025-01-02 23:23:17
 # @FilePath: \deploy-scripts\run_flask_docker.sh
 # @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
### 

# 项目 Git 仓库地址
# GIT_REPO_URL="https://github.com/asdevao/mini_program_backend"
GIT_REPO_URL="git@github.com:asdevao/mini_program_backend.git"
PROJECT_DIR="mini_program_backend"
CONTAINER_NAME="flaskProject"
IMAGE_NAME="flaskproject"
PORT=5103  # 宿主机的端口 5103 映射到容器 5000 端口
BRANCH_NAME="server-backend"  # 要拉取的分支名称

# 检查是否已有同名容器存在，如果存在则停止并删除
if [ $(docker ps -a -q -f name=$CONTAINER_NAME) ]; then
  echo "容器 $CONTAINER_NAME 已存在，正在停止并删除..."
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME
else
  echo "没有找到容器 $CONTAINER_NAME，继续创建..."
fi

# 检查是否已有同名镜像存在，如果存在则删除
if [ $(docker images -q $IMAGE_NAME) ]; then
  echo "镜像 $IMAGE_NAME 已存在，正在删除..."
  docker rmi -f $IMAGE_NAME
else
  echo "没有找到镜像 $IMAGE_NAME，继续构建..."
fi

# 克隆 Git 仓库
echo "克隆项目代码..."
git clone --branch $BRANCH_NAME $GIT_REPO_URL

# 进入项目目录
cd $PROJECT_DIR

# 构建 Docker 镜像
echo "构建 Docker 镜像..."
docker build -t $IMAGE_NAME .

# 检查镜像构建是否成功
if [ $? -eq 0 ]; then
  echo "镜像构建成功！"
else
  echo "镜像构建失败！请检查错误日志。"
  exit 1
fi

# 启动容器并连接到 my_network 网络，映射宿主机的5103端口到容器的5000端口
docker run -it --name $CONTAINER_NAME --network my_network -p $PORT:5000 -e HOSTNAME=172.20.0.2 -d $IMAGE_NAME

# 检查容器是否启动成功
if [ $? -eq 0 ]; then
  echo "容器 $CONTAINER_NAME 启动成功！"
else
  echo "容器启动失败！请检查错误日志。"
  exit 1
fi

# 输出容器的状态
docker ps -f name=$CONTAINER_NAME

echo "Flask 容器已成功构建并启动！"

# 结束脚本
exit 0
