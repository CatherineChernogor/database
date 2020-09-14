create table if not EXISTS `groups`(
    `id` int UNSIGNED AUTO_INCREMENT NOT NULL,
    `name` varchar(20),
    PRIMARY KEY (`id`)
);
create table if not EXISTS `products`(
    `id` int unsigned auto_increment NOT NULL,
    `name` VARCHAR(20) NOT NULL,
    `group_id` int unsigned,
    `price` DECIMAL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`)
);
create table if not EXISTS `salesmen`(
    `id` int unsigned auto_increment not null,
    `name` VARCHAR(30) not null,
    `position` float not NULL,
    PRIMARY KEY (`id`)
);
create TABLE if not EXISTS `sales`(
    `id` int unsigned auto_increment NOT NULL,
    `date` DATETIME not null,
    `salesman_id` int unsigned,
    `product_id` int unsigned,
    `amount` int NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`salesman_id`) REFERENCES `salesmen` (`id`),
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
);
insert into `groups` (`name`)
VALUES ('stationary'),
    ('meds'),
    ('food'),
    ('clothes'),
    ('sport');
insert into `products` (`name`, `group_id`, `price`)
VALUES ('cucambers green', 3, 30.60),
    ('cucambers yellow', 3, 15.90),
    ('cheese pie', 3, 60.90),
    ('jupe marron', 4, 115.90),
    ('football ball', 5, 90.90),
    ('basketball ball', 5, 85.90),
    ('pepper orange', 3, 20.90),
    ('bandage', 2, 75.90),
    ('pensil ', 1, 5.33),
    ('notebook', 1, 23.43),
    ('stickers', 1, 7.90),
    ('omega-3', 2, 150.00),
    ('black jeans', 4, 100.50),
    ('white jeans', 4, 100.50),
    ('lizard socks', 4, 90.90);
insert into `salesmen` (`name`, `position`)
values ('Alistair', 0.5),
    ('Luke', 1),
    ('Haris', 0.7),
    ('Ibrahim', 0.5),
    ('Kyle', 1.5);