# Quick Start Guide

## 1. Basic Setup (5 minutes)

```bash
# Start the monitoring stack
./monitor.sh start

# Check status
./monitor.sh status
```

Access Grafana at http://localhost:3000 (admin/admin)

## 2. With Sample Application (10 minutes)

```bash
# Start with sample app for testing
docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d

# Install Python dependencies for local testing
cd examples
pip install -r requirements.txt
python sample-app.py
```

## 3. Key URLs

- **Grafana**: http://localhost:3000 (dashboards)
- **Prometheus**: http://localhost:9090 (metrics)
- **Alertmanager**: http://localhost:9093 (alerts)
- **Sample App Metrics**: http://localhost:8000/metrics

## 4. Default Dashboards

1. **System Monitoring** - CPU, Memory, Disk, Network
2. **Container Monitoring** - Docker containers and logs

## 5. Common Tasks

### View Logs
```bash
./monitor.sh logs                # All services
./monitor.sh logs prometheus     # Specific service
```

### Add Your Application
1. Edit `config/prometheus/prometheus.yml`
2. Add your service endpoint
3. Restart: `./monitor.sh restart`

### Set up Alerts
1. Edit `config/alertmanager/alertmanager.yml`
2. Configure email/Slack webhook
3. Restart Alertmanager

## 6. Troubleshooting

- **No data in Grafana**: Check Prometheus targets at http://localhost:9090/targets
- **Services won't start**: Check logs with `./monitor.sh logs`
- **High resource usage**: Adjust retention settings in Prometheus config

## 7. Next Steps

1. Configure real alerting (email/Slack)
2. Add your applications to monitoring
3. Create custom dashboards
4. Set up log forwarding from your apps
5. Configure backup for important data

Ready to monitor! 🚀
