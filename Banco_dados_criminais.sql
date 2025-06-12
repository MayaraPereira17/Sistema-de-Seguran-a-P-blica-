CREATE DATABASE dados_criminais2;
USE dados_criminais2;
select *from dados_criminais;
CREATE TABLE Departamento (
    PK_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nome_departamento VARCHAR(100) NOT NULL
);

CREATE TABLE Seccional (
    PK_seccional INT AUTO_INCREMENT PRIMARY KEY,
    nome_seccional VARCHAR(100) NOT NULL,
    FK_departamento INT,
    FOREIGN KEY (FK_departamento) REFERENCES Departamento(PK_departamento)
);

CREATE TABLE Delegacia (
    PK_delegacia INT AUTO_INCREMENT PRIMARY KEY,
    nome_delegacia VARCHAR(100) NOT NULL,
    FK_seccional INT,
    FOREIGN KEY (FK_seccional) REFERENCES Seccional(PK_seccional)
);

CREATE TABLE Municipio (
    PK_municipio INT AUTO_INCREMENT PRIMARY KEY,
    nome_municipio VARCHAR(100) NOT NULL
);

CREATE TABLE Localizacao (
    PK_localizacao INT AUTO_INCREMENT PRIMARY KEY,
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    FK_municipio INT,
    FOREIGN KEY (FK_municipio) REFERENCES Municipio(PK_municipio)
);


CREATE TABLE ocorrencias_criminais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    num_bo VARCHAR(20),
    ano_bo INT,
    data_registro DATE,
    data_ocorrencia DATE,
    hora_ocorrencia TIME,
    desc_periodo VARCHAR(50),
    nome_municipio VARCHAR(100),
    nome_departamento VARCHAR(100),
    nome_seccional VARCHAR(100),
    nome_delegacia VARCHAR(100),
    rubrica VARCHAR(255),
    natureza_apurada VARCHAR(255),
    descr_conduta TEXT,
    latitude DOUBLE,
    longitude DOUBLE,
    mes_estatistica INT,
    ano_estatistica INT,
    bairro VARCHAR(100),
    descr_subtipolocal VARCHAR(100),
    logradouro VARCHAR(150)
);

ALTER TABLE ocorrencias_criminais ADD COLUMN subtipo_local VARCHAR(100);

CREATE TABLE Natureza_Apurada (
    PK_natureza INT AUTO_INCREMENT PRIMARY KEY,
    descricao TEXT NOT NULL
);

CREATE TABLE Ocorrencia_Natureza (
    FK_ocorrencia INT,
    FK_natureza INT,
    PRIMARY KEY (FK_ocorrencia, FK_natureza),
    FOREIGN KEY (FK_ocorrencia) REFERENCES ocorrencias_criminais(id),
    FOREIGN KEY (FK_natureza) REFERENCES Natureza_Apurada(PK_natureza)
);

-- INSERT --
INSERT INTO Departamento (nome_departamento)
SELECT DISTINCT nome_departamento
FROM ocorrencias_criminais;

INSERT INTO Seccional (nome_seccional, FK_departamento)
SELECT DISTINCT oc.nome_seccional, d.PK_departamento
FROM ocorrencias_criminais oc
JOIN Departamento d ON d.nome_departamento = oc.nome_departamento
WHERE NOT EXISTS (
    SELECT 1 
    FROM Seccional s
    WHERE s.nome_seccional = oc.nome_seccional
);

INSERT INTO Delegacia (nome_delegacia, FK_seccional)
SELECT DISTINCT oc.nome_delegacia, s.PK_seccional
FROM ocorrencias_criminais oc
JOIN Seccional s ON s.nome_seccional = oc.nome_seccional
WHERE NOT EXISTS (
    SELECT 1 
    FROM Delegacia d
    WHERE d.nome_delegacia = oc.nome_delegacia
);


INSERT INTO Municipio (nome_municipio)
SELECT DISTINCT oc.nome_municipio
FROM ocorrencias_criminais oc
WHERE NOT EXISTS (
    SELECT 1
    FROM Municipio m
    WHERE m.nome_municipio = oc.nome_municipio
);

INSERT INTO Localizacao (latitude, longitude, FK_municipio)
SELECT DISTINCT
    CAST(oc.latitude AS DECIMAL(10,8)) AS latitude,
    CAST(oc.longitude AS DECIMAL(11,8)) AS longitude,
    m.PK_municipio
FROM ocorrencias_criminais oc
JOIN Municipio m ON m.nome_municipio = oc.nome_municipio
WHERE oc.latitude REGEXP '^-?[0-9]+\\.[0-9]+'
  AND oc.longitude REGEXP '^-?[0-9]+\\.[0-9]+'
  AND NOT EXISTS (
      SELECT 1
      FROM Localizacao l
      WHERE l.latitude = CAST(oc.latitude AS DECIMAL(10,8))
        AND l.longitude = CAST(oc.longitude AS DECIMAL(11,8))
  );
  
INSERT INTO Natureza_Apurada (descricao)
SELECT DISTINCT oc.NATUREZA_APURADA
FROM ocorrencias_criminais oc
WHERE oc.NATUREZA_APURADA IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM Natureza_Apurada na
      WHERE na.descricao = oc.NATUREZA_APURADA
  );
  
INSERT INTO Ocorrencia_Natureza (FK_ocorrencia, FK_natureza)
SELECT DISTINCT oc.id, na.PK_natureza
FROM ocorrencias_criminais oc
JOIN Natureza_Apurada na ON na.descricao = oc.NATUREZA_APURADA
WHERE oc.NATUREZA_APURADA IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM Ocorrencia_Natureza onat
      WHERE onat.FK_ocorrencia = oc.id
        AND onat.FK_natureza = na.PK_natureza
  );


#consultar dados
SELECT * FROM Departamento;
SELECT * FROM Seccional;
SELECT * FROM Delegacia;
SELECT * FROM Municipio;
SELECT * FROM Localizacao;
SELECT * FROM  ocorrencias_criminais;
SELECT * FROM  Natureza_Apurada;
SELECT * FROM  Ocorrencia_Natureza;

#remover dados de toda tabela
TRUNCATE TABLE Departamento;
