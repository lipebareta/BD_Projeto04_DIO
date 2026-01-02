-- ============================================
-- BANCO DE DADOS: SistemaOficina
-- ============================================

CREATE DATABASE IF NOT EXISTS SistemaOficina;
USE SistemaOficina;

-- ============================================
-- TABELA: Cliente
-- ============================================
CREATE TABLE Cliente (
    IdCliente INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Telefone VARCHAR(20),
    Email VARCHAR(100),
    Endereco VARCHAR(200)
);

-- ============================================
-- TABELA: Veiculo
-- ============================================
CREATE TABLE Veiculo (
    IdVeiculo INT PRIMARY KEY AUTO_INCREMENT,
    Placa VARCHAR(10) NOT NULL UNIQUE,
    Marca VARCHAR(45) NOT NULL,
    Modelo VARCHAR(45) NOT NULL,
    Ano INT,
    Cor VARCHAR(45),
    Cliente_idCliente INT NOT NULL,
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(IdCliente) ON DELETE CASCADE
);

-- ============================================
-- TABELA: Servico
-- ============================================
CREATE TABLE Servico (
    IdServico INT PRIMARY KEY AUTO_INCREMENT,
    Descricao VARCHAR(100) NOT NULL,
    Valor_Mao_Obra DECIMAL(10,2) NOT NULL,
    Tempo_Medio_Execucao TIME
);

-- ============================================
-- TABELA: Peca
-- ============================================
CREATE TABLE Peca (
    IdPeca INT PRIMARY KEY AUTO_INCREMENT,
    Codigo VARCHAR(20) UNIQUE NOT NULL,
    Descricao VARCHAR(100) NOT NULL,
    Valor_unitario DECIMAL(10,2) NOT NULL,
    Estoque_Quantidade INT DEFAULT 0
);

-- ============================================
-- TABELA: Mecanico
-- ============================================
CREATE TABLE Mecanico (
    IdMecanico INT PRIMARY KEY AUTO_INCREMENT,
    Codigo VARCHAR(20) UNIQUE NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Especialidade VARCHAR(100)
);

-- ============================================
-- TABELA: Equipe
-- ============================================
CREATE TABLE Equipe (
    IdEquipe INT PRIMARY KEY AUTO_INCREMENT,
    Nome_Equipe VARCHAR(45) NOT NULL,
    Especialidade_Principal VARCHAR(100)
);

-- ============================================
-- TABELA: Mecanico_Equipe (Tabela de junção)
-- ============================================
CREATE TABLE Mecanico_Equipe (
    Mecanico_IdMecanico INT,
    Equipe_IdEquipe INT,
    PRIMARY KEY (Mecanico_IdMecanico, Equipe_IdEquipe),
    FOREIGN KEY (Mecanico_IdMecanico) REFERENCES Mecanico(IdMecanico) ON DELETE CASCADE,
    FOREIGN KEY (Equipe_IdEquipe) REFERENCES Equipe(IdEquipe) ON DELETE CASCADE
);

-- ============================================
-- TABELA: Ordem_Servico
-- ============================================
CREATE TABLE Ordem_Servico (
    IdOrdem_Servico INT PRIMARY KEY AUTO_INCREMENT,
    Numero_OS VARCHAR(20) UNIQUE NOT NULL,
    Data_emissao DATE NOT NULL,
    Data_Conclusao_prevista DATE,
    Data_conclusao_real DATE,
    Status VARCHAR(45) DEFAULT 'Aberto',
    Valor_total DECIMAL(10,2) DEFAULT 0.00,
    Autorizacao_cliente BOOLEAN DEFAULT FALSE,
    Veiculo_IdVeiculo INT NOT NULL,
    Equipe_IdEquipe INT,
    FOREIGN KEY (Veiculo_IdVeiculo) REFERENCES Veiculo(IdVeiculo) ON DELETE CASCADE,
    FOREIGN KEY (Equipe_IdEquipe) REFERENCES Equipe(IdEquipe)
);

