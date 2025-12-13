-- Seed data for testing

-- Insert test client
INSERT INTO clients (id, name, email, cpf, phone, birthdate, status) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'João Silva', 'joao@example.com', '12345678901', '11999999999', '1980-05-15', 'vivo'),
('550e8400-e29b-41d4-a716-446655440002', 'Maria Santos', 'maria@example.com', '12345678902', '11988888888', '1975-10-22', 'vivo');

-- Insert simulations
INSERT INTO simulations (id, client_id, name, description, status, initial_capital, monthly_contribution, inflation_rate, years_projection) VALUES
('550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440001', 'Projeção Conservadora', 'Simulação com alocação conservadora', 'ativa', 100000.00, 2000.00, 3.5, 20),
('550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440001', 'Projeção Agressiva', 'Simulação com alocação agressiva', 'rascunho', 100000.00, 3000.00, 3.5, 20);

-- Insert allocations for first simulation (Conservadora)
INSERT INTO allocations (id, simulation_id, type, description, percentage, initial_value, annual_return) VALUES
('550e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440010', 'financeira', 'Renda Fixa - CDB', 60.00, 60000.00, 8.5),
('550e8400-e29b-41d4-a716-446655440021', '550e8400-e29b-41d4-a716-446655440010', 'financeira', 'Ações', 25.00, 25000.00, 12.0),
('550e8400-e29b-41d4-a716-446655440022', '550e8400-e29b-41d4-a716-446655440010', 'imovel', 'Imóvel Residencial', 15.00, 15000.00, 6.5);

-- Insert allocations for second simulation (Agressiva)
INSERT INTO allocations (id, simulation_id, type, description, percentage, initial_value, annual_return) VALUES
('550e8400-e29b-41d4-a716-446655440030', '550e8400-e29b-41d4-a716-446655440011', 'financeira', 'Ações Nacionais', 50.00, 50000.00, 14.0),
('550e8400-e29b-41d4-a716-446655440031', '550e8400-e29b-41d4-a716-446655440011', 'financeira', 'Fundos Imobiliários', 30.00, 30000.00, 10.0),
('550e8400-e29b-41d4-a716-446655440032', '550e8400-e29b-41d4-a716-446655440011', 'imovel', 'Imóvel Comercial', 20.00, 20000.00, 8.0);

-- Insert sample transactions
INSERT INTO transactions (id, allocation_id, type, amount, description, transaction_date) VALUES
('550e8400-e29b-41d4-a716-446655440040', '550e8400-e29b-41d4-a716-446655440020', 'aporte', 10000.00, 'Aporte inicial', '2024-01-01'),
('550e8400-e29b-41d4-a716-446655440041', '550e8400-e29b-41d4-a716-446655440020', 'rendimento', 500.00, 'Rendimento mensal', '2024-01-31'),
('550e8400-e29b-41d4-a716-446655440042', '550e8400-e29b-41d4-a716-446655440021', 'aporte', 5000.00, 'Aporte em ações', '2024-01-15'),
('550e8400-e29b-41d4-a716-446655440043', '550e8400-e29b-41d4-a716-446655440021', 'taxa', 50.00, 'Taxa de corretagem', '2024-01-15');

-- Insert insurances
INSERT INTO insurances (id, simulation_id, type, description, coverage_amount, monthly_cost, start_date, end_date) VALUES
('550e8400-e29b-41d4-a716-446655440050', '550e8400-e29b-41d4-a716-446655440010', 'Seguro de Vida', 'Cobertura em caso de falecimento', 500000.00, 150.00, '2023-01-01', NULL),
('550e8400-e29b-41d4-a716-446655440051', '550e8400-e29b-41d4-a716-446655440010', 'Invalidez Permanente', 'Cobertura por incapacidade', 300000.00, 100.00, '2023-01-01', NULL),
('550e8400-e29b-41d4-a716-446655440052', '550e8400-e29b-41d4-a716-446655440011', 'Seguro de Vida', 'Cobertura em caso de falecimento', 750000.00, 200.00, '2024-01-01', NULL);

-- Insert simulation versions
INSERT INTO simulation_versions (id, simulation_id, version_number, snapshot) VALUES
('550e8400-e29b-41d4-a716-446655440060', '550e8400-e29b-41d4-a716-446655440010', 1, '{"status": "criada", "timestamp": "2024-01-01T10:00:00Z"}'),
('550e8400-e29b-41d4-a716-446655440061', '550e8400-e29b-41d4-a716-446655440010', 2, '{"status": "atualizada", "timestamp": "2024-01-15T14:30:00Z"}');
