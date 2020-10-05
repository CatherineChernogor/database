-- Для базы данных учета торговых представителей из предыдущих заданий, составьте следующие функции и процедуры.

-- Функция, определяющая по дате рождения, является ли человек юбиляром в текущем году. Функция возвращает возраст юбиляра, в противном случае – NULL.

drop function if exists isJub;

DELIMITER //
CREATE FUNCTION `isJub`(s DATE)
RETURNS INTEGER
BEGIN
    declare d int;
    set d = year(s);
    IF d%5=0 THEN
            return year(now())-d;
        ELSE
            return null;
        END IF;
END//
DELIMITER ;

select isJub('2000-09-27');


-- Функция, преобразующая значение ФИО в фамилию с инициалами (например, Иванов Иван Сергеевич в Иванов И.С.). При невозможности преобразования функция возвращает строку ######.

drop function if exists getShortName;

DELIMITER //
CREATE FUNCTION `getShortName`(lastName varchar(40), firstName varchar(40), fatherName varchar(40))
RETURNS varchar(40)
BEGIN
    declare temp varchar(40);
    set temp = concat_ws(' ', lastName, substr(firstName, 1, 1));
    set temp = concat_ws('. ', temp, substr(fatherName, 1, 1));
    return concat(temp,'.');
END//
DELIMITER ;

select getShortName('Иванов', 'Иван', 'Сергеевич');


-- Функция, высчитывающая доход торгпреда с продажи, исходя из ставки и суммы продажи.

drop function if exists getSalesmanIncome;

DELIMITER //
CREATE FUNCTION `getSalesmanIncome`(position float,  summa decimal)
RETURNS DECIMAL
BEGIN
    return position*summa*0.1;
END//
DELIMITER ;

select getSalesmanIncome(0.5, 100);


-- Функция, высчитывающая доход компании с продажи, исходя из стоимости товара и проданного количества.

drop function if exists getCompanyIncome;

DELIMITER //
CREATE FUNCTION `getCompanyIncome`(price decimal,  amount int)
RETURNS DECIMAL
BEGIN
    return price*amount;
END//
DELIMITER ;

select getCompanyIncome(55.0, 100);


-- Процедура, выводящая список всех торгпредов–юбиляров текущего года (с указанием даты юбилея и возраста).

drop procedure if exists `getJub`;

delimiter //
create procedure `getJub`()
begin
    select concat_ws(' ', name, surname) as name, dbirth, timestampdiff(year, dbirth, now() ) as age
    from salesmen
    where isJub(dbirth) !=-1;

end //
delimiter ;

call getJub();

-- Процедура, выводящая список всех товаров в заданной группе (по id группы) в виде: товар, группа, артикул, отпускная цена, наличие на складе.

drop procedure if exists `getProd`;

delimiter //
create procedure `getProd`( group_id int)
begin
    select p.name as name, g.name as `group`, code, pprice, in_stock
    from groups as g, products as p
    where g.id = p.group_id 
    and g.id = group_id;
end //
delimiter ;

call getProd(5);

-- Процедура, выдающая по названию товара, список его продаж с указанием ФИО торгпреда (в формате Фамилия И.О.) за последние 7 дней (по умолчанию) / 14 дней / 30 дней.
drop procedure if exists `getProd`;

delimiter //
create procedure `getProd`( product_name varchar(30), period int)

begin
    
    if period is NULL then 
        set period = 30;
    end if;

    select sm.name, sm.surname, s.date
    from sales as s, salesmen as sm, products as p

    where s.salesman_id = sm.id 
    and s.product_id = p.id 
    and p.name = product_name
    and timestampdiff(day, s.date, now()) <= period

    order by s.id;
end //
delimiter ;

call getProd('basketball ball', null);

-- Процедура, выводящая сведения о несоответствии цены в журнале продаж 
-- заявленной цене самого товара с учетом времени последнего изменения цены 
-- (если изменение цены произошло позднее даты продажи, такие данные не учитывать). 
-- Если таких случаев не обнаружено, процедура должна выводить сообщение об этом.
drop procedure if exists `getOddPrice`;

delimiter // 
create procedure `getOddPrice`()
BEGIN

    if (
        select count(p.id)
        from products as p, sales as s
        where p.id = s.product_id
        and s.price != p.price
        )
        then 

        select p.name, s.price, p.price, s.date
        from products as p, sales as s
        where p.id = s.product_id
        and s.price != p.price;
    else 
        select "there's no such thing";
    end if;

END //
delimiter ;

call getOddPrice();