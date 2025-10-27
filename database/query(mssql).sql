-- =============================================
-- SISTEMA DE CONSULTAS - UNIDADE BÁSICA DE SAÚDE
-- SQL Server / Azure SQL Database
-- =============================================

-- Tabela de Usuários (base para todos)
CREATE TABLE Usuarios (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
    nome_completo NVARCHAR(200) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    email NVARCHAR(100) UNIQUE,
    senha_hash VARCHAR(64) NOT NULL,
    telefone VARCHAR(15),
    data_nascimento DATE NOT NULL,
    endereco NVARCHAR(300),
    tipo_perfil VARCHAR(20) NOT NULL CHECK (tipo_perfil IN ('PACIENTE', 'PROFISSIONAL')),
    ativo BIT DEFAULT 1,
    data_cadastro DATETIME DEFAULT GETDATE(),
    data_atualizacao DATETIME DEFAULT GETDATE()
);

-- Índice para busca rápida por CPF e tipo
CREATE INDEX idx_usuarios_cpf ON Usuarios(cpf);
CREATE INDEX idx_usuarios_tipo ON Usuarios(tipo_perfil);

-- Tabela de Especialidades Médicas
CREATE TABLE Especialidades (
    id_especialidade INT PRIMARY KEY IDENTITY(1,1),
    nome_especialidade NVARCHAR(100) NOT NULL UNIQUE,
    descricao NVARCHAR(500),
    ativo BIT DEFAULT 1
);

-- Tabela de Profissionais (extends Usuarios)
CREATE TABLE Profissionais (
    id_profissional INT PRIMARY KEY,
    registro_profissional VARCHAR(20) UNIQUE NOT NULL, -- CRM, CRO, CRF, etc
    id_especialidade INT NOT NULL,
    FOREIGN KEY (id_profissional) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_especialidade) REFERENCES Especialidades(id_especialidade)
);

-- Tabela de Pacientes (extends Usuarios)
CREATE TABLE Pacientes (
    id_paciente INT PRIMARY KEY,
    cartao_sus VARCHAR(15) UNIQUE,
    tipo_sanguineo VARCHAR(3),
    alergias NVARCHAR(500),
    observacoes_gerais NVARCHAR(1000),
    FOREIGN KEY (id_paciente) REFERENCES Usuarios(id_usuario)
);

-- Tabela de Prontuários (UM por paciente - documento geral)
CREATE TABLE Prontuarios (
    id_prontuario INT PRIMARY KEY IDENTITY(1,1),
    id_paciente INT NOT NULL UNIQUE, -- Cada paciente tem apenas UM prontuário
    status_paciente VARCHAR(20) NOT NULL DEFAULT 'VIVO' 
        CHECK (status_paciente IN ('VIVO', 'OBITO')),
    data_obito DATE NULL,
    causa_obito NVARCHAR(500) NULL,
    observacoes_gerais NVARCHAR(2000),
    data_criacao DATETIME DEFAULT GETDATE(),
    data_atualizacao DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente)
);

CREATE INDEX idx_prontuario_paciente ON Prontuarios(id_paciente);

-- Tabela de Consultas (com controle de conflito de horário)
CREATE TABLE Consultas (
    id_consulta INT PRIMARY KEY IDENTITY(1,1),
    id_paciente INT NOT NULL,
    id_profissional INT NOT NULL,
    data_consulta DATE NOT NULL,
    hora_consulta TIME NOT NULL,
    status_consulta VARCHAR(20) NOT NULL DEFAULT 'AGENDADA' 
        CHECK (status_consulta IN ('AGENDADA', 'CONFIRMADA', 'REALIZADA', 'CANCELADA', 'FALTOU')),
    motivo_consulta NVARCHAR(500),
    data_agendamento DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    FOREIGN KEY (id_profissional) REFERENCES Profissionais(id_profissional)
);

-- CONSTRAINT ÚNICA: impede consultas no mesmo horário para o mesmo profissional
CREATE UNIQUE INDEX idx_consulta_unica ON Consultas(id_profissional, data_consulta, hora_consulta) 
    WHERE status_consulta NOT IN ('CANCELADA');

-- Índices para performance
CREATE INDEX idx_consultas_paciente ON Consultas(id_paciente, data_consulta DESC);
CREATE INDEX idx_consultas_profissional ON Consultas(id_profissional, data_consulta, hora_consulta);
CREATE INDEX idx_consultas_data ON Consultas(data_consulta, hora_consulta);

