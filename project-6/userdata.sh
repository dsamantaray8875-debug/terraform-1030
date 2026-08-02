#!/bin/bash

# Update system
yum update -y

# Install Docker (Amazon Linux 2023)
yum install docker -y

# Start Docker
systemctl enable docker
systemctl start docker

# Create Docker network
docker network create monitoring

# Create Prometheus directory
mkdir -p /opt/prometheus

# Create Prometheus configuration file
cat <<EOF > /opt/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "node-exporter"
    static_configs:
      - targets:
          - "localhost:9100"

  - job_name: "application-server"
    static_configs:
      - targets:
          - "10.0.1.10:9100"
          - "10.0.2.10:9100"
EOF

# Run Prometheus
docker run -d \
  --name prometheus \
  --network monitoring \
  -p 9090:9090 \
  -v /opt/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus

# Run Grafana
docker run -d \
  --name grafana \
  --network monitoring \
  -p 3000:3000 \
  grafana/grafana

# Run Node Exporter
docker run -d \
  --name node-exporter \
  --network monitoring \
  -p 9100:9100 \
  prom/node-exporter