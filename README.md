# Custom Monitoring Stack

A comprehensive monitoring solution using Prometheus, Grafana, Loki, and Alertmanager for monitoring system services and containerized applications.

## Stack Components

- **Prometheus** - Metrics collection and storage
- **Grafana** - Visualization and dashboards
- **Loki** - Log aggregation
- **Alertmanager** - Alert routing and notifications
- **Node Exporter** - System metrics collection
- **cAdvisor** - Container metrics collection
- **Promtail** - Log shipping to Loki

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- At least 4GB RAM available
- Ports 3000, 3100, 8080, 9090, 9093, 9100 available

### Start the Stack

```bash
# Clone or navigate to the project directory
cd monitoring-stack

# Start all services
docker-compose up -d

# Check service status
docker-compose ps
```

### Access the Services

- **Grafana**: http://localhost:3000
- **Prometheus**: http://localhost:9090
- **Alertmanager**: http://localhost:9093
- **Loki**: http://localhost:3100
- **Node Exporter**: http://localhost:9100
- **cAdvisor**: http://localhost:8080

## Pre-configured Dashboards

1. **System Monitoring Dashboard** - CPU, Memory, Disk, Network metrics
2. **Container Monitoring Dashboard** - Docker container metrics and logs

## Alert Rules

The following alerts are pre-configured:

- **InstanceDown**: Service is down for more than 1 minute
- **HighCpuUsage**: CPU usage > 80% for 5 minutes
- **HighMemoryUsage**: Memory usage > 80% for 5 minutes
- **HighDiskUsage**: Disk usage > 80% for 5 minutes
- **ContainerDown**: Container is down for more than 1 minute
- **ContainerHighCpuUsage**: Container CPU > 80% for 5 minutes
- **ContainerHighMemoryUsage**: Container memory > 80% for 5 minutes

## Configuration

### Adding Custom Applications

1. **Add metrics endpoint to Prometheus**:
   Edit `config/prometheus/prometheus.yml` and add your service:
   ```yaml
   - job_name: 'my-app'
     static_configs:
       - targets: ['my-app:port']
   ```

2. **Add application logs to Promtail**:
   Edit `config/promtail/promtail.yml` and add your log path:
   ```yaml
   - job_name: my-app
     static_configs:
       - targets:
           - localhost
         labels:
           job: my-app
           __path__: /path/to/your/app/logs/*.log
           host: monitoring-host
   ```

### Setting up Email Alerts

1. Edit `config/alertmanager/alertmanager.yml`
2. Configure SMTP settings in the global section
3. Uncomment and configure the email receiver
4. Update the route to use the email receiver

### Setting up Slack Alerts

1. Create a Slack webhook URL
2. Edit `config/alertmanager/alertmanager.yml`
3. Uncomment and configure the Slack receiver
4. Update the route to use the Slack receiver

## Log Retention

- **Prometheus**: 168 hours (7 days) by default
- **Loki**: Configured for long-term storage
- **Grafana**: Persistent storage for dashboards and settings

## Scaling and Production

### For Production Use:

1. **Change default passwords**:
   - Update Grafana admin password in .env
   - Set up proper authentication

2. **Configure external storage**:
   - Use external volumes for data persistence
   - Consider S3 or similar for long-term storage

3. **Set up proper networking**:
   - Use reverse proxy (nginx/traefik)
   - Enable HTTPS/TLS

4. **Configure backup**:
   - Backup Grafana dashboards and configurations
   - Backup Prometheus data if needed

### Monitoring Multiple Hosts

1. Deploy Node Exporter on each host
2. Update Prometheus configuration with all target hosts
3. Configure Promtail on each host to ship logs

## Troubleshooting

### Common Issues

1. **Services not starting**:
   ```bash
   docker-compose logs [service-name]
   ```

2. **No metrics appearing**:
   - Check if targets are up in Prometheus UI
   - Verify network connectivity between services

3. **No logs in Grafana**:
   - Check Promtail is running and configured correctly
   - Verify Loki datasource is configured in Grafana

4. **Alerts not firing**:
   - Check alert rules in Prometheus UI
   - Verify Alertmanager configuration

### Useful Commands

```bash
# View logs for all services
docker-compose logs -f

# Restart a specific service
docker-compose restart [service-name]

# Stop all services
docker-compose down

# Remove all data (be careful, volumes will be gone)
docker-compose down -v

# Update and restart
docker-compose pull && docker-compose up -d
```

## Monitoring Best Practices

1. **Set appropriate alert thresholds** based on your environment
2. **Use labels** to organize metrics and logs effectively
3. **Create custom dashboards** for your specific applications
4. **Regularly review and tune** alert rules to reduce noise
5. **Monitor the monitoring stack** itself for reliability

## Custom Metrics

To expose custom metrics from your applications:

### Python Example
```python
from prometheus_client import Counter, Histogram, start_http_server

REQUEST_COUNT = Counter('app_requests_total', 'Total app requests')
REQUEST_LATENCY = Histogram('app_request_duration_seconds', 'Request latency')

# Start metrics server
start_http_server(8000)
```

### Node.js Example
```javascript
const client = require('prom-client');
const register = new client.Registry();

const httpRequestsTotal = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code']
});

register.registerMetric(httpRequestsTotal);
```

## Security Considerations

1. **Network isolation**: Use Docker networks to isolate services
2. **Access control**: Implement proper authentication and authorization
3. **Data encryption**: Use TLS for data in transit
4. **Secret management**: Don't store secrets in plain text
5. **Regular updates**: Keep all components updated

## Support

For issues and questions:
1. Check the logs using `docker-compose logs`
2. Review the configuration files
3. Consult the official documentation for each component