-- Tabela de Histórico de Atendimentos (MUITOS registros por prontuário)
-- Cada consulta realizada gera uma entrada no histórico
CREATE TABLE Historico_Atendimentos (
    id_historico INT PRIMARY KEY IDENTITY(1,1),
    id_prontuario INT NOT NULL,
    id_consulta INT NOT NULL UNIQUE, -- Cada consulta gera UM registro de histórico
    id_profissional INT NOT NULL,
    data_atendimento DATETIME NOT NULL DEFAULT GETDATE(),
    queixa_principal NVARCHAR(1000),
    historico_doenca_atual NVARCHAR(2000),
    exame_fisico NVARCHAR(2000),
    hipotese_diagnostica NVARCHAR(1000) NOT NULL,
    diagnostico_final NVARCHAR(1000),
    conduta NVARCHAR(2000),
    observacoes NVARCHAR(2000),
    FOREIGN KEY (id_prontuario) REFERENCES Prontuarios(id_prontuario),
    FOREIGN KEY (id_consulta) REFERENCES Consultas(id_consulta),
    FOREIGN KEY (id_profissional) REFERENCES Profissionais(id_profissional)
);

CREATE INDEX idx_historico_prontuario ON Historico_Atendimentos(id_prontuario, data_atendimento DESC);
CREATE INDEX idx_historico_consulta ON Historico_Atendimentos(id_consulta);

-- Tabela de Receitas Médicas (vinculadas ao histórico de atendimento)
CREATE TABLE Receitas (
    id_receita INT PRIMARY KEY IDENTITY(1,1),
    id_historico INT NOT NULL, -- Vinculada ao registro do histórico
    id_profissional INT NOT NULL,
    data_emissao DATETIME DEFAULT GETDATE(),
    validade_dias INT DEFAULT 30,
    observacoes NVARCHAR(1000),
    FOREIGN KEY (id_historico) REFERENCES Historico_Atendimentos(id_historico),
    FOREIGN KEY (id_profissional) REFERENCES Profissionais(id_profissional)
);

CREATE INDEX idx_receitas_historico ON Receitas(id_historico);

-- Tabela de Medicamentos da Receita
CREATE TABLE Receita_Medicamentos (
    id_receita_medicamento INT PRIMARY KEY IDENTITY(1,1),
    id_receita INT NOT NULL,
    nome_medicamento NVARCHAR(200) NOT NULL,
    dosagem NVARCHAR(100) NOT NULL,
    quantidade VARCHAR(50) NOT NULL,
    via_administracao VARCHAR(50),
    posologia NVARCHAR(500) NOT NULL, -- "Tomar 1 comprimido a cada 8 horas"
    duracao_tratamento VARCHAR(100),
    FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita)
);

-- Tabela de Tratamentos Recomendados (vinculados ao histórico de atendimento)
CREATE TABLE Tratamentos (
    id_tratamento INT PRIMARY KEY IDENTITY(1,1),
    id_historico INT NOT NULL, -- Vinculado ao registro do histórico
    tipo_tratamento VARCHAR(50) NOT NULL, -- 'MEDICAMENTOSO', 'FISIOTERAPIA', 'CIRURGICO', 'ACOMPANHAMENTO'
    descricao_tratamento NVARCHAR(2000) NOT NULL,
    data_inicio DATE,
    data_fim_prevista DATE,
    status_tratamento VARCHAR(20) DEFAULT 'EM_ANDAMENTO' 
        CHECK (status_tratamento IN ('EM_ANDAMENTO', 'CONCLUIDO', 'INTERROMPIDO')),
    observacoes NVARCHAR(1000),
    FOREIGN KEY (id_historico) REFERENCES Historico_Atendimentos(id_historico)
);

CREATE INDEX idx_tratamentos_historico ON Tratamentos(id_historico);

-- =============================================
-- INSERÇÃO DE DADOS INICIAIS
-- =============================================

-- Especialidades comuns em UBS
INSERT INTO Especialidades (nome_especialidade, descricao) VALUES
('Clínica Geral', 'Atendimento médico generalista'),
('Cardiologia', 'Especialidade médica que cuida do coração'),
('Pediatria', 'Especialidade médica voltada para crianças e adolescentes'),
('Ginecologia', 'Especialidade médica voltada para saúde da mulher'),
('Enfermagem', 'Atendimento de enfermagem'),
('Odontologia', 'Atendimento odontológico'),
('Psicologia', 'Atendimento psicológico');

