-- Database: Holding Care

-- DROP DATABASE "Holding Care";

CREATE DATABASE "Holding Care"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
	
CREATE TABLE Holding (
	id_hospital INT,
	FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital),
	CNPJ_lab INT,
	FOREIGN KEY (CNPJ_lab) REFERENCES Laboratorio (CNPJ)
)

CREATE TABLE Hospital (
	id_hospital INT PRIMARY KEY,
	nome VARCHAR(50) NOT NULL
)

CREATE TABLE Laboratorio (
	CNPJ VARCHAR(50) PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	endereco VARCHAR(50) NOT NULL,
	telefone VARCHAR(25) NOT NULL,
	expiracao DATE NOT NULL,
)	

CREATE TABLE Funcionario (
	id_funcionario INT PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	endereco VARCHAR(50) NOT NULL,
	contratacao DATE NOT NULL,
	id_hospital INT,
	FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital),
	tipo_funcionario VARCHAR(50) --constraint medico, enfermeiro ou outros (pode ser nulo?)
)

CREATE TABLE Telefones (
	id_funcionario INT,
	FOREIGN KEY (id_funcionario) REFERENCES Funcionario (id_funcionario),
	telefone VARCHAR(25) NOT NULL
)

CREATE TABLE Medicos (
	CRM VARCHAR(25) PRIMARY KEY,
	id_funcionario INT,
	FOREIGN KEY (id_funcionario) REFERENCES Funcionario (id_funcionario),
	especialidade VARCHAR(25)
)

CREATE TABLE Historico (
	id_funcionario INT,
	FOREIGN KEY (id_funcionario) REFERENCES Funcionario (id_funcionario),
	id_ala INT,
	FOREIGN KEY (id_ala) REFERENCES Ala (id_ala),
	dia DATE NOT NULL,
	horario TIME NOT NULL,
	substituicao BOOL,
	id_substituicao INT,
	--constraint(sub == true e id_func existir e n ser ele mesmo)
)

CREATE TABLE Ala (
	id_ala INT PRIMARY KEY,
	id_hospital INT,
	FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital),
	tipo_ala VARCHAR(50) NOT NULL --internacao, consulta ou operacao
	nome VARCHAR(50) --se tipo_ala == internacao NOT NULL
)

CREATE TABLE sala_operacao (
	id_sala INT PRIMARY KEY,
	id_ala INT,
	FOREIGN KEY (id_ala) REFERENCES Ala (id_ala),
	especialidade VARCHAR(50),
	andar INT NOT NULL
)

CREATE TABLE sala_internacao (
	id_leito INT PRIMARY KEY,
	id_ala INT,
	FOREIGN KEY (id_ala) REFERENCES Ala (id_ala),
	andar INT NOT NULL
)

CREATE TABLE Consultorio (
	id_consultorio INT PRIMARY KEY,
	id_ala INT,
	FOREIGN KEY (id_ala) REFERENCES Ala (id_ala),
	disponibilidade BOOL NOT NULL,
	andar INT NOT NULL
)

CREATE TABLE Paciente (
	id_paciente INT PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	nascimento DATE NOT NULL,
	genero VARCHAR(10) NOT NULL, -- constrant para feminino e masculino
	endereco VARCHAR(50) NOT NULL,
	convenio VARCHAR(30),
	sus VARCHAR(30)
)

CREATE TABLE Consulta {
	id_consulta INT PRIMARY KEY
	medico INT,
	FOREIGN KEY (medico) REFERENCES Medicos (CRM),
	paciente INT,
	FOREIGN KEY (paciente) REFERENCES Paciente (id_paciente),
	consultorio INT,
	FOREIGN KEY (consultorio) REFERENCES Consultorio (id_consultorio),
	tipo_consulta VARCHAR(50) NOT NULL -- contraint para primeira e retorno
}

CREATE TABLE  Diagnostico (
	id_consulta INT,
	FOREIGN KEY (id_consulta) REFERENCES Consulta (id_consulta),
	dia DATE NOT NULL,
	hora TIME NOT NULL,
	tipo VARCHAR(),
	precaucoes VARCHAR(),
	complicacoes VARCHAR()
)

CREATE TABLE exames_laboratoriais (
	id_consulta INT,
	FOREIGN KEY (id_consulta) REFERENCES Consulta (id_consulta),
	id_exame INT,
	FOREIGN KEY (id_exame) REFERENCES Exame (id_exame),
)

CREATE TABLE Exame (
	id_exame INT PRIMARY KEY,
	nome VARCHAR(50),
	preparacao VARCHAR(100)
)

CREATE TABLE Agendamento_exame (
	dia DATE NOT NULL,
	hora TIME NOT NULL,
	id_exame INT,
	FOREIGN KEY (id_exame) REFERENCES Exame (id_exame),
	laboratorio INT,
	FOREIGN KEY (laboratorio) REFERENCES Laboratorio (CNPJ), --- CONTRAINT
	id_consulta INT,
	FOREIGN KEY (id_consulta) REFERENCES Consulta (id_consulta),
	id_resultado INT,
	FOREIGN KEY (id_resultado) REFERENCES Resultado (id_resultado)
)

CREATE TABLE Resultado (
	id_resultado INT PRIMARY KEY,
	id_consulta INT,
	FOREIGN KEY (id_consulta) REFERENCES Consulta (id_consulta),
	descricao VARCHAR(255) NOT NULL,
	tipo VARCHAR(255) NOT NULL,
	descritivo VARCHAR(255) NOT NULL
)

CREATE TABLE Solicitacao_internacao (
	id_solicitacao INT PRIMARY KEY,
	id_consulta INT,
	FOREIGN KEY (id_consulta) REFERENCES Consulta (id_consulta),
	motivo VARCHAR() NOT NULL,
	cirurgia VARCHAR(50) NOT NULL
)

CREATE TABLE Agenda_internacao (
	dia DATE NOT NULL,
	hora TIME NOT NULL,
	id_solicitacao INT,
	FOREIGN KEY (id_solicitacao) REFERENCES Solicitacao_internacao (id_solicitacao),
	id_leito INT,
	FOREIGN KEY (id_leito) REFERENCES Sala_internacao (id_leito),
)

CREATE TABLE cobertura (
	CNPJ VARCHAR(50),
	FOREIGN KEY (CNPJ) REFERENCES Laboratorio (CNPJ),
	id_exame INT,
	FOREIGN KEY (id_exame) REFERENCES Exame (id_exame),
	valor MONEY
)
-



