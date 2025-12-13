.PHONY: help dev up down logs clean build test db-reset db-seed validate

# Variables
DOCKER_COMPOSE = docker-compose
PROJECT_NAME = anka

help:
	@echo "🚀 Anka MFO - Available Commands"
	@echo ""
	@echo "Development:"
	@echo "  make dev              - Start all services in development mode"
	@echo "  make up               - Start containers"
	@echo "  make down             - Stop containers"
	@echo ""
	@echo "Database:"
	@echo "  make db-reset         - Reset database (drop and recreate)"
	@echo "  make db-seed          - Run seed data script"
	@echo "  make db-shell         - Open PostgreSQL shell"
	@echo ""
	@echo "Logs & Monitoring:"
	@echo "  make logs             - View all container logs"
	@echo "  make logs-backend     - View backend logs"
	@echo "  make logs-frontend    - View frontend logs"
	@echo "  make logs-db          - View database logs"
	@echo ""
	@echo "Testing & Validation:"
	@echo "  make test             - Run all tests"
	@echo "  make test-backend     - Run backend tests"
	@echo "  make validate         - Validate infrastructure"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean            - Remove containers, volumes and cache"
	@echo "  make clean-all        - Remove everything including built images"

dev: up logs

up:
	@echo "📦 Starting containers..."
	$(DOCKER_COMPOSE) up -d
	@echo "✅ Containers started"
	@echo "🌐 Frontend: http://localhost:3000"
	@echo "📡 Backend: http://localhost:3333"
	@echo "🗄️  Database: localhost:5432"

down:
	@echo "🛑 Stopping containers..."
	$(DOCKER_COMPOSE) down
	@echo "✅ Containers stopped"

logs:
	$(DOCKER_COMPOSE) logs -f

logs-backend:
	$(DOCKER_COMPOSE) logs -f $(PROJECT_NAME)-backend

logs-frontend:
	$(DOCKER_COMPOSE) logs -f $(PROJECT_NAME)-frontend

logs-db:
	$(DOCKER_COMPOSE) logs -f $(PROJECT_NAME)-postgres

db-shell:
	$(DOCKER_COMPOSE) exec $(PROJECT_NAME)-postgres psql -U postgres -d anka

db-reset:
	@echo "🔄 Resetting database..."
	$(DOCKER_COMPOSE) down -v
	$(DOCKER_COMPOSE) up -d $(PROJECT_NAME)-postgres
	@echo "⏳ Waiting for database to be ready..."
	@sleep 10
	$(DOCKER_COMPOSE) exec -T $(PROJECT_NAME)-postgres psql -U postgres -d anka -f /docker-entrypoint-initdb.d/01-schema.sql
	$(DOCKER_COMPOSE) exec -T $(PROJECT_NAME)-postgres psql -U postgres -d anka -f /docker-entrypoint-initdb.d/02-seed.sql
	@echo "✅ Database reset complete"

db-seed:
	@echo "🌱 Seeding database..."
	$(DOCKER_COMPOSE) exec $(PROJECT_NAME)-postgres psql -U postgres -d anka -f /docker-entrypoint-initdb.d/02-seed.sql
	@echo "✅ Seed data inserted"

validate:
	@echo "✅ Validating infrastructure..."
	@echo ""
	@echo "Checking Docker..."
	@docker --version
	@echo ""
	@echo "Checking docker-compose..."
	@docker compose --version
	@echo ""
	@echo "Checking PostgreSQL connection..."
	@$(DOCKER_COMPOSE) exec -T $(PROJECT_NAME)-postgres pg_isready -U postgres || true
	@echo ""
	@echo "Checking Backend health..."
	@curl -s http://localhost:3333/health || echo "Backend not ready yet"
	@echo ""
	@echo "Checking Frontend..."
	@curl -s http://localhost:3000 > /dev/null && echo "✅ Frontend is running" || echo "Frontend not ready yet"
	@echo ""
	@echo "📋 Infrastructure validation complete"

test:
	@echo "🧪 Running tests..."
	$(DOCKER_COMPOSE) exec $(PROJECT_NAME)-backend npm run test
	@echo "✅ Tests completed"

test-backend:
	@echo "🧪 Running backend tests..."
	$(DOCKER_COMPOSE) exec $(PROJECT_NAME)-backend npm run test
	@echo "✅ Backend tests completed"

clean:
	@echo "🧹 Cleaning up containers and volumes..."
	$(DOCKER_COMPOSE) down -v
	@echo "✅ Cleanup complete"

clean-all:
	@echo "🧹 Removing all containers, volumes and images..."
	$(DOCKER_COMPOSE) down -v --rmi all
	@echo "✅ Full cleanup complete"

.DEFAULT_GOAL := help
