USE guiatur;

SHOW TABLES FROM guiatur;

DESCRIBE pais;

INSERT INTO pais(nome, continente, codigo) VALUES ('Brasil', 'América', 'BRA');

INSERT INTO pais VALUES ('0', 'Índia', 'Ásia', 'IND');

INSERT INTO pais VALUES('0', 'China', 'Ásia', 'CHI'), ('0','Japão', 'Ásia', 'JPN');

SELECT * FROM pais;

SELECT * FROMestado;

DESCRIBE estado;

INSERT INTO estado (nome, sigla) VALUES
('Maranhão', 'MA'),
('São Paulo', 'SP'),
('Santa Catarina', 'SC'),
('Rio de Janeiro', 'RJ');

SELECT * FROM cidade;

DESCRIBE cidade;

INSERT INTO cidade (nome, populacao) VALUES
('Sorocaba', 700000),
('Déli', 26000000),
('Xangai', 22000000),
('Tóquio', 38000000);

SELECT * FROM ponto_tur;

DESCRIBE ponto_tur;

INSERT INTO ponto_tur (nome, tipo) VALUES
('Quinzinho de Barros', 'Instituição'),
('Parque Estadual do Jalapão', 'Atrativo'),
('Torre Eiffel', 'Atrativo'),
('Fogo de Chão', 'Serviço');

-- alterar para atrativo o primeiro ponto turístico
UPDATE ponto_tur SET tipo = 'Atrativo' WHERE id = 1;
SELECT * FROM ponto_tur;

-- alterar o segundo país (Índia) para ter o cód. 'IND'
SELECT * FROM pais WHERE nome = 'Índia';
UPDATE pais SET codigo = 'IND' WHERE id = 2;

-- deletar a primeira cidade
SELECT * FROM cidade;
DELETE FROM cidade WHERE id = 1;

-- criar uma tabela para ter a língua de cada país
CREATE TABLE IF NOT EXISTS linguagemPais (
	id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    codigoPais INT(11),
    linguagem VARCHAR(30) NOT NULL DEFAULT '',
    oficial ENUM ('Sim', 'Não') NOT NULL DEFAULT 'Não'
);

DESCRIBE pais;

/*Criar integridade referencial entre as tabelas linguagemPais e pais*/
ALTER TABLE linguagemPais ADD CONSTRAINT FK_linguagemPais 
FOREIGN KEY(codigoPais) 
REFERENCES pais(id);

DESCRIBE linguagemPais;

/*Modificar o código do país para ser obrigatória a inclusão*/
ALTER TABLE linguagemPais MODIFY codigoPais INT NOT NULL;

-- Alterar tabela de Elementos Turísticos, adicionando campos latitude e longitude e excluindo a tabela coordenada;
ALTER TABLE ponto_tur ADD coordenada POINT;
DROP TABLE coordenada;

-- ALterar a tabela "Países", adicionando uma nota de 0 a 10 com nível de interesse para o turista.
ALTER TABLE pais ADD interesse ENUM('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10');
DESCRIBE pais;

-- Alterar tabela "Cidades", incluindo uma lista com os três  melhores restaurantes
ALTER TABLE cidade ADD melhoresRestaurantes VARCHAR(300) DEFAULT '';

-- Inserir coordenada
INSERT INTO ponto_tur (nome, coordenada)
VALUES ('Ponte da Amizade', POINT(1.123456, 3.434343));

