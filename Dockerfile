# 使用官方 Python 运行时作为镜像
FROM python:3.12.5

# 设置工作目录为 /app
# 这条指令会在容器内创建 /app 目录（如果不存在的话），并将接下来的 COPY 和 CMD 指令的路径相对于此目录
WORKDIR /app

# 将整个当前目录的内容复制到容器的 /app 目录中
# 这个指令会将宿主机中 Dockerfile 所在的目录下的所有文件和文件夹（包括子文件夹）复制到容器的 /app 目录
COPY . /app

# 将 requirements.txt 文件单独复制到容器的 /app 目录
COPY requirements.txt /app

# 更新 pip，并安装依赖项
# 使用 Tsinghua 镜像源（国内镜像）来加速安装过程，避免因为网络问题造成的下载失败
RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip

# 使用 Tsinghua 镜像源（国内镜像）安装依赖项
# -r requirements.txt 会安装 requirements.txt 文件中列出的所有依赖包
RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt

# EXPOSE 指令告知 Docker 容器会监听 5000 端口
# 这里使用的是 5000 端口，你可以根据需要修改为其他端口。注意，这个指令只是声明，不会自动开放端口
EXPOSE 5000

# 当容器启动时，使用 Python 执行 app.py
# CMD 指令指定容器启动时的默认命令，这里使用的是 python -m app 来运行 app.py 文件
CMD ["python", "-m", "app"]
