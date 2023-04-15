CREATE DATABASE guiatur

default charset = utf8mb3

default collate = utf8_general_ci;


use guiatur;

CREATE TABLE IF NOT EXISTS pais (
	id int(11) primary key not null auto_increment,
    nome varchar(50) not null default '',
    continente enum ('Ásia', 'América', 'África', 'Oceania', 'Antarctida') not null default 'América',
    codigo char(3) not null
);

CREATE TABLE IF NOT EXISTS estado (
	id int primary key not null auto_increment,
    nome varchar(50) not null default '',
    sigla char(2) not null
);

CREATE TABLE IF NOT EXISTS cidade (
	id int(11) primary key not null auto_increment,
    nome varchar(50) not null default '',
    populacao int not null
);

CREATE TABLE IF NOT EXISTS ponto_tur (
	id int(11) primary key not null auto_increment,
    nome varchar(50) not null default '',
    tipo enum ('Atrativo', 'Serviço', 'Equipamento', 'Infraestrutura', 'Instituição') not null,
    publicado enum ('Sim', 'Não') not null default 'Não'
);

CREATE TABLE IF NOT EXISTS coordenada (
	latitude float(10,6),
    longitude float(10,6)
);

show tables;