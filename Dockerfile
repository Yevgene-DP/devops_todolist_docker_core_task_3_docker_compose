ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION} as builder

WORKDIR /app
COPY . .

FROM python:${PYTHON_VERSION} as run

WORKDIR /app
ENV PYTHONUNBUFFERED=1

COPY --from=builder /app .

# netcat
RUN apt-get update && \
    apt-get install -y netcat-openbsd default-mysql-client && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --upgrade pip && \
    pip install -r requirements.txt

EXPOSE 8080

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