-- ============================================
-- TABELA: Servico_Ordem (Tabela de junção)
-- ============================================
CREATE TABLE Servico_Ordem (
    Servico_IdServico INT,
    Ordem_Servico_IdOrdem_Servico INT,
    Quantidade INT DEFAULT 1,
    Valor_Unitario DECIMAL(10,2),
    Subtotal DECIMAL(10,2),
    PRIMARY KEY (Servico_IdServico, Ordem_Servico_IdOrdem_Servico),
    FOREIGN KEY (Servico_IdServico) REFERENCES Servico(IdServico) ON DELETE CASCADE,
    FOREIGN KEY (Ordem_Servico_IdOrdem_Servico) REFERENCES Ordem_Servico(IdOrdem_Servico) ON DELETE CASCADE
);

-- ============================================
-- TABELA: Peca_Ordem (Tabela de junção)
-- ============================================
CREATE TABLE Peca_Ordem (
    Peca_IdPeca INT,
    Ordem_Servico_IdOrdem_Servico INT,
    Quantidade INT DEFAULT 1,
    Valor_Unitario DECIMAL(10,2),
    Subtotal DECIMAL(10,2),
    PRIMARY KEY (Peca_IdPeca, Ordem_Servico_IdOrdem_Servico),
    FOREIGN KEY (Peca_IdPeca) REFERENCES Peca(IdPeca) ON DELETE CASCADE,
    FOREIGN KEY (Ordem_Servico_IdOrdem_Servico) REFERENCES Ordem_Servico(IdOrdem_Servico) ON DELETE CASCADE
);

-- ============================================
-- TABELA: Tabela_Referencia (se necessário)
-- ============================================
CREATE TABLE Tabela_Referencia (
    IdTabela_Referencia INT PRIMARY KEY AUTO_INCREMENT,
    Descricao VARCHAR(100),
    Valor_Referencia DECIMAL(10,2)
);



-- ============================================
-- INSERIR DADOS DE EXEMPLO
-- ============================================

-- 1. Clientes
INSERT INTO Cliente (Nome, Telefone, Email, Endereco) VALUES
('Carlos Silva', '(11) 99988-7766', 'carlos.silva@email.com', 'Rua das Flores, 123 - São Paulo/SP'),
('Maria Santos', '(21) 98877-6655', 'maria.santos@email.com', 'Av. Brasil, 456 - Rio de Janeiro/RJ'),
('João Oliveira', '(31) 97766-5544', 'joao.oliveira@email.com', 'Rua das Palmeiras, 789 - Belo Horizonte/MG'),
('Ana Pereira', '(41) 96655-4433', 'ana.pereira@email.com', 'Av. Paraná, 101 - Curitiba/PR'),
('Pedro Costa', '(51) 95544-3322', 'pedro.costa@email.com', 'Rua dos Andradas, 202 - Porto Alegre/RS');

-- 2. Veículos
INSERT INTO Veiculo (Placa, Marca, Modelo, Ano, Cor, Cliente_idCliente) VALUES
('ABC1D23', 'Volkswagen', 'Golf', 2020, 'Preto', 1),
('XYZ9A87', 'Toyota', 'Corolla', 2022, 'Prata', 2),
('DEF2G45', 'Ford', 'Ranger', 2021, 'Branco', 3),
('HIJ3K67', 'Chevrolet', 'Onix', 2023, 'Vermelho', 4),
('LMN4O89', 'Fiat', 'Uno', 2019, 'Azul', 5),
('PQR5S01', 'Honda', 'Civic', 2020, 'Cinza', 1),
('STU6T23', 'Hyundai', 'HB20', 2022, 'Branco', 2);

