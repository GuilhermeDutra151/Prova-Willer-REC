create table investidores(
id serial primary key,
nome varchar (100) not null,
cpf varchar (11) unique not null,
nivel_experiencia int check (nivel_experiencia >=0)
);

create table carteiras(
id serial primary key,
investidor_id int references investidores(id),
endereco_wallet varchar (100) unique not null,
rede_blockchain varchar (100) not null,
saldo_usd decimal (10,2) not null check (saldo_usd >0),
status varchar (100) not null default 'ativa' check (status in('ativa', 'em analise', 'bloqueada', 'pausada'))
);

create table corretoras(
id serial primary key,
nome_exchange varchar (100) not null,
cnpj varchar (14) unique not null,
email_suporte varchar (100) unique not null
);

create table criptomoedas(
id serial primary key,
corretora_id int references corretoras(id),
nome_moeda varchar (100) unique not null,
preco_unitario_usd decimal not null check (preco_unitario_usd >0),
categoria varchar (100) not null default 'layer1' check (categoria in ('layer1', 'DeF1', 'Memecoin', 'Stablexoin'))
);

create table transacoes_cripto(
id serial primary key,
carteira_id int references carteiras(id),
criptomoeda_id int references criptomoedas(id),
quantidade decimal not null check(quantidade >0),
valor_pago decimal not null check (valor_pago >0),
data_transacao timestamp default current_timestamp
);

--inserçao de dados

insert into investidores(nome, cpf, nivel_experiencia) values
('Ratudo Silva', '32124545670', 18),
('Cavalo Pedro', '12312365690', 52),
('Rasputin Costa', '78785656607', 89),
('castor Miguel', '23232356070', 67),
('Markos Sim', '67676767377', 23);

insert into carteiras (investidor_id, endereco_wallet, rede_blockchain, saldo_usd, status) values
(1, '6b1.56B', 'Redechair', 6299.00, 'ativa'),
(2, '784t09yg', 'CoinMaster', 267198.00, 'pausada'),
(3, '3N560j4', 'Sesiover', 6382.00, 'bloqueada'),
(4, '7rgt-24g', 'Breakcoin', 1462.00, 'em analise'),
(5, 'gr50473g', 'EverlongCoin', 0.42, 'ativa');

insert into corretoras (nome_exchange, cnpj, email_suporte) values
('BYOD67', '44527355762267', 'eduardotrain@gmail.com'),
('NeroBank', '2273981537270', 'murillintstant@gmail.com'),
('Heroinvest', '5567245378723', 'slipkbryan@gamil.com'),
('Retrobank', '88142483015409', 'evercooked@hotmail.com'),
('SlanBank', '77998634812078', 'retrobrua@gamil.com');

insert into criptomoedas (corretora_id, nome_moeda, preco_unitario_usd, categoria) values
(1, 'Bitcoin', 45.90, 'layer1'),
(2, 'Slayercoin', 67.00, 'Memecoin'),
(3, 'DeathCoin', 23.23, 'Stablexoin'),
(4, 'Salamandra', 89.99, 'Memecoin'),
(5, 'Dualcoin', 10.67, 'DeF1');



--coulsultas avançadas

select
car.endereco_wallet,
car.rede_blockchain,
car.saldo_usd,
inv.nome,
inv.cpf,
from carteiras car
inner join investidores inv on car.investidor_id = inv.id
where car.status in('ativa', 'em analise');

select
cor.nome_exchange as corretora
sum(tra.valor_pago) as valor_total
from transacoes_cripto tra
inner join criptomoedas c on tra.criptomoeda = c.id
inner join corretoras cor on c.corretora_id = cor.id
group by cor.nome_exchange

--views

create view vw_painel_carteiras as
select
car.endereco_wallet
car.rede_blockchain
car.status
car.saldo_usd
inv.nome
inv.cpf
from carteiras car
inner join investidores inv on car.investidor_id = inv.id