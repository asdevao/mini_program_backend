'''
Author: asdevao 1097802349@qq.com
Date: 2024-10-25 16:02:16
LastEditors: asdevao 1097802349@qq.com
LastEditTime: 2025-01-05 22:00:07
FilePath: \apps\settings.py
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
'''
from os import getenv as getenv_
from dotenv import load_dotenv
from returns.maybe import maybe
import os

# 加载 .env 文件
load_dotenv()

# 使用 maybe 来封装 getenv
getenv = maybe(getenv_)

# 数据库配置
HOSTNAME = "mysql"
PORT = "3306"
DATABASE = "mini_program"
USERNAME = "root"
PASSWORD = "123456"
DB_URI = 'mysql+pymysql://{}:{}@{}:{}/{}'.format(USERNAME, PASSWORD, HOSTNAME, PORT, DATABASE)

# 邮箱配置
MAIL_SERVER = "smtp.qq.com"
MAIL_PORT = 465  # 使用 SSL 端口
MAIL_USE_TLS = False  # 不使用 STARTTLS
MAIL_USE_SSL = True  # 使用 SSL
MAIL_USERNAME = "1097802349@qq.com"
MAIL_PASSWORD = "lrnzfzhewjnlidjd"
MAIL_DEFAULT_SENDER = "1097802349@qq.com"
# Redis 配置
REDIS_URL = getenv("REDIS_URL").value_or("redis://localhost:6379/0")

# Celery 配置
CELERY_BROKER_URL = getenv("CELERY_BROKER_URL").value_or("redis://localhost:6379/0")
CELERY_RESULT_BACKEND = getenv("CELERY_RESULT_BACKEND").value_or("redis://localhost:6379/0")

# 其他配置
SECRET_KEY = "sdfsadfskrwerfj1233453345"
SESSION_COOKIE_NAME = "flask_session"
JSON_AS_ASCII = False


# 读取 SQLAlchemy 配置
SQLALCHEMY_DATABASE_URI = DB_URI
SQLALCHEMY_TRACK_MODIFICATIONS = False  # 禁用对象修改追踪，避免性能损失

# 输出配置（可选，用于调试）
print("DB_URI:", DB_URI)
print("MAIL_SERVER:", MAIL_SERVER)
