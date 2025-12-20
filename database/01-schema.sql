-- Create ENUM types
CREATE TYPE status_de_vida AS ENUM ('vivo', 'falecido', 'incapacidade');
CREATE TYPE tipo_alocacao AS ENUM ('financeira', 'imovel');
CREATE TYPE tipo_movimentacao AS ENUM ('aporte', 'resgate', 'rendimento', 'taxa');
CREATE TYPE status_simulacao AS ENUM ('rascunho', 'ativa', 'arquivada');

-- Clients table
CREATE TABLE IF NOT EXISTS clients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  cpf VARCHAR(14) UNIQUE,
  phone VARCHAR(20),
  birthdate DATE,
  status status_de_vida DEFAULT 'vivo',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Simulations table
CREATE TABLE IF NOT EXISTS simulations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  status status_simulacao DEFAULT 'rascunho',
  initial_capital DECIMAL(15, 2) NOT NULL,
  monthly_contribution DECIMAL(15, 2) DEFAULT 0,
  inflation_rate DECIMAL(5, 2) DEFAULT 3.5,
  years_projection INT DEFAULT 20,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Allocations table (Alocações)
CREATE TABLE IF NOT EXISTS allocations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  simulation_id UUID NOT NULL REFERENCES simulations(id) ON DELETE CASCADE,
  type tipo_alocacao NOT NULL,
  description VARCHAR(255) NOT NULL,
  percentage DECIMAL(5, 2) NOT NULL,
  initial_value DECIMAL(15, 2) NOT NULL,
  annual_return DECIMAL(5, 2) NOT NULL DEFAULT 0,
  allocation_date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Transactions table (Movimentações)
CREATE TABLE IF NOT EXISTS transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  allocation_id UUID NOT NULL REFERENCES allocations(id) ON DELETE CASCADE,
  type tipo_movimentacao NOT NULL,
  amount DECIMAL(15, 2) NOT NULL,
  description TEXT,
  transaction_date DATE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Insurances table (Seguros)
CREATE TABLE IF NOT EXISTS insurances (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  simulation_id UUID NOT NULL REFERENCES simulations(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL,
  description TEXT,
  coverage_amount DECIMAL(15, 2) NOT NULL,
  monthly_cost DECIMAL(10, 2) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Simulation versions table (for tracking history)
CREATE TABLE IF NOT EXISTS simulation_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  simulation_id UUID NOT NULL REFERENCES simulations(id) ON DELETE CASCADE,
  version_number INT NOT NULL,
  snapshot JSONB NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better query performance
CREATE INDEX idx_clients_email ON clients(email);
CREATE INDEX idx_clients_cpf ON clients(cpf);
CREATE INDEX idx_simulations_client_id ON simulations(client_id);
CREATE INDEX idx_simulations_status ON simulations(status);
CREATE INDEX idx_allocations_simulation_id ON allocations(simulation_id);
CREATE INDEX idx_transactions_allocation_id ON transactions(allocation_id);
CREATE INDEX idx_insurances_simulation_id ON insurances(simulation_id);
CREATE INDEX idx_simulation_versions_simulation_id ON simulation_versions(simulation_id);

-- Create users table for authentication (Phase 8)
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'assessor',
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
