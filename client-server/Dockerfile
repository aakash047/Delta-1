# Dockerfile for server
FROM python:3.9-slim

WORKDIR /app

COPY server.py /app
COPY requirements.txt /app
COPY wait-for-it.sh /app

RUN pip install --no-cache-dir -r requirements.txt
RUN chmod +x /app/wait-for-it.sh

CMD ["./wait-for-it.sh", "mysql:3306", "--", "python", "server.py"]
