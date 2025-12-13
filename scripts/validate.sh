#!/bin/bash
# Infrastructure Validation Script

echo "🔍 Validando Infraestrutura do Projeto Anka MFO"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counter
CHECKS_PASSED=0
CHECKS_FAILED=0

# Helper function
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $1${NC}"
        ((CHECKS_PASSED++))
    else
        echo -e "${RED}❌ $1${NC}"
        ((CHECKS_FAILED++))
    fi
}

echo "1️⃣  Verificando dependências..."
echo ""

# Check Docker
echo -n "   Docker: "
docker --version > /dev/null 2>&1
check_status "Docker instalado"

# Check Docker Compose
echo -n "   Docker Compose: "
docker compose --version > /dev/null 2>&1
check_status "Docker Compose instalado"

# Check Make
echo -n "   Make: "
make --version > /dev/null 2>&1
check_status "Make instalado"

echo ""
echo "2️⃣  Validando estrutura de diretórios..."
echo ""

# Check directories
DIRS=("backend" "frontend" "database" "backend/src" "backend/src/domain" "backend/src/application" "backend/src/infra")

for dir in "${DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✅ Diretório: $dir${NC}"
        ((CHECKS_PASSED++))
    else
        echo -e "${RED}❌ Diretório ausente: $dir${NC}"
        ((CHECKS_FAILED++))
    fi
done

echo ""
echo "3️⃣  Validando arquivos de configuração..."
echo ""

# Check files
FILES=("docker-compose.yml" ".env.example" "Makefile" "backend/Dockerfile" "frontend/Dockerfile" "database/01-schema.sql" "database/02-seed.sql")

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ Arquivo: $file${NC}"
        ((CHECKS_PASSED++))
    else
        echo -e "${RED}❌ Arquivo ausente: $file${NC}"
        ((CHECKS_FAILED++))
    fi
done

echo ""
echo "4️⃣  Validando YAML/SQL..."
echo ""

# Validate docker-compose.yml
echo -n "   docker-compose.yml: "
docker compose config > /dev/null 2>&1
check_status "Sintaxe válida"

echo ""
echo "5️⃣  Status dos Containers..."
echo ""

# Check if containers are running
echo -n "   Containers em execução: "
RUNNING=$(docker compose ps -q 2>/dev/null | wc -l)
if [ "$RUNNING" -gt 0 ]; then
    echo -e "${GREEN}✅ $RUNNING containers rodando${NC}"
    ((CHECKS_PASSED++))
else
    echo -e "${YELLOW}⚠️  Nenhum container rodando (normal se não foi iniciado ainda)${NC}"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 Resumo da Validação:"
echo -e "   ${GREEN}✅ Aprovados: $CHECKS_PASSED${NC}"
if [ "$CHECKS_FAILED" -gt 0 ]; then
    echo -e "   ${RED}❌ Falhas: $CHECKS_FAILED${NC}"
else
    echo -e "   ${RED}❌ Falhas: 0${NC}"
fi

echo ""
echo "📚 Próximos passos:"
echo "   1. Copiar .env.example para .env (ajustar valores se necessário)"
echo "   2. Executar 'make dev' para iniciar os serviços"
echo "   3. Acessar:"
echo "      - Frontend: http://localhost:3000"
echo "      - Backend: http://localhost:3333"
echo "      - Database: localhost:5432"
echo ""

if [ "$CHECKS_FAILED" -eq 0 ]; then
    echo -e "${GREEN}✨ Infraestrutura validada com sucesso!${NC}"
    exit 0
else
    echo -e "${RED}⚠️  Existem erros na validação${NC}"
    exit 1
fi
