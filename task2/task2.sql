-- Модифицируйте БД учета продаж торговых представителей:

-- Торговым представителям добавьте поля:
    -- имя (после фамилии) имя уже было поэтому я добавляю фамилию
    ALTER TABLE `salesmen` ADD COLUMN `surname` VARCHAR (20) NOT NULL AFTER `id` ;
    update `salesmen` set `surname` = 'Porter' where `id` =1; 
    update `salesmen` set `surname` = 'Greene' where `id` =2; 
    update `salesmen` set `surname` = 'Carroll' where `id` =3; 
    update `salesmen` set `surname` = 'Wells' where `id` =4; 
    update `salesmen` set `surname` = 'Cain' where `id` =5; 

    -- отчество (после имени)
    ALTER TABLE `salesmen` ADD COLUMN `fathername` VARCHAR (20) AFTER `name` ;

    -- дата рождения (после отчества)
    ALTER TABLE `salesmen` ADD COLUMN `dbirth` DATE NOT NULL AFTER `fathername`;
    update `salesmen` set `dbirth` = '22.04.1970' where `id` =1; 
    update `salesmen` set `dbirth` = '11.10.1973' where `id` =2; 
    update `salesmen` set `dbirth` = '12.09.1978' where `id` =3; 
    update `salesmen` set `dbirth` = '01.06.1982' where `id` =4; 
    update `salesmen` set `dbirth` = '24.10.1984' where `id` =5; 

    -- ИНН (после даты рождения)    
    ALTER TABLE `salesmen` ADD COLUMN `inn` VARCHAR(20)  AFTER `dbirth` ;

    -- сумма оклада (после ставки)
    ALTER TABLE `salesmen` ADD COLUMN `bsalary` DECIMAL NOT NULL AFTER `inn` ;  -- bsalary - basic salary
    update `salesmen` set `bsalary` = 1200 where `id` =1; 
    update `salesmen` set `bsalary` = 1380 where `id` =2; 
    update `salesmen` set `bsalary` = 1100 where `id` =3; 
    update `salesmen` set `bsalary` = 1000 where `id` =4; 
    update `salesmen` set `bsalary` = 900 where `id` =5; 


-- Товарам:
    -- закупочная цена (перед ценой)
        -- заполнить по всем товарам закупочную цену с коэффициентом 0.5
    ALTER TABLE `products` ADD COLUMN `pprice` DECIMAL NOT NULL after `group_id` ;    -- pprice - purchaise price
    update `products` set `pprice` = `price`*0.5; 

    -- артикул (после названия)
    ALTER TABLE `products` ADD COLUMN `code` VARCHAR(20)  AFTER `name` ;
    update `products` set `code` = concat(`price`*0.5,`price`/2); 
    
    -- дата изменения цены
        ALTER TABLE `products` ADD COLUMN `pchange` TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  -- pchange - price change
    
    -- флаг наличия на складе
    ALTER TABLE `products` ADD COLUMN `in_stock` TINYINT(2);
    update `products` set `in_stock` = 1;
    update `products` set `in_stock` = 0 where `group_id` = 2;

-- В журнал продаж:
    -- цену (перед количеством)
        -- заполнить цену по данным из таблицы товаров
        ALTER TABLE `sales` ADD COLUMN `price` DECIMAL after `product_id`;
        UPDATE `sales` s
        INNER JOIN `products` p ON s.product_id = p.id 
        SET s.price = p.price;
         
    -- доход компании (после количества)
        -- заполнить все проданные по данным из таблицы товаров (кол-во * цену)
        ALTER TABLE `sales` ADD COLUMN `cincome` DECIMAL after `amount`;    -- cincome - company income
        UPDATE `sales` set `cincome` = `price`*`amount`; 


    -- доход торгпреда (после дохода компании)
        -- заполнить все проданные по данным из таблицы товаров и с учетом ставки соответствующего торгпреда
        ALTER TABLE `sales` ADD COLUMN `sincome` DECIMAL after `cincome`;  -- sincome - salesman income
        UPDATE `sales` s 
        set `sincome` = `price`*`amount`*0.1*(
            select sm.position 
            from salesmen as sm 
            where s.salesman_id = sm.id
            ); 

