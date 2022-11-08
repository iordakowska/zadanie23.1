-- Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko). W tabeli mogą być dodatkowe kolumny, które uznasz za niezbędne.

CREATE TABLE employees (
	id INT primary key auto_increment,
    first_name varchar(30),
    last_name varchar(30),
    payment decimal(8,2),
    birth_date date,
	position varchar(30)
);

-- Wstawia do tabeli co najmniej 6 pracowników

INSERT INTO employees 
	(first_name, last_name, payment, birth_date, position)
VALUES 
	('Maria', 'Kowalska', 3200, '2000-10-12', 'sekretarka'),
    ('Jan' ,'Kowalski' ,5000 ,'1998-07-12' ,'analityk'),
    ('Marcin' ,'Malinowski' ,5200 ,'1994-05-23' ,'analityk'),
    ('Hanna' ,'Puchalska' ,3800 ,'1994-06-10' ,'kadrowa'),
    ('Anna' ,'Karp' ,4200 ,'1986-07-15' ,'księgowa'),
    ('Alina' ,'Nowak' ,4100 ,'1989-01-12' ,'księgowa');
    
-- Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku

SELECT * FROM employees order by last_name ASC;

-- Pobiera pracowników na wybranym stanowisku

SELECT * FROM employees where position LIKE 'analityk';

-- Pobiera pracowników, którzy mają co najmniej 30 lat

select * from employees where year(curdate())-year(birth_date)>=30;

-- Zwiększa wypłatę pracowników na wybranym stanowisku o 10%

update employees set payment = payment * 1.1 where position = 'kadrowa'; 

-- Pobiera najmłodszego pracowników (uwzględnij przypadek, że może być kilku urodzonych tego samego dnia)

select * from employees where birth_date =(select max(birth_date) from employees);

-- Usuwa tabelę pracownik

drop table employees;

-- Tworzy tabelę stanowisko (nazwa stanowiska, opis, wypłata na danym stanowisku)
CREATE TABLE title (
	id INT primary key auto_increment,
    title_name varchar(30),
    desc_title varchar(30),
    payment decimal(8,2)
);
-- Tworzy tabelę adres (ulica+numer domu/mieszkania, kod pocztowy, miejscowość)
CREATE TABLE adress (
	id INT primary key auto_increment,
    street varchar(30),
    post_code varchar(30),
	city varchar(30)
);
-- Tworzy tabelę pracownik (imię, nazwisko) + relacje do tabeli stanowisko i adres
CREATE TABLE employee (
	id INT primary key auto_increment,
    title_id int,
    adress_id int,
    first_name varchar(30),
    last_name varchar(30),
    foreign key (title_id) references title (id),
    foreign key (adress_id) references adress (id)
);

-- Dodaje dane testowe (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)

insert into title 
	(name, title, payment)
values
	('kierownik', 'kierowanie zespołem', 5000),
    ('magazynier', 'praca na magazynie',3000),
    ('księgowa', 'rozliczanie wydatków',4000);
    
insert into adress
	(street, post_code, city)
values
	('Piaskowa 2', '05-860', 'Płochocin'),
    ('Kościuszki 28/6', '05-800', 'Pruszków'),
    ('Radomska 37', '26-804', 'Stromiec');
    
insert into employee
	(title_id, adress_id, first_name, last_name)
values
	(1, 2, 'Anna', 'Nowacka'),
    (2, 1, 'Adam', 'Kot'),
    (2, 3, 'Jan', 'Matysiak'),
    (3, 2, 'Monika', 'Styk');

 
-- Pobiera pełne informacje o pracowniku (imię, nazwisko, adres, stanowisko)

select
	employee.first_name, employee.last_name, adress.post_code, adress.city, adress.street, title.title_name
from 
	employee 
    join adress on employee.adress_id = adress.id    
    join title on employee.title_id = title.id;
    
-- Oblicza sumę wypłat dla wszystkich pracowników w firmie

select sum(payment) From employee join title on employee.title_id = title.id;

-- Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 (albo innym, który będzie miał sens dla Twoich danych testowych)

select 
	employee.first_name, employee.last_name
from
	employee
    join adress on employee.adress_id = adress.id where adress.post_code = '05-860';
