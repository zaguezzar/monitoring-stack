#!/usr/bin/env python3
"""
Sample application with Prometheus metrics endpoint
This demonstrates how to expose custom metrics for monitoring
"""

import time
import random
from prometheus_client import Counter, Histogram, Gauge, start_http_server
import threading

# Define metrics
REQUEST_COUNT = Counter('app_requests_total', 'Total app requests', ['method', 'endpoint'])
REQUEST_LATENCY = Histogram('app_request_duration_seconds', 'Request latency')
ACTIVE_USERS = Gauge('app_active_users', 'Number of active users')
ERROR_COUNT = Counter('app_errors_total', 'Total app errors', ['error_type'])

def simulate_app_activity():
    """Simulate application activity to generate metrics"""
    endpoints = ['/api/users', '/api/orders', '/api/products', '/health']
    methods = ['GET', 'POST', 'PUT', 'DELETE']
    error_types = ['timeout', 'validation', 'database', 'network']
    
    while True:
        # Simulate request
        endpoint = random.choice(endpoints)
        method = random.choice(methods)
        
        # Track request
        REQUEST_COUNT.labels(method=method, endpoint=endpoint).inc()
        
        # Simulate request latency
        latency = random.uniform(0.01, 2.0)
        REQUEST_LATENCY.observe(latency)
        
        # Simulate active users (fluctuating between 10-100)
        active_users = random.randint(10, 100)
        ACTIVE_USERS.set(active_users)
        
        # Simulate occasional errors (5% chance)
        if random.random() < 0.05:
            error_type = random.choice(error_types)
            ERROR_COUNT.labels(error_type=error_type).inc()
        
        # Wait before next simulation
        time.sleep(random.uniform(0.1, 1.0))

if __name__ == '__main__':
    print("Starting sample application with metrics...")
    print("Metrics available at: http://localhost:8000/metrics")
    
    # Start metrics server
    start_http_server(8000)
    
    # Start simulating activity in background
    activity_thread = threading.Thread(target=simulate_app_activity, daemon=True)
    activity_thread.start()
    
    try:
        # Keep main thread alive
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\nShutting down sample application...")
