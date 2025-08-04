#!/bin/bash

# Monitoring Stack Management Script

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_requirements() {
    print_status "Checking requirements..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_status "Requirements check passed!"
}

start_stack() {
    print_status "Starting monitoring stack..."
    docker-compose up -d
    
    print_status "Waiting for services to be ready..."
    sleep 10
    
    print_status "Monitoring stack started successfully!"
    echo
    print_status "Access URLs:"
    echo "  Grafana:      http://localhost:3000 (admin/admin)"
    echo "  Prometheus:   http://localhost:9090"
    echo "  Alertmanager: http://localhost:9093"
    echo "  Loki:         http://localhost:3100"
    echo "  Node Exporter: http://localhost:9100"
    echo "  cAdvisor:     http://localhost:8080"
}

stop_stack() {
    print_status "Stopping monitoring stack..."
    docker-compose down
    print_status "Monitoring stack stopped!"
}

restart_stack() {
    print_status "Restarting monitoring stack..."
    docker-compose restart
    print_status "Monitoring stack restarted!"
}

show_status() {
    print_status "Monitoring stack status:"
    docker-compose ps
}

show_logs() {
    if [ -n "$2" ]; then
        print_status "Showing logs for $2..."
        docker-compose logs -f "$2"
    else
        print_status "Showing logs for all services..."
        docker-compose logs -f
    fi
}

update_stack() {
    print_status "Updating monitoring stack..."
    docker-compose pull
    docker-compose up -d
    print_status "Monitoring stack updated!"
}

cleanup() {
    print_warning "This will remove all containers and data. Are you sure? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        print_status "Cleaning up monitoring stack..."
        docker-compose down -v --remove-orphans
        docker system prune -f
        print_status "Cleanup completed!"
    else
        print_status "Cleanup cancelled."
    fi
}

backup_config() {
    print_status "Creating configuration backup..."
    timestamp=$(date +%Y%m%d_%H%M%S)
    backup_dir="backup_$timestamp"
    
    mkdir -p "$backup_dir"
    cp -r config "$backup_dir/"
    cp docker-compose.yml "$backup_dir/"
    
    print_status "Configuration backed up to $backup_dir/"
}

show_help() {
    echo "Monitoring Stack Management Script"
    echo
    echo "Usage: $0 [COMMAND]"
    echo
    echo "Commands:"
    echo "  start         Start the monitoring stack"
    echo "  stop          Stop the monitoring stack"
    echo "  restart       Restart the monitoring stack"
    echo "  status        Show service status"
    echo "  logs [service] Show logs (optionally for specific service)"
    echo "  update        Update all images and restart"
    echo "  cleanup       Remove all containers and data"
    echo "  backup        Backup configuration"
    echo "  help          Show this help message"
    echo
    echo "Examples:"
    echo "  $0 start"
    echo "  $0 logs prometheus"
    echo "  $0 status"
}

main() {
    case "${1:-}" in
        start)
            check_requirements
            start_stack
            ;;
        stop)
            stop_stack
            ;;
        restart)
            restart_stack
            ;;
        status)
            show_status
            ;;
        logs)
            show_logs "$@"
            ;;
        update)
            update_stack
            ;;
        cleanup)
            cleanup
            ;;
        backup)
            backup_config
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: ${1:-}"
            echo
            show_help
            exit 1
            ;;
    esac
}

main "$@"