-- =============================================
-- EXEMPLO DE USO (simplificado para API)
-- =============================================

-- 1. Inserir um profissional (Dr. Carlos - Cardiologista)
-- Na API: primeiro insere o usuário e captura o ID retornado
INSERT INTO Usuarios (nome_completo, cpf, email, telefone, data_nascimento, tipo_perfil)
VALUES ('Dr. Carlos Alberto Santos', '12345678901', 'carlos.santos@ubs.gov.br', '81987654321', '1975-05-15', 'PROFISSIONAL');
-- Retorna: id_usuario = 1

INSERT INTO Profissionais (id_profissional, registro_profissional, id_especialidade)
VALUES (1, 'CRM12345PE', 2); -- 2 = Cardiologia

-- 2. Inserir um paciente
INSERT INTO Usuarios (nome_completo, cpf, email, telefone, data_nascimento, tipo_perfil)
VALUES ('Maria Silva Santos', '98765432100', 'maria.silva@email.com', '81912345678', '1985-03-20', 'PACIENTE');
-- Retorna: id_usuario = 2

INSERT INTO Pacientes (id_paciente, cartao_sus, tipo_sanguineo, alergias)
VALUES (2, '123456789012345', 'O+', 'Penicilina');

-- 3. Criar prontuário para o paciente
INSERT INTO Prontuarios (id_paciente, status_paciente, observacoes_gerais)
VALUES (2, 'VIVO', 'Paciente hipertensa, em acompanhamento');
-- Retorna: id_prontuario = 1

-- 4. Marcar uma consulta
INSERT INTO Consultas (id_paciente, id_profissional, data_consulta, hora_consulta, status_consulta, motivo_consulta)
VALUES (2, 1, '2025-11-25', '09:00:00', 'AGENDADA', 'Dor no peito e falta de ar');
-- Retorna: id_consulta = 1

-- 5. Após a consulta ser realizada, atualizar status
UPDATE Consultas SET status_consulta = 'REALIZADA' WHERE id_consulta = 1;

-- 6. Criar registro no histórico
INSERT INTO Historico_Atendimentos (
    id_prontuario, id_consulta, id_profissional, 
    queixa_principal, exame_fisico, hipotese_diagnostica, 
    diagnostico_final, conduta
)
VALUES (
    1, 1, 1,
    'Dor precordial e dispneia aos esforços',
    'PA: 150/95 mmHg, FC: 88 bpm, ausculta cardíaca normal',
    'Hipertensão arterial sistêmica descompensada',
    'HAS estágio 2',
    'Ajuste medicamentoso, solicitar ECG e retorno em 15 dias'
);
-- Retorna: id_historico = 1

-- 7. Prescrever medicamentos
INSERT INTO Receitas (id_historico, id_profissional, observacoes)
VALUES (1, 1, 'Uso contínuo');
-- Retorna: id_receita = 1

INSERT INTO Receita_Medicamentos (id_receita, nome_medicamento, dosagem, quantidade, posologia, duracao_tratamento)
VALUES 
    (1, 'Losartana Potássica', '50mg', '30 comprimidos', 'Tomar 1 comprimido pela manhã', 'Uso contínuo'),
    (1, 'Hidroclorotiazida', '25mg', '30 comprimidos', 'Tomar 1 comprimido pela manhã', 'Uso contínuo');

-- 8. Registrar tratamento
INSERT INTO Tratamentos (id_historico, tipo_tratamento, descricao_tratamento, data_inicio, status_tratamento)
VALUES (
    1, 
    'MEDICAMENTOSO', 
    'Terapia anti-hipertensiva com IECA + diurético tiazídico. Orientações sobre dieta hipossódica e atividade física regular.',
    '2025-11-25',
    'EM_ANDAMENTO'
);

-- =============================================
-- VIEWS ÚTEIS
-- =============================================

-- View: Prontuário completo do paciente com todas as consultas
GO
CREATE VIEW vw_Prontuario_Completo AS
SELECT 
    p.id_prontuario,
    pac.id_paciente,
    u_pac.nome_completo AS nome_paciente,
    u_pac.cpf,
    pac.cartao_sus,
    pac.tipo_sanguineo,
    pac.alergias,
    p.status_paciente,
    p.data_obito,
    p.observacoes_gerais,
    ha.id_historico,
    ha.data_atendimento,
    u_prof.nome_completo AS nome_profissional,
    e.nome_especialidade,
    ha.queixa_principal,
    ha.diagnostico_final,
    ha.conduta
