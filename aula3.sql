create database SuperGames;
use SuperGames;

CREATE TABLE localizacao (
	Id INT PRIMARY KEY AUTO_INCREMENT,
    Secao VARCHAR(50) NOT NULL,
    Prateleira INT(3) ZEROFILL NOT NULL
);

CREATE TABLE jogo (
	Cod INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(50) NOT NULL,
    Valor DECIMAL(6, 2) NOT NULL,
    Localizacao_Id INT(3) NOT NULL,
    FOREIGN KEY (Localizacao_Id)
		REFERENCES localizacao (Id)
);

INSERT localizacao VALUES
(0, "Guerra", "001"),
(0, "Guerra", "002"),
(0, "Aventura", "100"),
(0, "Aventura", "101"),
(0, "RPG", "150"),
(0, "RGF", "151"),
(0, "Plataforma 2D", "200"),
(0, "Plataforma 2D", "201");

INSERT jogo VALUES
(0, "COD 3", 125.00, 1),
(0, "BF 1", 150.00, 2),
(0, "Zelda BotW", 200.00, 3),
(0, "Zelda OoT", 99.00, 4),
(0, "Chrono T", 205.00, 5);

SELECT * FROM localizacao;
SELECT * FROM jogo;

-- Identificar o nome do jogo e a prateleira
SELECT jogo.nome, localizacao.prateleira
FROM jogo INNER JOIN localizacao
ON localizacao.id = jogo.localizacao_Id;

-- Identificar o nome dos jogos da seção de jogos de Aventura.
SELECT jogo.nome, localizacao.prateleira, localizacao.secao
FROM jogo INNER JOIN localizacao
ON localizacao.id = jogo.localizacao_Id
WHERE secao = 'Aventura';

-- Identificar TODAS as seções e os respectivos nome dos jogos,
-- ordenando as seleções em ordem crescente pelo nome dos jogos.
SELECT jogo.nome, localizacao.prateleira, localizacao.secao
FROM localizacao LEFT JOIN jogo
ON localizacao.id = jogo.localizacao_Id
ORDER BY jogo.nome ASC;

-- Desenvolver função de agregação para mostrar o número de jogos
SELECT COUNT(*) FROM jogo;

-- Desenvolver uma função de agregação que retorne o valor
-- do jogo de menor preço (valor)
SELECT jogo.Nome, MIN(Valor)
FROM jogo
WHERE jogo.Valor = (SELECT MIN(Valor) FROM jogo)
GROUP BY jogo.Valor, jogo.Nome;

-- Desenvolver uma função de agregação que retorne o valor
-- médio dos jogos de guerra
SELECT AVG(Valor) AS "Média Guerra"
FROM jogo INNER JOIN localizacao
ON localizacao.id = jogo.localizacao_id
WHERE localizacao.secao = "Guerra";

-- Desenvolver uma função de agregação que retorne o
-- valor total em estoque na loja
SELECT SUM(Valor) AS "Total" FROM jogo;

-- Inserir mais jogos
INSERT jogo VALUES
(0, "Super Metroid", 205.00, 7),
(0, "DKC 2", 100.00, 8),
(0, "FF XV", 120.00, 5),
(0, "Xenoblade 2", 199.00, 6);

SELECT * FROM jogo;

/* Alterar valor dos jogos em promoção */
UPDATE jogo SET Valor = Valor * 0.5
WHERE Cod = 2;

-- Criar uma tabela 'Promoção'*/
CREATE TABLE promocao (
	Promo INT(3) PRIMARY KEY AUTO_INCREMENT,
    Cod_Jogo INT(3) NOT NULL,
    FOREIGN KEY (Cod_Jogo)
		REFERENCES jogo (Cod)
);

-- Inserção dos jogos em promoção */
INSERT promocao VALUES (0,1),(0,2);

SELECT * FROM promocao;

-- Selecionar os jogos em promoção
SELECT jogo.Nome, jogo.Valor
FROM jogo
WHERE jogo.Cod IN (SELECT cod_jogo FROM promocao);

/* ...ou utlizando JOIN ... */
SELECT jogo.Nome AS 'Título', jogo.Valor AS 'Preço'
FROM jogo
INNER JOIN promocao ON jogo.Cod = promocao.Cod_Jogo;

/* Selecionar os jogos que NÃO estão em promoção */
SELECT jogo.Nome, jogo.Valor
FROM jogo
WHERE jogo.Cod NOT IN (SELECT cod_jogo FROM promocao);

/* Selecionar o jogo mais barato utilizando subconsultas
e funções de agreagação */
SELECT nome AS 'Mais Barato'
FROM jogo WHERE Valor = SOME (SELECT MIN(Valor) FROM jogo);