-- 3. Serviços
INSERT INTO Servico (Descricao, Valor_Mao_Obra, Tempo_Medio_Execucao) VALUES
('Troca de óleo', 80.00, '00:30:00'),
('Alinhamento e balanceamento', 120.00, '01:00:00'),
('Troca de pastilhas de freio', 150.00, '01:30:00'),
('Revisão completa', 300.00, '03:00:00'),
('Troca de pneus', 100.00, '00:45:00'),
('Diagnóstico eletrônico', 90.00, '00:30:00'),
('Troca de bateria', 60.00, '00:20:00'),
('Limpeza de bicos injetores', 200.00, '02:00:00');

-- 4. Peças
INSERT INTO Peca (Codigo, Descricao, Valor_unitario, Estoque_Quantidade) VALUES
('P001', 'Óleo sintético 5W30 1L', 45.00, 50),
('P002', 'Filtro de óleo', 25.00, 30),
('P003', 'Pastilha de freio dianteira', 120.00, 40),
('P004', 'Pneu 205/55R16', 350.00, 25),
('P005', 'Bateria 60Ah', 280.00, 15),
('P006', 'Filtro de ar', 40.00, 35),
('P007', 'Velas de ignição', 25.00, 60),
('P008', 'Correia dentada', 150.00, 20),
('P009', 'Lâmpada farol H7', 35.00, 45),
('P010', 'Fluido de freio DOT4', 30.00, 40);

-- 5. Mecânicos
INSERT INTO Mecanico (Codigo, Nome, Especialidade) VALUES
('MEC001', 'Roberto Alves', 'Motor e transmissão'),
('MEC002', 'Fernando Lima', 'Suspensão e direção'),
('MEC003', 'Ana Costa', 'Freios e pneus'),
('MEC004', 'Marcos Santos', 'Elétrica automotiva'),
('MEC005', 'Juliana Pereira', 'Injeção eletrônica'),
('MEC006', 'Ricardo Gomes', 'Ar condicionado');

-- 6. Equipes
INSERT INTO Equipe (Nome_Equipe, Especialidade_Principal) VALUES
('Equipe Alfa', 'Revisões preventivas'),
('Equipe Beta', 'Reparos mecânicos'),
('Equipe Gama', 'Sistema elétrico'),
('Equipe Delta', 'Suspensão e pneus');

-- 7. Mecânicos nas Equipes
INSERT INTO Mecanico_Equipe (Mecanico_IdMecanico, Equipe_IdEquipe) VALUES
(1, 1), (2, 1),  -- Roberto e Fernando na Equipe Alfa
(3, 2), (4, 2),  -- Ana e Marcos na Equipe Beta
(5, 3),          -- Juliana na Equipe Gama
(6, 4);          -- Ricardo na Equipe Delta

-- 8. Ordens de Serviço
INSERT INTO Ordem_Servico (Numero_OS, Data_emissao, Data_Conclusao_prevista, Status, Autorizacao_cliente, Veiculo_IdVeiculo, Equipe_IdEquipe) VALUES
('OS2024001', '2024-03-01', '2024-03-02', 'Concluído', TRUE, 1, 1),
('OS2024002', '2024-03-05', '2024-03-06', 'Em andamento', TRUE, 2, 2),
('OS2024003', '2024-03-10', '2024-03-11', 'Aguardando peças', TRUE, 3, 3),
('OS2024004', '2024-03-12', '2024-03-13', 'Aberto', FALSE, 4, 1),
('OS2024005', '2024-03-15', '2024-03-16', 'Concluído', TRUE, 5, 4),
('OS2024006', '2024-03-18', '2024-03-19', 'Em andamento', TRUE, 6, 2);

-- Atualizar algumas datas de conclusão real
UPDATE Ordem_Servico SET 
    Data_conclusao_real = '2024-03-02',
    Valor_total = 250.00
WHERE Numero_OS = 'OS2024001';

UPDATE Ordem_Servico SET 
    Data_conclusao_real = '2024-03-16',
    Valor_total = 180.00