FROM Prontuarios p
INNER JOIN Pacientes pac ON p.id_paciente = pac.id_paciente
INNER JOIN Usuarios u_pac ON pac.id_paciente = u_pac.id_usuario
LEFT JOIN Historico_Atendimentos ha ON p.id_prontuario = ha.id_prontuario
LEFT JOIN Profissionais prof ON ha.id_profissional = prof.id_profissional
LEFT JOIN Usuarios u_prof ON prof.id_profissional = u_prof.id_usuario
LEFT JOIN Especialidades e ON prof.id_especialidade = e.id_especialidade;
GO

-- View: Agenda completa do profissional
CREATE VIEW vw_Agenda_Profissional AS
SELECT 
    c.id_consulta,
    c.data_consulta,
    c.hora_consulta,
    c.status_consulta,
    u_prof.nome_completo AS nome_profissional,
    e.nome_especialidade,
    u_pac.nome_completo AS nome_paciente,
    u_pac.telefone AS telefone_paciente,
    c.motivo_consulta
FROM Consultas c
INNER JOIN Profissionais prof ON c.id_profissional = prof.id_profissional
INNER JOIN Usuarios u_prof ON prof.id_profissional = u_prof.id_usuario
INNER JOIN Especialidades e ON prof.id_especialidade = e.id_especialidade
INNER JOIN Pacientes pac ON c.id_paciente = pac.id_paciente
INNER JOIN Usuarios u_pac ON pac.id_paciente = u_pac.id_usuario;
GO

-- View: Histórico detalhado de atendimentos com receitas e tratamentos
CREATE VIEW vw_Historico_Detalhado AS
SELECT 
    ha.id_historico,
    ha.data_atendimento,
    u_pac.nome_completo AS nome_paciente,
    u_prof.nome_completo AS nome_profissional,
    e.nome_especialidade,
    ha.queixa_principal,
    ha.diagnostico_final,
    ha.conduta,
    r.id_receita,
    r.data_emissao AS data_receita,
    t.id_tratamento,
    t.tipo_tratamento,
    t.status_tratamento
FROM Historico_Atendimentos ha
INNER JOIN Prontuarios p ON ha.id_prontuario = p.id_prontuario
INNER JOIN Pacientes pac ON p.id_paciente = pac.id_paciente
INNER JOIN Usuarios u_pac ON pac.id_paciente = u_pac.id_usuario
INNER JOIN Profissionais prof ON ha.id_profissional = prof.id_profissional
INNER JOIN Usuarios u_prof ON prof.id_profissional = u_prof.id_usuario
INNER JOIN Especialidades e ON prof.id_especialidade = e.id_especialidade
LEFT JOIN Receitas r ON ha.id_historico = r.id_historico
LEFT JOIN Tratamentos t ON ha.id_historico = t.id_historico;
GO

-- =============================================
-- PROCEDURES ÚTEIS
-- =============================================

-- Procedure: Verificar disponibilidade de horário
CREATE PROCEDURE sp_VerificarDisponibilidade
    @id_profissional INT,
    @data_consulta DATE,
    @hora_consulta TIME
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Consultas 
        WHERE id_profissional = @id_profissional 
        AND data_consulta = @data_consulta 
        AND hora_consulta = @hora_consulta
        AND status_consulta NOT IN ('CANCELADA')
    )
        SELECT 0 AS Disponivel, 'Horário já ocupado' AS Mensagem
    ELSE
        SELECT 1 AS Disponivel, 'Horário disponível' AS Mensagem
END;
GO

-- Procedure: Buscar histórico completo de um paciente
CREATE PROCEDURE sp_BuscarHistoricoPaciente
    @id_paciente INT
AS
BEGIN
    SELECT 
        ha.data_atendimento,
        u_prof.nome_completo AS profissional,
        e.nome_especialidade,
        ha.queixa_principal,
        ha.diagnostico_final,
        ha.conduta
    FROM Historico_Atendimentos ha
    INNER JOIN Prontuarios p ON ha.id_prontuario = p.id_prontuario
    INNER JOIN Profissionais prof ON ha.id_profissional = prof.id_profissional
    INNER JOIN Usuarios u_prof ON prof.id_profissional = u_prof.id_usuario
    INNER JOIN Especialidades e ON prof.id_especialidade = e.id_especialidade
    WHERE p.id_paciente = @id_paciente
    ORDER BY ha.data_atendimento DESC;
END;
GO