--1
--    кол-во товаров каждой категории
select g.name,
    count(*)
from products as p,
    groups as g
where g.id = p.group_id
group by group_id;


--    среднюю цену товара каждой категории
select g.name,
    avg(p.price)
from products as p,
    groups as g
where g.id = p.group_id
group by group_id;


--    общее количество единиц каждого товара проданного за все время
select p.name,
    sum(s.amount)
from products as p,
    sales as s
where p.id = s.product_id
group by s.product_id;


--    среднемесячное продаваемое количество единиц каждого товара
select p.name,
    sum(s.amount) / TIMESTAMPDIFF(
        month,
        cast(min(s.date) as date),
        cast(max(s.date) as date)
    ) -- количество месяцев
from products as p,
    sales as s
where p.id = s.product_id
group by s.product_id;


--    отчет по продажам на каждый день каждого товара с указанием количества и выручки
select s.date,
    p.name,
    sum(s.amount),
    sum(s.amount * p.price)
from products as p,
    sales as s
where p.id = s.product_id
group by s.product_id,
    s.date
order by s.date
limit 20;


--    отчет по продажам на каждый день каждой товарной группы с указанием количества и выручки
select s.date,
    g.name,
    sum(s.amount),
    sum(s.amount * p.price)
from products as p,
    sales as s,
    groups as g
where p.id = s.product_id
    and g.id = p.group_id
group by p.group_id,
    s.date
order by s.date
limit 20;



--2
кол-во товаров продаваемых каждым представителем в месяц
select month(s.date),
    sm.name,
    sum(s.amount)
from sales as s,
    salesmen as sm
where s.salesman_id = sm.id
group by month(s.date),
    s.salesman_id
limit 20;


--    среднемесячный оборот по каждому представителю
select sm.name,
    sum(s.amount * p.price) / TIMESTAMPDIFF(
        month,
        cast(min(`s.date`) as date),
        cast(max(`s.date`) as date)
    ) -- количество месяцев
from sales as s,
    salesmen as sm,
    products as p
where s.salesman_id = sm.id
    and s.product_id = p.id
group by s.salesman_id
limit 20;



--3
--    Определите зарплату каждого представителя по каждому месяцу, 
--    исходя из его оборота и ставки,и посчитайте налог НДФЛ 
--    по ставке 13%, подлежащий уплате.
--    зарплата = оборот * 10% * ставку * (100-13)%
select month(s.date),
    sm.name,
    (sum(s.amount * p.price) * 0.10) * sm.position * 0.87 as salary,
    (sum(s.amount * p.price) * 0.10) * sm.position * 0.13 as ndfl
from sales as s,
    salesmen as sm,
    products as p
where s.salesman_id = sm.id
    and p.id = s.product_id
group by month(s.date),
    s.salesman_id
limit 15;



--4
--    самых продаваемых товаров
select p.name
from sales as s,
    products as p
where p.id = s.product_id
group by s.product_id
order by sum(amount) desc
limit 15;


--    самых доходных групп товаров
select g.name
from sales as s,
    products as p,
    groups as g
where p.id = s.product_id
    and g.id = p.group_id
group by g.name
order by sum(amount) desc
limit 15;


--    успешных торговых представителей исходя из количества проданных товаров
select sm.name
from sales as s,
    salesmen as sm
where s.salesman_id = sm.id
group by s.salesman_id
order by sum(s.amount) desc
limit 20;


--    успешных торговых представителей исходя из количества проданных товаров
select sm.name
from sales as s,
    salesmen as sm,
    products as p
where s.salesman_id = sm.id
    and p.id = s.product_id
group by s.salesman_id
order by sum(s.amount * p.price) desc
limit 20;


--    успешных торговых представителей исходя из заработка
select sm.name
from sales as s,
    salesmen as sm,
    products as p
where s.salesman_id = sm.id
    and p.id = s.product_id
group by s.salesman_id
order by (sum(s.amount * p.price) * 0.10) * sm.position * 0.87 / TIMESTAMPDIFF(
        month,
        cast(min(`s.date`) as date),
        cast(max(`s.date`) as date)
    ) -- количество месяцев
    desc
limit 20;