WHERE Numero_OS = 'OS2024005';

-- 9. Serviços nas Ordens (com subtotal)
INSERT INTO Servico_Ordem (Servico_IdServico, Ordem_Servico_IdOrdem_Servico, Quantidade, Valor_Unitario, Subtotal) VALUES
(1, 1, 1, 80.00, 80.00),   -- Troca de óleo na OS1
(3, 2, 1, 150.00, 150.00), -- Pastilhas na OS2
(2, 3, 1, 120.00, 120.00), -- Alinhamento na OS3
(4, 4, 1, 300.00, 300.00), -- Revisão na OS4
(5, 5, 1, 100.00, 100.00), -- Pneus na OS5
(6, 6, 1, 90.00, 90.00);   -- Diagnóstico na OS6

-- 10. Peças nas Ordens (com subtotal)
INSERT INTO Peca_Ordem (Peca_IdPeca, Ordem_Servico_IdOrdem_Servico, Quantidade, Valor_Unitario, Subtotal) VALUES
(1, 1, 5, 45.00, 225.00),   -- 5L de óleo na OS1
(2, 1, 1, 25.00, 25.00),    -- Filtro na OS1
(3, 2, 4, 120.00, 480.00),  -- 4 pastilhas na OS2
(4, 3, 4, 350.00, 1400.00), -- 4 pneus na OS3
(6, 4, 1, 40.00, 40.00),    -- Filtro de ar na OS4
(9, 5, 2, 35.00, 70.00);    -- 2 lâmpadas na OS5

-- 11. Tabela Referência (exemplo)
INSERT INTO Tabela_Referencia (Descricao, Valor_Referencia) VALUES
('Hora técnica especializada', 120.00),
('Hora técnica básica', 80.00),
('Deslocamento urgente', 50.00),
('Lavagem básica', 30.00);




-- 1. Quantas ordens de serviço cada cliente tem?
SELECT 
    c.Nome AS Cliente,
    COUNT(os.IdOrdem_Servico) AS Total_Ordens,
    SUM(os.Valor_total) AS Total_Gasto
FROM Cliente c
LEFT JOIN Veiculo v ON c.IdCliente = v.Cliente_idCliente
LEFT JOIN Ordem_Servico os ON v.IdVeiculo = os.Veiculo_IdVeiculo
GROUP BY c.IdCliente, c.Nome
ORDER BY Total_Ordens DESC;

-- 2. Quais serviços são mais solicitados?
SELECT 
    s.Descricao AS Servico,
    COUNT(so.Servico_IdServico) AS Quantidade_Solicitada,
    SUM(so.Subtotal) AS Faturamento_Total
FROM Servico s
LEFT JOIN Servico_Ordem so ON s.IdServico = so.Servico_IdServico
GROUP BY s.IdServico, s.Descricao
ORDER BY Quantidade_Solicitada DESC;

-- 3. Peças com estoque baixo (abaixo de 10 unidades)
SELECT 
    Codigo,
    Descricao,
    Estoque_Quantidade AS Estoque_Atual,
    Valor_unitario,
    CASE 
        WHEN Estoque_Quantidade < 5 THEN 'CRÍTICO'
        WHEN Estoque_Quantidade < 10 THEN 'BAIXO'
        ELSE 'OK'
    END AS Status_Estoque
FROM Peca
WHERE Estoque_Quantidade < 10
ORDER BY Estoque_Quantidade ASC;

-- 4. Ordens por status e tempo de espera
SELECT 
    os.Numero_OS,
    v.Placa,
    v.Marca,
    v.Modelo,
    os.Status,
    os.Data_emissao,
    DATEDIFF(CURDATE(), os.Data_emissao) AS Dias_Aberto,
    os.Valor_total
FROM Ordem_Servico os
JOIN Veiculo v ON os.Veiculo_IdVeiculo = v.IdVeiculo
WHERE os.Status NOT IN ('Concluído', 'Cancelado')
ORDER BY Dias_Aberto DESC;

