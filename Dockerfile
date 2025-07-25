FROM python:3.9-alpine

# 避免交互提示、缓存写入
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 安装运行所需的依赖包（Flask、requests、waitress 只需纯 Python）
RUN apk add --no-cache gcc musl-dev libffi-dev

# 设置工作目录
WORKDIR /app

# 安装依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制项目代码
COPY . .

# 可选：删除 pyc 缓存等临时文件
RUN find /app -type d -name '__pycache__' -exec rm -r {} + || true \
    && find /app -name '*.pyc' -delete || true

# 显式声明服务端口
EXPOSE 5000

# 使用 waitress 作为生产服务启动器
CMD ["waitress-serve", "--host=0.0.0.0", "--port=5000", "app:app"]
