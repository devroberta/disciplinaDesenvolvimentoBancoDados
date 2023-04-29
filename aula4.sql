create database litoral;
use litoral;

CREATE TABLE escuna (
	numero INT PRIMARY KEY,
    nome VARCHAR(30),
    capitao_cpf CHAR(11)
);

CREATE TABLE destino (
	id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(30)
);

CREATE TABLE passeio (
	id INT PRIMARY KEY AUTO_INCREMENT,
    data DATE,
    hora_saida TIME,
    hora_chegada TIME,
    escuna_numero INT,
    destino_id INT,
    FOREIGN KEY(escuna_numero) REFERENCES escuna(numero),
    FOREIGN KEY(destino_id) REFERENCES destino(id)
);

INSERT INTO escuna VALUES
(12345, "Black Flag", "88888888899"),
(12346, "Caveira", "66666666677"),
(12347, "Brazuca", "44444444455"),
(12348, "Rosa Brilhante 1", "12345678900"),
(12349, "Tubarão Ocean", "22222222233"),
(12340, "Rosa Brilhante 2", "12345678900");

INSERT INTO destino VALUES
(0, "Ilha Dourada"),
(0, "Ilha D'areia fina"),
(0, "Ilha Encantada"),
(0, "Ilha dos Ventos"),
(0, "Ilhinha"),
(0, "Ilha Torta"),
(0, "Ilha dos Sonhos"),
(0, "Ilha do Sono");

INSERT INTO passeio VALUES
(0, 20180102, 080000, 140000, 12345, 1),
(0, 20180102, 070000, 170000, 12346, 8),
(0, 20180102, 080000, 140000, 12340, 3),
(0, 20180103, 060000, 120000, 12347, 2),
(0, 20180103, 070000, 130000, 12348, 4),
(0, 20180103, 080000, 140000, 12349, 6),
(0, 20180103, 090000, 150000, 12345, 5),
(0, 20180104, 070000, 160000, 12347, 1),
(0, 20180104, 070000, 170000, 12345, 3),
(0, 20180104, 090000, 130000, 12349, 7),
(0, 20180105, 100000, 180000, 12340, 8),
(0, 20180105, 090000, 130000, 12347, 7);

SELECT * FROM escuna;
SELECT * FROM destino;
SELECT * FROM passeio;

-- Criação da consulta com o nome da escuna, destino, horas de saída e chegada, e data do passeio
SELECT 
	escuna.nome AS "ESCUNA", 
	destino.nome AS "ILHA", 
    passeio.hora_saida,
    passeio.hora_chegada,
    passeio.data
FROM passeio 
INNER JOIN escuna ON passeio.escuna_numero = escuna.numero
INNER JOIN destino ON passeio.destino_id = destino.id
ORDER BY passeio.data;

-- Criação da VIEW ------------------------------------------------
CREATE VIEW v_consulta AS
	SELECT 
		escuna.nome AS "ESCUNA", 
		destino.nome AS "ILHA", 
		passeio.hora_saida,
		passeio.hora_chegada,
		passeio.data
	FROM passeio 
	INNER JOIN escuna ON passeio.escuna_numero = escuna.numero
	INNER JOIN destino ON passeio.destino_id = destino.id
	ORDER BY passeio.data;
    
SHOW TABLES;

SELECT * FROM v_consulta;

-- Apagar a VIEW 
DROP VIEW v_consulta;

/* Configurar o ambiente para que as alterações não sejam gravadas automaticamente
Controle transacional MANUAL (SET AUTOCOMMIT = 0;)
Controle transacional AUTOMÁTICO (SET AUTOCOMMIT =1;) */
SET AUTOCOMMIT = 0;

-- Para criar um ponto de restauração no banco
SAVEPOINT ponto1;

/* Para fins de teste, o script a seguir visará gerar o mesmo
   erro cometido pelo colaborador */
UPDATE destino SET nome = "Pequena Ilha do Mar" WHERE id = 1;

-- Consulta exibe a tabela após o "erro"
SELECT * FROM destino;

-- Utilizar o ponto de restauração criado e testá-lo
ROLLBACK TO SAVEPOINT ponto1;

-- Consulta exibe a tabela como estava antes do erro
SELECT * FROM destino;

/* Agora alterando corretamente, somente o registro 5.
E para GRAVAR as alterações feitas, deve ser utilizado o comando COMMIT */
SAVEPOINT novoPonto;
UPDATE destino SET nome = "Pequena Ilha do Mar" WHERE id = 5;
COMMIT;
SELECT * FROM destino;

-- Resolução de SP de uma nova feature
-- Criar um ponto de venda de passagens para os passeios
CREATE TABLE vendas (
	numero INT PRIMARY KEY AUTO_INCREMENT,
    destino_id INT,
    embarque DATE,
    qtd INT,
    FOREIGN KEY (destino_id) REFERENCES destino(id)
);

SELECT * FROM destino;

INSERT INTO vendas VALUES 
(0, 1, 20180203, 3),
(0, 7, 20180203, 2),
(0, 5, 20180203, 1);

ALTER TABLE destino ADD COLUMN valor DECIMAL(5,2);

SELECT * FROM destino;

UPDATE destino SET valor = 100 WHERE id = 1;
UPDATE destino SET valor = 120 WHERE id = 2;
UPDATE destino SET valor = 80 WHERE id = 3;
UPDATE destino SET valor = 90 WHERE id = 4;
UPDATE destino SET valor = 100 WHERE id = 5;
UPDATE destino SET valor = 150 WHERE id = 6;
UPDATE destino SET valor = 120 WHERE id = 7;
UPDATE destino SET valor = 180 WHERE id = 8;

-- Definindo a variavel global para valor 1, para dizer que a função é deterministica ou que não modifica os dados.
SET GLOBAL log_bin_trust_function_creators = 1;

-- Criando a função com 30% de desconto
CREATE FUNCTION fn_desc(x DECIMAL(5,2), y INT)
RETURNS DECIMAL(5,2)
RETURN ((x*y)*0.7);

SHOW FUNCTION STATUS WHERE db = 'litoral';

SELECT * FROM vendas;

-- Criando o procedimento
CREATE PROCEDURE proc_desc (var_vendanumero INT)
	SELECT
		(fn_desc(destino.valor, vendas.Qtd)) AS "Valor com desconto",
        destino.nome AS "Destino",
        vendas.qtd AS "Passagens",
        vendas.embarque
	FROM vendas INNER JOIN destino
    ON vendas.destino_id = destino.id
    WHERE vendas.numero = var_vendanumero;

CALL proc_desc(1);
CALL proc_desc(2);
CALL proc_desc(3);

SHOW FUNCTION STATUS WHERE db = 'litoral';

SHOW PROCEDURE STATUS WHERE db = 'litoral';
