create table tb_piloto(P_id int not null primary key, 
P_nome varchar(25) not null,
P_idade int not null)ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table tb_carros(C_id int not null primary key, 
C_marca varchar(25) not null,
C_cor varchar(15) not null)ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table tb_reservas(P_id int not null , 
C_id int not null,
R_dia varchar(8) not null,
FOREIGN KEY (`P_id`) REFERENCES `tb_piloto` (`P_id`) ON DELETE cascade,
FOREIGN KEY (`C_id`) REFERENCES `tb_carros` (`C_id`) ON DELETE cascade)ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into tb_piloto values(
12, 'domingos', 25), 
(25, 'fernando', 18),
(13, 'felipe', 22),
(18, 'massa', 36),
(29, 'muchilunda', 27),
(65, 'ambrosio', 29),
(33, 'jose', 24),
(22, 'joaquim', 21),
(69, 'djacira', 34);

insert into tb_piloto values(
1, 'antonio', 25), 
(2, 'julio', 18),
(3, 'marcelina', 22),
(4, 'mulonga', 36),
(5, 'alberto', 27),
(6, 'capusso', 29),
(7, 'paulo', 24),
(8, 'marlene', 21),
(9, 'andre', 34);

insert into tb_carros values(
101, 'Toyota', 'Branca'), 
(102, 'Ford', 'Azul'),
(105, 'Mitsubish', 'Verde'),
(108, 'Mazda', 'Preto'),
(109, 'Chevrolet', 'Laranja'),
(106, 'Onda', 'Vermelho');

insert into tb_reservas values(
12, 101, 'Dia1'), 
(12, 102, 'Dia2'),
(13, 105, 'Dia3'),
(12, 105, 'Dia3'),
(29, 108, 'Dia4'),
(13, 108, 'Dia5'),
(29, 109, 'Dia6'),
(29, 106, 'Dia7'),
(12, 109, 'Dia7');

insert into tb_reservas values(
1, 106, 'Dia28'),
(2, 106, 'Dia28'),
(3, 109, 'Dia28'),
(5, 109, 'Dia28'),
(8, 106, 'Dia30'),
(3, 106, 'Dia26'),
(1, 106, 'Dia27'),
(6, 106, 'Dia28');

//Selecionar todos o pilotos que reservaram carros Verdes
select P.P_nome from tb_piloto P 
where P.P_id in(
select R.P_id from tb_reservas R 
where R.C_id in (
select C.C_id from tb_carros C 
where C.C_cor = 'Verde'));

//Me de os nomes de todos o pilotos maiores de 26 anos, que reservaram carros Verdes no dia 3
select P.P_nome from tb_piloto P where P.P_id in
(select P.P_id from tb_piloto P where P.P_idade >= 26 and P.P_id in
(select R.P_id from tb_reservas R where R.C_id in 
(select R.C_id from tb_reservas R where R.R_dia = 'Dia3' and R.C_id in
(select C.C_id from tb_carros C where C.C_cor = 'Verde'))));

select * from tb_piloto P where P.P_idade >= 26;

delete BEFOR_INSER_ON_CONTA from tb_contas;

create table tb_contas(conta_id int auto_increment not null primary key, 
conta_cliente varchar(25) not null,
conta_saldo double not null)ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table tb_emprestimo(empretimo_id int auto_increment not null primary key, 
conta_id int not null,
emprestimo_montante double not null,
emprestimo_data date not null,
FOREIGN KEY (`conta_id`) REFERENCES `tb_contas` (`conta_id`) ON DELETE cascade)ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert tb_emprestimo (conta_id, emprestimo_montante, emprestimo_data) values(
1, 1000, '2017-04-25'), 
(1, 20000, '2016-03-26'),
(9, 8000, '2015-01-12'),
(2, 1200, '2017-05-13'),
(1, 10000, '2017-02-1'),
(2, 1000, '2013-06-22'),
(2, 6000, '2017-08-12'),
(4, 25000, '2010-01-25'),
(4, 20000, '2016-03-26'),
(9, 8000, '2015-01-12'),
(4, 1200, '2017-05-13'),
(4, 10000, '2017-02-1'),
(2, 1000, '2013-06-22'),
(2, 6000, '2017-08-12'),
(1, 25000, '2010-03-25'),
(5, 10000, '2010-12-25');

insert into tb_contas(conta_cliente, conta_saldo) values(
'domingos', 1000000), 
('fernando', 50000),
('felipe', 80000),
('massa', 36000),
('muchilunda', 200000),
('ambrosio', 1000),
('jose', 6000),
('joaquim', 25000),
('djacira', 10000);

//selecionar os clientes com mais de 2 emprestimos
select c.conta_cliente, count(emp.emprestimo_data) as 'Quantidade de Empretimos'
from tb_contas c inner join tb_emprestimo emp on c.conta_id = emp.conta_id group by c.conta_cliente 
having count(emp.emprestimo_data) > 2;

//De os clientes com montante de emprestimos entre 1000 e 1000000
select c.conta_cliente, sum(emp.emprestimo_montante) as 'Quantidade de Empretimos'
from tb_contas c inner join tb_emprestimo emp on c.conta_id = emp.conta_id group by c.conta_cliente 
having sum(emp.emprestimo_montante) between 1000 and 1000000;

//De o valor medio de Emprestimos bancarios
select count(emp.emprestimo_montante) as 'Quantidade de Emprestimos',
sum(emp.emprestimo_montante) as 'Valor total de Empretimos',
avg(emp.emprestimo_montante) as 'Valor medio de emprestimos' from tb_emprestimo emp; 


insert into tb_contas(conta_cliente, conta_saldo) value(
'vivaldo', 600000);

start transaction;
update tb_contas set conta_saldo = conta_saldo + 1000
where conta_cliente = 'domingos';

update tb_contas set conta_saldo = conta_saldo - 1000
where conta_cliente = 'fernando';
rollback;

delimiter //
create trigger BEFOR_INSER_ON_CONTA before insert on tb_contas for each row
begin
call dar_bonus(new.conta_saldo, @saldoAtual);
set new.conta_saldo = new.conta_saldo + @saldoAtual;
end
//

delimiter //
create trigger BEFOR_INSER_ON_CONTA_DAR_BONUS_DE_DEZ before insert on tb_contas for each row
begin
call dar_bonus_de_dez(new.conta_saldo, @saldoAtual);
set new.conta_saldo = new.conta_saldo + @saldoAtual;
end
//

delimiter //
create procedure dar_bonus(in in_saldo_conta double, out out_saldo_conta double)
begin
	if (in_saldo_conta > 500000) then		
		set out_saldo_conta = in_saldo_conta * 0.10;
	else
		set out_saldo_conta = 0;
    end if;
end
//

delimiter //
create procedure dar_bonus_de_dez(in in_saldo_conta double, out out_saldo_conta double)
begin
	if (in_saldo_conta < 100) then		
		set out_saldo_conta = in_saldo_conta + 10;
	else
		set out_saldo_conta = 0;
    end if;
end
//