-- 5. Mecânicos e suas equipes
SELECT 
    m.Nome AS Mecanico,
    m.Especialidade,
    e.Nome_Equipe AS Equipe,
    e.Especialidade_Principal
FROM Mecanico m
JOIN Mecanico_Equipe me ON m.IdMecanico = me.Mecanico_IdMecanico
JOIN Equipe e ON me.Equipe_IdEquipe = e.IdEquipe
ORDER BY e.Nome_Equipe, m.Nome;

-- 6. Faturamento por mês
SELECT 
    YEAR(os.Data_emissao) AS Ano,
    MONTH(os.Data_emissao) AS Mes,
    COUNT(*) AS Total_Ordens,
    SUM(os.Valor_total) AS Faturamento_Total,
    AVG(os.Valor_total) AS Ticket_Medio
FROM Ordem_Servico os
WHERE os.Status = 'Concluído'
GROUP BY YEAR(os.Data_emissao), MONTH(os.Data_emissao)
ORDER BY Ano DESC, Mes DESC;

-- 7. Detalhamento completo de uma ordem específica
SELECT 
    os.Numero_OS,
    c.Nome AS Cliente,
    v.Placa,
    v.Marca,
    v.Modelo,
    os.Data_emissao,
    os.Data_conclusao_real,
    os.Status,
    os.Valor_total
FROM Ordem_Servico os
JOIN Veiculo v ON os.Veiculo_IdVeiculo = v.IdVeiculo
JOIN Cliente c ON v.Cliente_idCliente = c.IdCliente
WHERE os.Numero_OS = 'OS2024001';

-- 8. Serviços e peças de uma ordem específica
SELECT 
    'SERVIÇO' AS Tipo,
    s.Descricao AS Item,
    so.Quantidade,
    so.Valor_Unitario,
    so.Subtotal
FROM Servico_Ordem so
JOIN Servico s ON so.Servico_IdServico = s.IdServico
WHERE so.Ordem_Servico_IdOrdem_Servico = 1

UNION ALL

SELECT 
    'PEÇA' AS Tipo,
    p.Descricao AS Item,
    po.Quantidade,
    po.Valor_Unitario,
    po.Subtotal
FROM Peca_Ordem po
JOIN Peca p ON po.Peca_IdPeca = p.IdPeca
WHERE po.Ordem_Servico_IdOrdem_Servico = 1

ORDER BY Tipo DESC;

-- 9. Veículos que mais frequentam a oficina
SELECT 
    v.Placa,
    v.Marca,
    v.Modelo,
    c.Nome AS Proprietario,
    COUNT(os.IdOrdem_Servico) AS Visitas,
    SUM(os.Valor_total) AS Total_Gasto
FROM Veiculo v
JOIN Ordem_Servico os ON v.IdVeiculo = os.Veiculo_IdVeiculo
JOIN Cliente c ON v.Cliente_idCliente = c.IdCliente
GROUP BY v.IdVeiculo, v.Placa, v.Marca, v.Modelo, c.Nome
HAVING COUNT(os.IdOrdem_Servico) > 0
ORDER BY Visitas DESC, Total_Gasto DESC;

-- 10. Tempo médio de conclusão por tipo de serviço
SELECT 
    s.Descricao AS Servico,
    AVG(TIME_TO_SEC(s.Tempo_Medio_Execucao)) / 3600 AS Tempo_Medio_Horas,
    COUNT(*) AS Quantidade_Executada
FROM Servico_Ordem so
JOIN Servico s ON so.Servico_IdServico = s.IdServico
JOIN Ordem_Servico os ON so.Ordem_Servico_IdOrdem_Servico = os.IdOrdem_Servico
WHERE os.Status = 'Concluído'
GROUP BY s.IdServico, s.Descricao
ORDER BY Quantidade_Executada DESC;