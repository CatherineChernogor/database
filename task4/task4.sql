-- При выполнении задания используйте таблицы из предыдущих заданий.

-- Создайте триггер на изменение цены в таблице товаров таким образом, 
-- чтобы в дополнительную таблицу сохранялись: дата изменения, старая цена, 
-- новая цена. Дополнительную таблицу (это будет некий журнал изменения цен) 
-- нужно предварительно создать.

CREATE TABLE if NOT EXISTS `price_update`(
    `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `product_id` int(10) UNSIGNED NOT NULL,
    `date` date NOT NULL,
    `old_price` decimal(10, 2) UNSIGNED NOT NULL,
    `new_price` decimal(10, 2) UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
);

DELIMITER // 
CREATE TRIGGER `set_price` AFTER
UPDATE ON `products` FOR EACH ROW 
BEGIN    
    DECLARE id INT(10);
    DECLARE dt DATE;
    DECLARE old_price DECIMAL(10, 2);
    DECLARE new_price DECIMAL(10, 2);

    SET id = OLD.`id`;
    SET dt = NEW.`pchange`;
    SET old_price = OLD.`price`;
    SET new_price = NEW.`price`;

    if old_price != new_price then

        INSERT INTO `price_update` 
        (`product_id`, `date`, `old_price`, `new_price`)
        VALUES (id, dt, old_price, new_price);
    end if;

END //
DELIMITER ;

-- Создайте триггер на удаление группы товаров таким образом, чтобы 
-- при ее удалении все товары из этой группы оказывались не привязанными 
-- ни к одной группе, а их наличие на складе менялось в положение нет в наличии.


DELIMITER //
CREATE TRIGGER `delete_group`
BEFORE DELETE ON `groups`
FOR EACH ROW
BEGIN
	DECLARE id INT(10);
	SET id = OLD.`id`;

    UPDATE `products` 
    SET `group_id` = NULL, `in_stock` = 0 
    WHERE `group_id` = id;
END //
DELIMITER ;