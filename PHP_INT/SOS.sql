-- phpMyAdmin SQL Dump
-- version 5.2.3-1.red80
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Май 14 2026 г., 05:20
-- Версия сервера: 10.11.16-MariaDB
-- Версия PHP: 8.1.32

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `SOS`
--

-- --------------------------------------------------------

--
-- Структура таблицы `brands`
--

CREATE TABLE `brands` (
  `id` int(11) NOT NULL COMMENT 'ID бренда',
  `name` varchar(100) NOT NULL COMMENT 'Название бренда',
  `logo` varchar(255) DEFAULT NULL COMMENT 'Логотип бренда',
  `country` varchar(100) DEFAULT NULL COMMENT 'Страна производитель',
  `description` text DEFAULT NULL COMMENT 'Описание бренда',
  `slug` varchar(100) NOT NULL COMMENT 'URL-адрес',
  `is_original` tinyint(1) DEFAULT 0 COMMENT 'Оригинальная запчасть',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Бренды производителей';

--
-- Дамп данных таблицы `brands`
--

INSERT INTO `brands` (`id`, `name`, `logo`, `country`, `description`, `slug`, `is_original`, `created_at`) VALUES
(1, 'АвтоВАЗ', NULL, 'Россия', 'Оригинальные запчасти LADA', 'avtovaz', 1, '2026-05-07 03:39:31'),
(2, 'ГАЗ', NULL, 'Россия', 'Оригинальные запчасти ГАЗ', 'gaz-brand', 1, '2026-05-07 03:39:31'),
(3, 'УАЗ', NULL, 'Россия', 'Оригинальные запчасти УАЗ', 'uaz-brand', 1, '2026-05-07 03:39:31'),
(4, 'BOSCH', NULL, 'Германия', 'Качественные автозапчасти', 'bosch', 0, '2026-05-07 03:39:31'),
(5, 'FEBI', NULL, 'Германия', 'Запчасти для российских авто', 'febi', 0, '2026-05-07 03:39:31'),
(6, 'LYNX', NULL, 'Россия', 'Российский производитель', 'lynx', 0, '2026-05-07 03:39:31'),
(7, 'ЛУКОЙЛ', NULL, 'Россия', 'Масла и жидкости', 'lukoil', 0, '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL COMMENT 'ID записи корзины',
  `user_id` int(11) DEFAULT NULL COMMENT 'ID пользователя',
  `session_id` varchar(100) DEFAULT NULL COMMENT 'ID сессии',
  `product_id` int(11) NOT NULL COMMENT 'ID товара',
  `количество` int(11) NOT NULL DEFAULT 1 COMMENT 'Количество',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Корзина покупок';

--
-- Дамп данных таблицы `cart`
--

INSERT INTO `cart` (`id`, `user_id`, `session_id`, `product_id`, `количество`, `created_at`, `updated_at`) VALUES
(1, 3, NULL, 2, 1, '2026-05-07 03:39:31', '2026-05-07 03:39:31'),
(2, 3, NULL, 15, 2, '2026-05-07 03:39:31', '2026-05-07 03:39:31'),
(3, 4, NULL, 11, 1, '2026-05-07 03:39:31', '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `cart_items`
--

CREATE TABLE `cart_items` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `session_id` varchar(100) DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Корзина покупок';

-- --------------------------------------------------------

--
-- Структура таблицы `car_brands`
--

CREATE TABLE `car_brands` (
  `id` int(11) NOT NULL COMMENT 'ID марки автомобиля',
  `name` varchar(100) NOT NULL COMMENT 'Название марки',
  `slug` varchar(100) NOT NULL COMMENT 'URL-адрес',
  `logo` varchar(255) DEFAULT NULL COMMENT 'Путь к логотипу',
  `завод_производитель` varchar(200) DEFAULT NULL COMMENT 'Завод-изготовитель',
  `страна` varchar(100) DEFAULT 'Россия' COMMENT 'Страна производства',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Марки российских автомобилей';

--
-- Дамп данных таблицы `car_brands`
--

INSERT INTO `car_brands` (`id`, `name`, `slug`, `logo`, `завод_производитель`, `страна`, `created_at`) VALUES
(1, 'LADA (ВАЗ)', 'lada-vaz', NULL, 'АвтоВАЗ, г. Тольятти', 'Россия', '2026-05-07 03:39:31'),
(2, 'ГАЗ', 'gaz', NULL, 'Горьковский автомобильный завод, г. Нижний Новгород', 'Россия', '2026-05-07 03:39:31'),
(3, 'УАЗ', 'uaz', NULL, 'Ульяновский автомобильный завод, г. Ульяновск', 'Россия', '2026-05-07 03:39:31'),
(4, 'КамАЗ', 'kamaz', NULL, 'Камский автомобильный завод, г. Набережные Челны', 'Россия', '2026-05-07 03:39:31'),
(5, 'Москвич', 'moskvich', NULL, 'Московский автомобильный завод (АЗЛК)', 'Россия', '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `car_models`
--

CREATE TABLE `car_models` (
  `id` int(11) NOT NULL COMMENT 'ID модели автомобиля',
  `car_brand_id` int(11) NOT NULL COMMENT 'ID марки автомобиля',
  `name` varchar(100) NOT NULL COMMENT 'Название модели',
  `slug` varchar(150) NOT NULL COMMENT 'URL-адрес',
  `поколение` varchar(100) DEFAULT NULL COMMENT 'Поколение модели',
  `год_выпуска_с` int(11) DEFAULT NULL COMMENT 'Год начала выпуска',
  `год_выпуска_по` int(11) DEFAULT NULL COMMENT 'Год окончания выпуска',
  `тип_кузова` varchar(50) DEFAULT NULL COMMENT 'Тип кузова',
  `тип_двигателя` varchar(50) DEFAULT NULL COMMENT 'Тип двигателя',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Модели российских автомобилей';

--
-- Дамп данных таблицы `car_models`
--

INSERT INTO `car_models` (`id`, `car_brand_id`, `name`, `slug`, `поколение`, `год_выпуска_с`, `год_выпуска_по`, `тип_кузова`, `тип_двигателя`, `created_at`) VALUES
(1, 1, 'LADA 2107', 'lada-2107', 'Классика', 1982, 2012, 'Седан', NULL, '2026-05-07 03:39:31'),
(2, 1, 'LADA Granta', 'lada-granta', 'Первое поколение', 2011, NULL, 'Седан/Лифтбек', NULL, '2026-05-07 03:39:31'),
(3, 1, 'LADA Vesta', 'lada-vesta', 'Первое поколение', 2015, NULL, 'Седан/Универсал', NULL, '2026-05-07 03:39:31'),
(4, 1, 'LADA Niva Legend', 'lada-niva-legend', 'Классическая Нива', 1977, NULL, 'Внедорожник', NULL, '2026-05-07 03:39:31'),
(5, 1, 'LADA Niva Travel', 'lada-niva-travel', 'Современная Нива', 2020, NULL, 'Внедорожник', NULL, '2026-05-07 03:39:31'),
(6, 2, 'Газель NEXT', 'gazel-next', 'Современная Газель', 2013, NULL, 'Фургон/Бортовой', NULL, '2026-05-07 03:39:31'),
(7, 2, 'ГАЗ-3110 Волга', 'gaz-3110-volga', 'Волга', 1997, 2005, 'Седан', NULL, '2026-05-07 03:39:31'),
(8, 3, 'УАЗ Патриот', 'uaz-patriot', 'Патриот', 2005, NULL, 'Внедорожник', NULL, '2026-05-07 03:39:31'),
(9, 3, 'УАЗ Буханка', 'uaz-buhanka', 'СГР', 1965, NULL, 'Микроавтобус', NULL, '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL COMMENT 'ID категории',
  `name` varchar(100) NOT NULL COMMENT 'Название категории',
  `slug` varchar(100) NOT NULL COMMENT 'URL-адрес',
  `parent_id` int(11) DEFAULT NULL COMMENT 'ID родительской категории',
  `description` text DEFAULT NULL COMMENT 'Описание категории',
  `image` varchar(255) DEFAULT NULL COMMENT 'Путь к изображению',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Категории автозапчастей';

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `parent_id`, `description`, `image`, `created_at`) VALUES
(1, 'Двигатель', 'engine', NULL, 'Детали двигателя', NULL, '2026-05-07 03:39:31'),
(2, 'Трансмиссия', 'transmission', NULL, 'КПП, сцепление, привод', NULL, '2026-05-07 03:39:31'),
(3, 'Тормозная система', 'brakes', NULL, 'Тормозные колодки, диски', NULL, '2026-05-07 03:39:31'),
(4, 'Подвеска', 'suspension', NULL, 'Амортизаторы, рычаги', NULL, '2026-05-07 03:39:31'),
(5, 'Электрика', 'electrical', NULL, 'Стартеры, генераторы', NULL, '2026-05-07 03:39:31'),
(6, 'Фильтры', 'filters', NULL, 'Масляные, воздушные фильтры', NULL, '2026-05-07 03:39:31'),
(7, 'Масла и жидкости', 'oils', NULL, 'Моторные масла, антифриз', NULL, '2026-05-07 03:39:31'),
(8, 'Поршневая группа', 'piston-group', 1, 'Поршни, кольца, пальцы', NULL, '2026-05-07 03:39:31'),
(9, 'ГРМ', 'timing', 1, 'Ремни, цепи ГРМ', NULL, '2026-05-07 03:39:31'),
(10, 'Сцепление', 'clutch', 2, 'Диски, корзины сцепления', NULL, '2026-05-07 03:39:31'),
(11, 'Амортизаторы', 'shock-absorbers', 4, 'Передние, задние амортизаторы', NULL, '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `clients`
--

CREATE TABLE `clients` (
  `id` int(11) NOT NULL,
  `фамилия` varchar(100) NOT NULL,
  `имя` varchar(100) NOT NULL,
  `отчество` varchar(100) DEFAULT NULL,
  `телефон` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `адрес` text DEFAULT NULL,
  `источник_обращения` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `discount_coupons`
--

CREATE TABLE `discount_coupons` (
  `id` int(11) NOT NULL COMMENT 'ID купона',
  `название` varchar(100) NOT NULL COMMENT 'Название акции',
  `промокод` varchar(50) DEFAULT NULL COMMENT 'Промокод',
  `тип_скидки` enum('процент','фиксированная_сумма') DEFAULT 'процент' COMMENT 'Тип скидки',
  `значение_скидки` decimal(10,2) NOT NULL COMMENT 'Значение скидки',
  `минимальная_сумма_заказа` decimal(10,2) DEFAULT NULL COMMENT 'Мин. сумма заказа',
  `дата_начала` timestamp NULL DEFAULT NULL COMMENT 'Дата начала',
  `дата_окончания` timestamp NULL DEFAULT NULL COMMENT 'Дата окончания',
  `лимит_использований` int(11) DEFAULT NULL COMMENT 'Лимит использований',
  `использовано_раз` int(11) DEFAULT 0 COMMENT 'Использовано раз',
  `активно` tinyint(1) DEFAULT 1 COMMENT 'Активен',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Скидочные купоны';

--
-- Дамп данных таблицы `discount_coupons`
--

INSERT INTO `discount_coupons` (`id`, `название`, `промокод`, `тип_скидки`, `значение_скидки`, `минимальная_сумма_заказа`, `дата_начала`, `дата_окончания`, `лимит_использований`, `использовано_раз`, `активно`, `created_at`) VALUES
(1, 'Сезонная скидка 10%', 'SEASON10', 'процент', 10.00, 3000.00, '2024-12-31 17:00:00', '2025-12-30 17:00:00', 100, 0, 1, '2026-05-07 03:39:31'),
(2, 'Скидка 500 рублей', 'FLAT500', 'фиксированная_сумма', 500.00, 5000.00, '2024-12-31 17:00:00', '2025-06-29 17:00:00', 50, 0, 1, '2026-05-07 03:39:31'),
(3, 'Новый клиент', 'WELCOME15', 'процент', 15.00, NULL, '2024-12-31 17:00:00', '2025-12-30 17:00:00', 1000, 0, 1, '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `employees`
--

CREATE TABLE `employees` (
  `id` int(11) NOT NULL,
  `фамилия` varchar(100) NOT NULL,
  `имя` varchar(100) NOT NULL,
  `отчество` varchar(100) DEFAULT NULL,
  `должность` varchar(100) DEFAULT 'рабочий',
  `телефон` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `ставка_час` decimal(10,2) DEFAULT 0.00,
  `активно` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `favorites`
--

CREATE TABLE `favorites` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT 1,
  `тип` varchar(20) DEFAULT 'услуга',
  `service_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `favorites`
--

INSERT INTO `favorites` (`id`, `user_id`, `тип`, `service_id`, `product_id`, `created_at`) VALUES
(1, 1, 'услуга', 6, NULL, '2026-05-14 04:02:31'),
(2, 1, 'услуга', 17, NULL, '2026-05-14 04:02:31'),
(3, 1, 'услуга', 21, NULL, '2026-05-14 04:02:31');

-- --------------------------------------------------------

--
-- Структура таблицы `objects`
--

CREATE TABLE `objects` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `адрес` text NOT NULL,
  `тип_объекта` varchar(50) DEFAULT 'квартира',
  `площадь_общая` decimal(8,2) DEFAULT NULL,
  `количество_комнат` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL COMMENT 'ID заказа',
  `номер_заказа` varchar(20) NOT NULL COMMENT 'Номер заказа',
  `user_id` int(11) DEFAULT NULL COMMENT 'ID пользователя',
  `статус` enum('новый','в_обработке','отправлен','доставлен','отменен') DEFAULT 'новый' COMMENT 'Статус',
  `итоговая_сумма` decimal(10,2) NOT NULL COMMENT 'Сумма заказа',
  `адрес_доставки` text NOT NULL COMMENT 'Адрес доставки',
  `город_доставки` varchar(100) DEFAULT NULL COMMENT 'Город',
  `область_доставки` varchar(100) DEFAULT NULL COMMENT 'Область',
  `почтовый_индекс` varchar(20) DEFAULT NULL COMMENT 'Индекс',
  `контактный_телефон` varchar(20) DEFAULT NULL COMMENT 'Телефон',
  `контактный_email` varchar(100) DEFAULT NULL COMMENT 'Email',
  `способ_оплаты` varchar(50) DEFAULT NULL COMMENT 'Способ оплаты',
  `статус_оплаты` enum('ожидает','оплачен','возврат') DEFAULT 'ожидает' COMMENT 'Статус оплаты',
  `способ_доставки` varchar(50) DEFAULT NULL COMMENT 'Способ доставки',
  `трек_номер` varchar(100) DEFAULT NULL COMMENT 'Трек-номер',
  `комментарий_к_заказу` text DEFAULT NULL COMMENT 'Комментарий',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Заказы покупателей';

--
-- Дамп данных таблицы `orders`
--

INSERT INTO `orders` (`id`, `номер_заказа`, `user_id`, `статус`, `итоговая_сумма`, `адрес_доставки`, `город_доставки`, `область_доставки`, `почтовый_индекс`, `контактный_телефон`, `контактный_email`, `способ_оплаты`, `статус_оплаты`, `способ_доставки`, `трек_номер`, `комментарий_к_заказу`, `created_at`, `updated_at`) VALUES
(1, 'ORD-2025-0001', 3, 'доставлен', 4450.00, 'ул. Ленина, д. 15, кв. 42', 'Москва', NULL, NULL, '+7(900)333-44-55', 'ivan@mail.ru', 'Карта онлайн', 'оплачен', 'Курьерская доставка', NULL, NULL, '2026-05-07 03:39:31', '2026-05-07 03:39:31'),
(2, 'ORD-2025-0002', 4, 'отправлен', 3200.00, 'пр. Победы, д. 120, кв. 5', 'Санкт-Петербург', NULL, NULL, '+7(900)444-55-66', 'petr@mail.ru', 'Наличными при получении', 'ожидает', 'Почта России', NULL, NULL, '2026-05-07 03:39:31', '2026-05-07 03:39:31'),
(3, 'ORD-2025-0003', 3, 'в_обработке', 6300.00, 'ул. Ленина, д. 15, кв. 42', 'Москва', NULL, NULL, '+7(900)333-44-55', 'ivan@mail.ru', 'Карта онлайн', 'оплачен', 'Курьерская доставка', NULL, NULL, '2026-05-07 03:39:31', '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL COMMENT 'ID позиции заказа',
  `order_id` int(11) NOT NULL COMMENT 'ID заказа',
  `product_id` int(11) DEFAULT NULL COMMENT 'ID товара',
  `название_товара` varchar(255) NOT NULL COMMENT 'Название товара',
  `артикул` varchar(50) DEFAULT NULL COMMENT 'Артикул',
  `бренд` varchar(100) DEFAULT NULL COMMENT 'Бренд',
  `количество` int(11) NOT NULL COMMENT 'Количество',
  `цена` decimal(10,2) NOT NULL COMMENT 'Цена за единицу',
  `общая_стоимость` decimal(10,2) NOT NULL COMMENT 'Общая стоимость'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Позиции в заказе';

--
-- Дамп данных таблицы `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `название_товара`, `артикул`, `бренд`, `количество`, `цена`, `общая_стоимость`) VALUES
(1, 1, 1, 'Поршень двигателя ВАЗ 2101-2107 (d=76мм)', '2101-1000100', 'АвтоВАЗ', 2, 1250.00, 2500.00),
(2, 1, 13, 'Фильтр масляный ВАЗ классика', '2101-1101000', 'LYNX', 2, 250.00, 500.00),
(3, 1, 7, 'Амортизатор передний ВАЗ 2101-2107', '2101-2905004', 'LYNX', 1, 950.00, 950.00),
(4, 1, 18, 'Тормозные колодки передние ВАЗ 2101-2107', '2101-3505090', 'LYNX', 1, 650.00, 650.00),
(5, 2, 5, 'Сцепление в сборе ВАЗ 2101-2107', '2101-1601130', 'АвтоВАЗ', 1, 3200.00, 3200.00),
(6, 3, 8, 'Амортизатор передний LADA Vesta', '2123-2905004', 'LYNX', 2, 1800.00, 3600.00),
(7, 3, 14, 'Фильтр масляный LADA Vesta/Granta', '2123-1101000', 'BOSCH', 1, 450.00, 450.00),
(8, 3, 4, 'Ремень ГРМ LADA Vesta/Granta', '2123-1006030', 'АвтоВАЗ', 1, 1200.00, 1200.00);

-- --------------------------------------------------------

--
-- Структура таблицы `page_views`
--

CREATE TABLE `page_views` (
  `id` int(11) NOT NULL,
  `page` varchar(200) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL COMMENT 'ID товара',
  `артикул` varchar(50) NOT NULL COMMENT 'Артикул запчасти',
  `название` varchar(255) NOT NULL COMMENT 'Название запчасти',
  `slug` varchar(255) NOT NULL COMMENT 'URL-адрес',
  `описание` text DEFAULT NULL COMMENT 'Полное описание',
  `краткое_описание` varchar(500) DEFAULT NULL COMMENT 'Краткое описание',
  `category_id` int(11) DEFAULT NULL COMMENT 'ID категории',
  `brand_id` int(11) DEFAULT NULL COMMENT 'ID бренда',
  `цена` decimal(10,2) NOT NULL COMMENT 'Цена в рублях',
  `старая_цена` decimal(10,2) DEFAULT NULL COMMENT 'Старая цена',
  `количество_на_складе` int(11) NOT NULL DEFAULT 0 COMMENT 'Общее количество',
  `вес_кг` decimal(8,3) DEFAULT NULL COMMENT 'Вес в кг',
  `габариты` varchar(100) DEFAULT NULL COMMENT 'Габариты ДхШхВ',
  `материал` varchar(100) DEFAULT NULL COMMENT 'Материал изготовления',
  `гарантия_месяцев` int(11) DEFAULT 0 COMMENT 'Гарантия в месяцах',
  `номер_оригинала` varchar(100) DEFAULT NULL COMMENT 'Оригинальный номер',
  `страна_производства` varchar(100) DEFAULT NULL COMMENT 'Страна производства',
  `активно` tinyint(1) DEFAULT 1 COMMENT 'Товар активен',
  `популярный` tinyint(1) DEFAULT 0 COMMENT 'Популярный товар',
  `просмотры` int(11) DEFAULT 0 COMMENT 'Количество просмотров',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `image_url` varchar(500) DEFAULT NULL COMMENT 'URL изображения товара',
  `производитель` varchar(200) DEFAULT NULL COMMENT 'Производитель запчасти',
  `срок_доставки` varchar(50) DEFAULT NULL COMMENT 'Срок доставки',
  `рейтинг` decimal(3,2) DEFAULT 0.00 COMMENT 'Рейтинг товара',
  `отзывов` int(11) DEFAULT 0 COMMENT 'Количество отзывов',
  `в_наличии` tinyint(1) DEFAULT 1 COMMENT 'В наличии',
  `оригинал` tinyint(1) DEFAULT 0 COMMENT 'Оригинальная запчасть',
  `применяемость` text DEFAULT NULL COMMENT 'Применяемость к авто'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Автозапчасти';

--
-- Дамп данных таблицы `products`
--

INSERT INTO `products` (`id`, `артикул`, `название`, `slug`, `описание`, `краткое_описание`, `category_id`, `brand_id`, `цена`, `старая_цена`, `количество_на_складе`, `вес_кг`, `габариты`, `материал`, `гарантия_месяцев`, `номер_оригинала`, `страна_производства`, `активно`, `популярный`, `просмотры`, `created_at`, `updated_at`, `image_url`, `производитель`, `срок_доставки`, `рейтинг`, `отзывов`, `в_наличии`, `оригинал`, `применяемость`) VALUES
(1, '2101-1000100', 'Поршень двигателя ВАЗ 2101-2107 (d=76мм)', 'porshen-vaz-2101-76mm', 'Поршень двигателя для автомобилей ВАЗ классика. Диаметр 76 мм. Комплект: поршень, палец, стопорные кольца.', NULL, 8, 1, 1250.00, 1500.00, 45, 0.350, NULL, NULL, 12, '2101-1000100', 'Россия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(2, '2123-1000100', 'Поршень двигателя ВАЗ 2123 (d=82мм)', 'porshen-vaz-2123-82mm', 'Поршень двигателя для LADA Niva, Chevrolet Niva. Диаметр 82 мм.', NULL, 8, 1, 1500.00, 1800.00, 30, 0.420, NULL, NULL, 12, '2123-1000100', 'Россия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(3, '2108-1006030', 'Ремень ГРМ ВАЗ 2108-2115', 'remen-grm-vaz-2108', 'Ремень привода газораспределительного механизма для переднеприводных автомобилей ВАЗ. Ресурс 60000 км.', NULL, 9, 5, 850.00, NULL, 100, 0.150, NULL, NULL, 6, '2108-1006030', 'Германия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(4, '2123-1006030', 'Ремень ГРМ LADA Vesta/Granta', 'remen-grm-lada-vesta', 'Ремень ГРМ для автомобилей LADA Vesta, LADA Granta с двигателем 1.6 л. Оригинал.', NULL, 9, 1, 1200.00, 1400.00, 75, 0.180, NULL, NULL, 12, '2123-1006030', 'Россия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(5, '2101-1601130', 'Сцепление в сборе ВАЗ 2101-2107', 'sceplenie-vaz-2101', 'Сцепление в сборе (корзина + диск) для автомобилей ВАЗ классика.', NULL, 10, 1, 3200.00, NULL, 25, 4.500, NULL, NULL, 12, '2101-1601130', 'Россия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(6, '2123-1601130', 'Сцепление LADA Vesta', 'sceplenie-lada-vesta', 'Сцепление в сборе для LADA Vesta с двигателем 1.6 л.', NULL, 10, 1, 4500.00, 5200.00, 20, 5.200, NULL, NULL, 12, '2123-1601130', 'Россия', 1, 0, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(7, '2101-2905004', 'Амортизатор передний ВАЗ 2101-2107', 'amortizator-peredniy-vaz-2101', 'Масляный амортизатор передней подвески для ВАЗ классика.', NULL, 11, 6, 950.00, NULL, 50, 2.800, NULL, NULL, 12, '2101-2905004', 'Россия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(8, '2123-2905004', 'Амортизатор передний LADA Vesta', 'amortizator-peredniy-vesta', 'Газо-масляный амортизатор передней подвески для LADA Vesta.', NULL, 11, 6, 1800.00, NULL, 40, 3.200, NULL, NULL, 24, '2123-2905004', 'Россия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(9, '2108-3701010', 'Стартер ВАЗ 2108-2115', 'starter-vaz-2108', 'Стартер для переднеприводных автомобилей ВАЗ. Мощность 1.4 кВт.', NULL, 5, 4, 2800.00, NULL, 15, 3.500, NULL, NULL, 12, '2108-3701010', 'Германия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(10, '2123-3701010', 'Стартер LADA Granta/Vesta', 'starter-lada-granta', 'Стартер для LADA Granta, Vesta с двигателем 1.6 л. BOSCH.', NULL, 5, 4, 3500.00, 4200.00, 20, 3.800, NULL, NULL, 12, '2123-3701010', 'Германия', 1, 0, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(11, 'GAZ-3110-2905004', 'Амортизатор передний ГАЗ-3110 Волга', 'amortizator-gaz-3110', 'Масляный амортизатор для ГАЗ-3110 Волга.', NULL, 11, 2, 1500.00, NULL, 10, 3.500, NULL, NULL, 12, '3110-2905004', 'Россия', 1, 0, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(12, 'UAZ-3163-2905004', 'Амортизатор передний УАЗ Патриот', 'amortizator-uaz-patriot', 'Усиленный амортизатор для УАЗ Патриот.', NULL, 11, 3, 2200.00, 2500.00, 8, 4.000, NULL, NULL, 12, '3163-2905004', 'Россия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(13, '2101-1101000', 'Фильтр масляный ВАЗ классика', 'maslyany-filtr-vaz', 'Масляный фильтр для двигателей ВАЗ классика.', NULL, 6, 6, 250.00, NULL, 200, 0.300, NULL, NULL, NULL, '2101-1101000', 'Россия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(14, '2123-1101000', 'Фильтр масляный LADA Vesta/Granta', 'maslyany-filtr-vesta', 'Масляный фильтр для LADA Vesta, Granta.', NULL, 6, 4, 450.00, 550.00, 150, 0.350, NULL, NULL, NULL, '2123-1101000', 'Германия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(15, 'LUK-5W40-4L', 'Масло моторное ЛУКОЙЛ Genesis 5W-40 (4л)', 'maslo-lukoil-5w40', 'Синтетическое моторное масло ЛУКОЙЛ Genesis Armortech 5W-40. Объем 4 литра.', NULL, 7, 7, 1800.00, 2200.00, 80, 4.000, NULL, NULL, NULL, NULL, 'Россия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(16, '2101-1111000', 'Фильтр воздушный ВАЗ 2101-2107', 'vozdushny-filtr-vaz', 'Воздушный фильтр для карбюраторных двигателей ВАЗ.', NULL, 6, 6, 350.00, NULL, 120, 0.400, NULL, NULL, NULL, '2101-1111000', 'Россия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(17, '2108-1111000', 'Фильтр воздушный ВАЗ 2108-2115', 'vozdushny-filtr-vaz-2108', 'Воздушный фильтр для инжекторных двигателей переднеприводных ВАЗ.', NULL, 6, 4, 500.00, NULL, 100, 0.450, NULL, NULL, NULL, '2108-1111000', 'Германия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(18, '2101-3505090', 'Тормозные колодки передние ВАЗ 2101-2107', 'tormoznye-kolodki-vaz', 'Комплект передних тормозных колодок для ВАЗ классика. 4 шт.', NULL, 3, 6, 650.00, 800.00, 60, 1.200, NULL, NULL, 12, '2101-3505090', 'Россия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(19, '2123-3505090', 'Тормозные колодки передние LADA Vesta', 'tormoznye-kolodki-vesta', 'Передние тормозные колодки для LADA Vesta. BOSCH.', NULL, 3, 4, 1200.00, 1500.00, 45, 1.500, NULL, NULL, 12, '2123-3505090', 'Германия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(20, 'UAZ-3160-3505090', 'Тормозные колодки передние УАЗ Патриот', 'tormoznye-kolodki-uaz', 'Передние тормозные колодки для УАЗ Патриот.', NULL, 3, 3, 1400.00, NULL, 25, 1.800, NULL, NULL, 12, '3160-3505090', 'Россия', 1, 1, 0, '2026-05-07 03:39:31', '2026-05-07 03:39:31', NULL, NULL, NULL, 0.00, 0, 1, 0, NULL),
(21, 'LR-001234', 'Тормозные колодки передние LAND ROVER Range Rover Sport 2010-', 'tormoznye-kolodki-land-rover-sport', 'Высококачественные тормозные колодки для LAND ROVER Range Rover Sport. Обеспечивают отличное торможение и длительный срок службы.', NULL, 3, 4, 4850.00, 5200.00, 15, NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, '2026-05-07 05:00:35', '2026-05-07 05:00:35', 'https://via.placeholder.com/400x400/e2e8f0/4a5568?text=Brake+Pads', 'BOSCH', '1-2 дня', 4.80, 125, 1, 0, NULL),
(22, 'BMW-9876', 'Масляный фильтр BMW 3 Series F30 320d 2012-2018', 'maslyany-filtr-bmw-f30', 'Оригинальный масляный фильтр для BMW 3 Series. Гарантирует чистоту масла и защиту двигателя.', NULL, 6, 4, 1250.00, NULL, 50, NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, '2026-05-07 05:00:35', '2026-05-07 05:00:35', 'https://via.placeholder.com/400x400/e2e8f0/4a5568?text=Oil+Filter', 'MANN-FILTER', 'В наличии', 4.90, 230, 1, 1, NULL),
(23, 'TYT-555', 'Амортизатор передний TOYOTA Camry 2018-2023', 'amortizator-toyota-camry-70', 'Передний газомаслянный амортизатор для Toyota Camry. Обеспечивает комфорт и управляемость.', NULL, 4, 5, 3200.00, 3800.00, 8, NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, '2026-05-07 05:00:35', '2026-05-07 05:00:35', 'https://via.placeholder.com/400x400/e2e8f0/4a5568?text=Shock+Absorber', 'KYB', '2-3 дня', 4.50, 67, 1, 0, NULL),
(24, 'VAG-332', 'Свечи зажигания VAG Audi A6 C7 3.0 TFSI', 'svechi-zazhiganiya-audi-a6', 'Комплект свечей зажигания для Audi A6. Иридиевые, повышенный ресурс.', NULL, 5, 4, 2800.00, NULL, 35, NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, '2026-05-07 05:00:35', '2026-05-07 05:00:35', 'https://via.placeholder.com/400x400/e2e8f0/4a5568?text=Spark+Plugs', 'NGK', 'В наличии', 4.70, 189, 1, 1, NULL),
(25, 'MB-444', 'Радиатор охлаждения MERCEDES-BENZ E-Class W213', 'radiator-mercedes-e-class', 'Радиатор системы охлаждения для Mercedes-Benz E-Class. Высокое качество, точная геометрия.', NULL, 6, 5, 12800.00, 14500.00, 3, NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, '2026-05-07 05:00:35', '2026-05-07 05:00:35', 'https://via.placeholder.com/400x400/e2e8f0/4a5568?text=Radiator', 'NISSENS', '3-5 дней', 4.30, 45, 1, 0, NULL),
(26, 'LAD-001', 'Ремень ГРМ LADA Vesta 1.6 16V', 'remen-grm-lada-vesta-16v', 'Ремень ГРМ для LADA Vesta с двигателем 1.6 16V. Оригинальное качество.', NULL, 9, 1, 1200.00, 1500.00, 100, NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, '2026-05-07 05:00:35', '2026-05-07 05:00:35', 'https://via.placeholder.com/400x400/e2e8f0/4a5568?text=Timing+Belt', 'АвтоВАЗ', 'В наличии', 4.60, 312, 1, 1, NULL),
(27, 'UAZ-777', 'ШРУС наружный УАЗ Патриот 3163', 'shrus-uaz-patriot', 'ШРУС наружный для УАЗ Патриот. Усиленная конструкция для бездорожья.', NULL, 2, 3, 2800.00, NULL, 12, NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, '2026-05-07 05:00:35', '2026-05-07 05:00:35', 'https://via.placeholder.com/400x400/e2e8f0/4a5568?text=CV+Joint', 'УАЗ', '1-2 дня', 4.40, 78, 1, 1, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `product_attributes`
--

CREATE TABLE `product_attributes` (
  `id` int(11) NOT NULL COMMENT 'ID характеристики',
  `product_id` int(11) NOT NULL COMMENT 'ID товара',
  `название_характеристики` varchar(100) NOT NULL COMMENT 'Название',
  `значение_характеристики` varchar(255) NOT NULL COMMENT 'Значение'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Характеристики товаров';

--
-- Дамп данных таблицы `product_attributes`
--

INSERT INTO `product_attributes` (`id`, `product_id`, `название_характеристики`, `значение_характеристики`) VALUES
(1, 1, 'Диаметр поршня', '76 мм'),
(2, 1, 'Компрессионная высота', '38 мм'),
(3, 1, 'Материал', 'Алюминиевый сплав'),
(4, 3, 'Количество зубьев', '111'),
(5, 3, 'Ширина ремня', '19 мм'),
(6, 3, 'Ресурс', '60000 км'),
(7, 5, 'Диаметр диска', '190 мм'),
(8, 5, 'Тип', 'Сухое однодисковое'),
(9, 5, 'Усилие на педали', 'Легкое'),
(10, 7, 'Тип амортизатора', 'Масляный двусторонний'),
(11, 7, 'Длина в сжатом состоянии', '340 мм'),
(12, 7, 'Длина в распущенном состоянии', '520 мм'),
(13, 9, 'Мощность', '1.4 кВт'),
(14, 9, 'Напряжение', '12 В'),
(15, 9, 'Количество зубьев шестерни', '9'),
(16, 15, 'Вязкость SAE', '5W-40'),
(17, 15, 'Тип масла', 'Синтетическое'),
(18, 15, 'Объем', '4 литра'),
(19, 18, 'Тип колодок', 'Безасбестовые'),
(20, 18, 'Количество в комплекте', '4 шт'),
(21, 18, 'Наличие индикатора износа', 'Да');

-- --------------------------------------------------------

--
-- Структура таблицы `product_compatibility`
--

CREATE TABLE `product_compatibility` (
  `id` int(11) NOT NULL COMMENT 'ID записи совместимости',
  `product_id` int(11) NOT NULL COMMENT 'ID запчасти',
  `car_model_id` int(11) NOT NULL COMMENT 'ID модели авто',
  `год_выпуска_с` int(11) DEFAULT NULL COMMENT 'Подходит с года',
  `год_выпуска_по` int(11) DEFAULT NULL COMMENT 'Подходит по год',
  `объем_двигателя` varchar(50) DEFAULT NULL COMMENT 'Объем двигателя',
  `тип_двигателя` varchar(50) DEFAULT NULL COMMENT 'Тип двигателя',
  `модификация` varchar(255) DEFAULT NULL COMMENT 'Модификация авто',
  `примечания` text DEFAULT NULL COMMENT 'Примечания'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Совместимость запчастей с авто';

--
-- Дамп данных таблицы `product_compatibility`
--

INSERT INTO `product_compatibility` (`id`, `product_id`, `car_model_id`, `год_выпуска_с`, `год_выпуска_по`, `объем_двигателя`, `тип_двигателя`, `модификация`, `примечания`) VALUES
(1, 1, 1, 1982, 2012, '1.5-1.6', 'Карбюратор/Инжектор', 'Все модификации ВАЗ 2107', NULL),
(2, 2, 5, 2020, NULL, '1.7', 'Инжектор', 'LADA Niva Travel', NULL),
(3, 2, 4, 2000, NULL, '1.7', 'Инжектор', 'LADA Niva Legend', NULL),
(4, 3, 1, 1982, 2012, '1.5-1.6', 'Инжектор', 'ВАЗ 2107 инжектор', NULL),
(5, 4, 3, 2015, NULL, '1.6', 'Инжектор', 'LADA Vesta', NULL),
(6, 4, 2, 2011, NULL, '1.6', 'Инжектор', 'LADA Granta', NULL),
(7, 5, 1, 1982, 2012, '1.5-1.6', 'Все', 'ВАЗ 2101-2107', NULL),
(8, 6, 3, 2015, NULL, '1.6', 'Механика', 'LADA Vesta МКПП', NULL),
(9, 7, 1, 1982, 2012, '1.5-1.6', 'Все', 'ВАЗ классика', NULL),
(10, 8, 3, 2015, NULL, '1.6', 'Все', 'LADA Vesta', NULL),
(11, 9, 1, 1982, 2012, '1.5-1.6', 'Все', 'ВАЗ 2108-2115', NULL),
(12, 10, 2, 2011, NULL, '1.6', 'Все', 'LADA Granta', NULL),
(13, 11, 7, 1997, 2005, '2.4', 'Инжектор', 'ГАЗ-3110', NULL),
(14, 12, 8, 2005, NULL, '2.7', 'Инжектор', 'УАЗ Патриот', NULL),
(15, 13, 1, 1982, 2012, '1.5-1.6', 'Все', 'ВАЗ классика', NULL),
(16, 14, 3, 2015, NULL, '1.6', 'Все', 'LADA Vesta', NULL),
(17, 14, 2, 2011, NULL, '1.6', 'Все', 'LADA Granta', NULL),
(18, 15, 1, 1982, 2012, '1.5-1.6', 'Все', 'Все модели', NULL),
(19, 15, 2, 2011, NULL, '1.6', 'Все', 'LADA Granta', NULL),
(20, 15, 3, 2015, NULL, '1.6', 'Все', 'LADA Vesta', NULL),
(21, 16, 1, 1982, 2012, '1.5-1.6', 'Все', 'ВАЗ классика', NULL),
(22, 17, 1, 1982, 2012, '1.5-1.6', 'Все', 'ВАЗ 2108-2115', NULL),
(23, 18, 1, 1982, 2012, '1.5-1.6', 'Все', 'ВАЗ классика', NULL),
(24, 19, 3, 2015, NULL, '1.6', 'Все', 'LADA Vesta', NULL),
(25, 20, 8, 2005, NULL, '2.7', 'Все', 'УАЗ Патриот', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `product_discounts`
--

CREATE TABLE `product_discounts` (
  `id` int(11) NOT NULL COMMENT 'ID скидки',
  `product_id` int(11) NOT NULL COMMENT 'ID товара',
  `тип_скидки` enum('процент','фиксированная_сумма') DEFAULT 'процент' COMMENT 'Тип скидки',
  `значение_скидки` decimal(10,2) NOT NULL COMMENT 'Значение скидки',
  `дата_начала` timestamp NULL DEFAULT NULL COMMENT 'Дата начала',
  `дата_окончания` timestamp NULL DEFAULT NULL COMMENT 'Дата окончания',
  `активно` tinyint(1) DEFAULT 1 COMMENT 'Активна',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Скидки на товары';

--
-- Дамп данных таблицы `product_discounts`
--

INSERT INTO `product_discounts` (`id`, `product_id`, `тип_скидки`, `значение_скидки`, `дата_начала`, `дата_окончания`, `активно`, `created_at`) VALUES
(1, 2, 'процент', 15.00, '2024-12-31 17:00:00', '2025-03-30 17:00:00', 1, '2026-05-07 03:39:31'),
(2, 10, 'процент', 20.00, '2024-12-31 17:00:00', '2025-02-27 17:00:00', 1, '2026-05-07 03:39:31'),
(3, 12, 'фиксированная_сумма', 300.00, '2024-12-31 17:00:00', '2025-01-30 17:00:00', 1, '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `product_images`
--

CREATE TABLE `product_images` (
  `id` int(11) NOT NULL COMMENT 'ID изображения',
  `product_id` int(11) NOT NULL COMMENT 'ID товара',
  `путь_к_изображению` varchar(255) NOT NULL COMMENT 'Путь к файлу',
  `alt_текст` varchar(255) DEFAULT NULL COMMENT 'ALT текст',
  `порядок_сортировки` int(11) DEFAULT 0 COMMENT 'Порядок отображения',
  `главное_изображение` tinyint(1) DEFAULT 0 COMMENT 'Главное изображение',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Изображения товаров';

--
-- Дамп данных таблицы `product_images`
--

INSERT INTO `product_images` (`id`, `product_id`, `путь_к_изображению`, `alt_текст`, `порядок_сортировки`, `главное_изображение`, `created_at`) VALUES
(1, 1, '/images/products/porshen-vaz-2101.jpg', 'Поршень ВАЗ 2101-2107', 1, 1, '2026-05-07 03:39:31'),
(2, 1, '/images/products/porshen-vaz-2101-2.jpg', 'Поршень ВАЗ 2101 вид снизу', 2, 0, '2026-05-07 03:39:31'),
(3, 4, '/images/products/remen-grm-vesta.jpg', 'Ремень ГРМ LADA Vesta', 1, 1, '2026-05-07 03:39:31'),
(4, 5, '/images/products/sceplenie-vaz-2101.jpg', 'Сцепление ВАЗ 2101', 1, 1, '2026-05-07 03:39:31'),
(5, 13, '/images/products/filtr-maslo-vaz.jpg', 'Масляный фильтр ВАЗ', 1, 1, '2026-05-07 03:39:31'),
(6, 15, '/images/products/maslo-lukoil-5w40.jpg', 'Масло ЛУКОЙЛ 5W-40', 1, 1, '2026-05-07 03:39:31'),
(7, 18, '/images/products/kolodki-vaz.jpg', 'Тормозные колодки ВАЗ', 1, 1, '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `product_reviews`
--

CREATE TABLE `product_reviews` (
  `id` int(11) NOT NULL COMMENT 'ID отзыва',
  `product_id` int(11) NOT NULL COMMENT 'ID товара',
  `user_id` int(11) NOT NULL COMMENT 'ID пользователя',
  `оценка` tinyint(4) NOT NULL COMMENT 'Оценка 1-5',
  `текст_отзыва` text DEFAULT NULL COMMENT 'Текст отзыва',
  `достоинства` text DEFAULT NULL COMMENT 'Достоинства',
  `недостатки` text DEFAULT NULL COMMENT 'Недостатки',
  `отзыв_одобрен` tinyint(1) DEFAULT 0 COMMENT 'Прошел модерацию',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ;

--
-- Дамп данных таблицы `product_reviews`
--

INSERT INTO `product_reviews` (`id`, `product_id`, `user_id`, `оценка`, `текст_отзыва`, `достоинства`, `недостатки`, `отзыв_одобрен`, `created_at`) VALUES
(1, 1, 3, 5, 'Отличные поршни! Поставил на свою семерку, работает как часы.', 'Качество, цена, быстрая доставка', 'Нет', 1, '2026-05-07 03:39:31'),
(2, 1, 4, 4, 'Хорошие поршни, но комплектация могла бы быть полнее.', 'Надежность', 'Хотелось бы кольца в комплекте', 1, '2026-05-07 03:39:31'),
(3, 3, 3, 5, 'Ремень качественный, прошел уже 30000 км - полет нормальный.', 'Долговечность', 'Нет', 1, '2026-05-07 03:39:31'),
(4, 7, 4, 4, 'Амортизаторы хорошие, но жестковаты для наших дорог.', 'Цена, качество', 'Жестковаты', 1, '2026-05-07 03:39:31'),
(5, 13, 3, 5, 'Фильтры отличные, всегда беру только их.', 'Цена/качество', 'Нет', 1, '2026-05-07 03:39:31'),
(6, 18, 3, 5, 'Колодки тормозят отлично, не скрипят.', 'Эффективность торможения', 'Нет', 1, '2026-05-07 03:39:31'),
(7, 18, 4, 3, 'Колодки неплохие, но быстро изнашиваются.', 'Цена', 'Быстрый износ', 0, '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `product_specifications`
--

CREATE TABLE `product_specifications` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `spec_name` varchar(200) NOT NULL COMMENT 'Название характеристики',
  `spec_value` varchar(500) NOT NULL COMMENT 'Значение характеристики'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Характеристики товаров';

-- --------------------------------------------------------

--
-- Структура таблицы `product_suppliers`
--

CREATE TABLE `product_suppliers` (
  `id` int(11) NOT NULL COMMENT 'ID связи',
  `product_id` int(11) NOT NULL COMMENT 'ID товара',
  `supplier_id` int(11) NOT NULL COMMENT 'ID поставщика',
  `закупочная_цена` decimal(10,2) NOT NULL COMMENT 'Закупочная цена',
  `артикул_поставщика` varchar(50) DEFAULT NULL COMMENT 'Артикул поставщика',
  `основной_поставщик` tinyint(1) DEFAULT 0 COMMENT 'Основной поставщик',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Связь товаров с поставщиками';

--
-- Дамп данных таблицы `product_suppliers`
--

INSERT INTO `product_suppliers` (`id`, `product_id`, `supplier_id`, `закупочная_цена`, `артикул_поставщика`, `основной_поставщик`, `created_at`) VALUES
(1, 1, 1, 900.00, '2101-1000100', 1, '2026-05-07 03:39:31'),
(2, 1, 4, 950.00, 'VAZ-2101-1000100', 0, '2026-05-07 03:39:31'),
(3, 3, 4, 600.00, '2108-1006030-BOSCH', 1, '2026-05-07 03:39:31'),
(4, 4, 1, 900.00, '2123-1006030', 1, '2026-05-07 03:39:31'),
(5, 5, 1, 2500.00, '2101-1601130', 1, '2026-05-07 03:39:31'),
(6, 7, 4, 700.00, '2101-2905004-LYNX', 1, '2026-05-07 03:39:31'),
(7, 9, 4, 2100.00, '2108-3701010-BOSCH', 1, '2026-05-07 03:39:31'),
(8, 13, 4, 180.00, '2101-1101000', 1, '2026-05-07 03:39:31'),
(9, 15, 3, 1400.00, 'LUK-5W40-4L', 1, '2026-05-07 03:39:31'),
(10, 18, 4, 480.00, '2101-3505090', 1, '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `promotions`
--

CREATE TABLE `promotions` (
  `id` int(11) NOT NULL,
  `название` varchar(300) NOT NULL,
  `описание` text DEFAULT NULL,
  `тип_скидки` varchar(20) DEFAULT 'процент',
  `значение_скидки` decimal(10,2) NOT NULL DEFAULT 0.00,
  `дата_начала` date NOT NULL,
  `дата_окончания` date NOT NULL,
  `service_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `активно` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `promotions`
--

INSERT INTO `promotions` (`id`, `название`, `описание`, `тип_скидки`, `значение_скидки`, `дата_начала`, `дата_окончания`, `service_id`, `product_id`, `активно`, `created_at`) VALUES
(1, 'Скидка на штукатурку 20%', 'Сезонная акция на все штукатурные работы', 'процент', 20.00, '2026-01-01', '2026-12-31', 6, NULL, 1, '2026-05-14 04:02:31'),
(2, 'Новый год - новый ремонт!', 'Скидка 15% на дизайн-проект', 'процент', 15.00, '2026-01-01', '2026-06-30', 41, NULL, 1, '2026-05-14 04:02:31'),
(3, 'Бесплатная затирка швов', 'При заказе укладки плитки - затирка бесплатно', 'процент', 100.00, '2026-01-01', '2026-12-31', 23, NULL, 1, '2026-05-14 04:02:31');

-- --------------------------------------------------------

--
-- Структура таблицы `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `service_id` int(11) DEFAULT NULL,
  `оценка` tinyint(4) NOT NULL DEFAULT 5,
  `текст` text DEFAULT NULL,
  `статус` varchar(20) DEFAULT 'опубликован',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `reviews`
--

INSERT INTO `reviews` (`id`, `client_id`, `order_id`, `service_id`, `оценка`, `текст`, `статус`, `created_at`) VALUES
(1, 1, 1, 6, 5, 'Отличная работа! Стены идеально ровные, бригада работала чисто и аккуратно. Рекомендую!', 'опубликован', '2026-05-14 04:02:31'),
(2, 1, 1, 17, 5, 'Ламинат уложили за день, очень доволен результатом. Быстро и качественно.', 'опубликован', '2026-05-14 04:02:31'),
(3, 2, NULL, 21, 4, 'Плитку положили хорошо, но немного задержались по срокам. А так всё отлично.', 'опубликован', '2026-05-14 04:02:31'),
(4, 3, NULL, 8, 5, 'Покраска стен выполнена на высшем уровне! Цвет подобрали идеально.', 'опубликован', '2026-05-14 04:02:31'),
(5, 4, 4, 11, 5, 'Сделали полный ремонт под ключ. Всё в срок, без нареканий.', 'опубликован', '2026-05-14 04:02:31');

-- --------------------------------------------------------

--
-- Структура таблицы `services`
--

CREATE TABLE `services` (
  `id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `название` varchar(300) NOT NULL,
  `slug` varchar(300) DEFAULT NULL,
  `описание` text DEFAULT NULL,
  `краткое_описание` varchar(500) DEFAULT NULL,
  `единица_измерения` varchar(20) DEFAULT 'м²',
  `базовая_цена` decimal(10,2) NOT NULL,
  `мин_цена` decimal(10,2) DEFAULT NULL,
  `срок_выполнения` varchar(100) DEFAULT NULL,
  `популярность` int(11) DEFAULT 0,
  `активно` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `services`
--

INSERT INTO `services` (`id`, `category_id`, `название`, `slug`, `описание`, `краткое_описание`, `единица_измерения`, `базовая_цена`, `мин_цена`, `срок_выполнения`, `популярность`, `активно`, `created_at`) VALUES
(1, 1, 'Демонтаж гипсокартонных конструкций', 'demontazh-gkl', 'Разборка перегородок и потолков из ГКЛ', 'Аккуратный демонтаж ГКЛ', 'м²', 300.00, 3000.00, '1 день', 65, 1, '2026-05-14 04:24:15'),
(2, 1, 'Демонтаж электропроводки', 'demontazh-provodki', 'Демонтаж старой проводки, розеток, выключателей', 'Безопасный демонтаж электрики', 'услуга', 5000.00, 5000.00, '1-2 дня', 60, 1, '2026-05-14 04:24:15'),
(3, 2, 'Штукатурка фасада', 'shtukaturka-fasada', 'Фасадная штукатурка с армированием', 'Защита фасада от влаги', 'м²', 750.00, 15000.00, '5-10 дней', 60, 1, '2026-05-14 04:24:15'),
(4, 2, 'Ремонт штукатурки', 'remont-shtukaturki', 'Локальный ремонт поврежденной штукатурки', 'Быстрый ремонт сколов и трещин', 'м²', 400.00, 2000.00, '1 день', 70, 1, '2026-05-14 04:24:15'),
(5, 3, 'Покраска потолка', 'pokraska-potolka-2', 'Покраска потолка в 2 слоя', 'Идеально белый потолок', 'м²', 350.00, 3000.00, '1-2 дня', 82, 1, '2026-05-14 04:24:15'),
(6, 3, 'Поклейка стеклохолста', 'pokleyka-stekloholsta', 'Поклейка стеклохолста под покраску', 'Защита стен от трещин', 'м²', 450.00, 5000.00, '2-3 дня', 65, 1, '2026-05-14 04:24:15'),
(7, 3, 'Декоративная покраска стен', 'dekor-pokraska', 'Покраска с эффектами (венецианка, шелк)', 'Эксклюзивный дизайн стен', 'м²', 1200.00, 15000.00, '3-7 дней', 55, 1, '2026-05-14 04:24:15'),
(8, 4, 'Укладка кварцвинила', 'ukladka-kvartsvinila', 'Укладка кварцвиниловой плитки', 'Износостойкое покрытие', 'м²', 650.00, 5000.00, '1-3 дня', 70, 1, '2026-05-14 04:24:15'),
(9, 4, 'Укладка ковролина', 'ukladka-kovrolina', 'Настил ковролина с приклеиванием', 'Мягкий и теплый пол', 'м²', 300.00, 3000.00, '1 день', 60, 1, '2026-05-14 04:24:15'),
(10, 4, 'Теплый пол электрический', 'teply-pol-elektro', 'Монтаж электрического теплого пола', 'Тепло в любой комнате', 'м²', 1800.00, 15000.00, '2-5 дней', 75, 1, '2026-05-14 04:24:15'),
(11, 5, 'Укладка керамогранита на фасад', 'keramogranit-fasad', 'Облицовка фасада керамогранитом', 'Долговечный фасад', 'м²', 2200.00, 30000.00, '5-15 дней', 50, 1, '2026-05-14 04:24:15'),
(12, 5, 'Гидроизоляция ванной', 'gidroizolyatsiya', 'Гидроизоляция пола и стен в санузле', 'Защита от протечек', 'м²', 600.00, 5000.00, '1-2 дня', 80, 1, '2026-05-14 04:24:15'),
(13, 6, 'Установка теплого пола', 'ustanovka-teplogo-pola', 'Монтаж системы теплый пол', 'Комфортное отопление', 'м²', 1200.00, 10000.00, '2-4 дня', 72, 1, '2026-05-14 04:24:15'),
(14, 6, 'Монтаж видеонаблюдения', 'montazh-videonablyudeniya', 'Установка камер видеонаблюдения', 'Безопасность вашего дома', 'точка', 3500.00, 10000.00, '1-3 дня', 60, 1, '2026-05-14 04:24:15'),
(15, 6, 'Установка домофона', 'ustanovka-domofona', 'Монтаж видеодомофона', 'Знайте кто пришел', 'шт', 5000.00, 5000.00, '1 день', 65, 1, '2026-05-14 04:24:15'),
(16, 7, 'Монтаж душевой кабины', 'montazh-dushevoy', 'Сборка и установка душевой кабины', 'Современный душ', 'шт', 6500.00, 6500.00, '1-2 дня', 70, 1, '2026-05-14 04:24:15'),
(17, 7, 'Установка бойлера', 'ustanovka-boylera', 'Монтаж накопительного водонагревателя', 'Горячая вода всегда', 'шт', 4000.00, 4000.00, '1 день', 68, 1, '2026-05-14 04:24:15'),
(18, 7, 'Замена стояков', 'zamena-stoyakov', 'Замена стояков ХВС/ГВС/канализации', 'Новые трубы без протечек', 'стояк', 8000.00, 8000.00, '1-2 дня', 55, 1, '2026-05-14 04:24:15'),
(19, 7, 'Монтаж системы фильтрации', 'montazh-filtratsii', 'Установка фильтров очистки воды', 'Чистая вода из крана', 'услуга', 5000.00, 5000.00, '1 день', 60, 1, '2026-05-14 04:24:15'),
(20, 8, 'Монтаж реечного потолка', 'reechny-potolok', 'Установка алюминиевого реечного потолка', 'Идеально для ванной', 'м²', 1100.00, 8000.00, '1-2 дня', 65, 1, '2026-05-14 04:24:15'),
(21, 8, 'Световые линии в потолке', 'svetovye-linii', 'Монтаж светодиодных линий в гипсокартон', 'Современное освещение', 'пог.м', 1500.00, 10000.00, '2-3 дня', 70, 1, '2026-05-14 04:24:15'),
(22, 9, 'Установка раздвижных дверей', 'razdvizhnye-dveri', 'Монтаж раздвижных межкомнатных дверей', 'Экономия пространства', 'шт', 5500.00, 5500.00, '1 день', 60, 1, '2026-05-14 04:24:15'),
(23, 9, 'Замена остекления балкона', 'osteklenie-balkona', 'Холодное или теплое остекление балкона', 'Уютный балкон', 'услуга', 35000.00, 35000.00, '2-5 дней', 65, 1, '2026-05-14 04:24:15'),
(24, 9, 'Установка рольставней', 'ustanovka-rolstavney', 'Монтаж защитных рольставней на окна', 'Защита от взлома и солнца', 'шт', 8000.00, 8000.00, '1 день', 45, 1, '2026-05-14 04:24:15'),
(25, 10, 'Технический аудит квартиры', 'teh-audit', 'Обследование квартиры перед покупкой', 'Знайте что покупаете', 'услуга', 7000.00, 7000.00, '1 день', 75, 1, '2026-05-14 04:24:15'),
(26, 10, 'Подбор материалов', 'podbor-materialov', 'Профессиональный подбор материалов по бюджету', 'Сэкономьте время и деньги', 'услуга', 3000.00, 3000.00, '1-3 дня', 68, 1, '2026-05-14 04:24:15'),
(27, 10, '3D-визуализация комнаты', '3d-vizualizatsiya', 'Фотореалистичная 3D визуализация интерьера', 'Увидьте результат до ремонта', 'услуга', 5000.00, 5000.00, '2-5 дней', 80, 1, '2026-05-14 04:24:15');

-- --------------------------------------------------------

--
-- Структура таблицы `service_categories`
--

CREATE TABLE `service_categories` (
  `id` int(11) NOT NULL,
  `название` varchar(200) NOT NULL,
  `slug` varchar(200) DEFAULT NULL,
  `описание` text DEFAULT NULL,
  `иконка` varchar(10) DEFAULT NULL,
  `сортировка` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `shop_products`
--

CREATE TABLE `shop_products` (
  `id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `название` varchar(300) NOT NULL,
  `артикул` varchar(100) DEFAULT NULL,
  `описание` text DEFAULT NULL,
  `цена_закуп` decimal(10,2) DEFAULT NULL,
  `цена_розница` decimal(10,2) NOT NULL,
  `единица_измерения` varchar(20) DEFAULT 'шт',
  `количество_на_складе` int(11) DEFAULT 0,
  `мин_запас` int(11) DEFAULT 10,
  `поставщик_id` int(11) DEFAULT NULL,
  `популярность` int(11) DEFAULT 0,
  `активно` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `shop_products`
--

INSERT INTO `shop_products` (`id`, `category_id`, `название`, `артикул`, `описание`, `цена_закуп`, `цена_розница`, `единица_измерения`, `количество_на_складе`, `мин_запас`, `поставщик_id`, `популярность`, `активно`, `created_at`) VALUES
(1, 2, 'Штукатурка гипсовая Волма Слой 30кг', 'VOL-030', 'Гипсовая штукатурка для машинного нанесения', 350.00, 480.00, 'мешок', 80, 10, 1, 85, 1, '2026-05-14 04:21:38'),
(2, 2, 'Шпатлевка базовая Knauf Fugen 25кг', 'KNF-FUG', 'Универсальная шпатлевка для стыков ГКЛ', 420.00, 580.00, 'мешок', 60, 10, 1, 78, 1, '2026-05-14 04:21:38'),
(3, 2, 'Грунтовка Knauf Tiefengrund 10л', 'KNF-TIE', 'Грунтовка для сильно впитывающих оснований', 750.00, 980.00, 'канистра', 40, 10, 1, 72, 1, '2026-05-14 04:21:38'),
(4, 3, 'Краска Tikkurila Euro Power 7 9л', 'TIK-EP7', 'Моющаяся краска для стен и потолков', 3200.00, 4500.00, 'ведро', 20, 10, 2, 80, 1, '2026-05-14 04:21:38'),
(5, 3, 'Обои флизелиновые Rasch 1.06x10м', 'RAS-FLIZ', 'Немецкие обои под покраску', 1500.00, 2200.00, 'рулон', 45, 10, 2, 75, 1, '2026-05-14 04:21:38'),
(6, 3, 'Клей для обоев Metylan 250г', 'MET-250', 'Специальный клей для флизелиновых обоев', 180.00, 280.00, 'шт', 120, 10, 2, 82, 1, '2026-05-14 04:21:38'),
(7, 3, 'Малярный скотч 50мм x 50м', 'SKO-5050', 'Профессиональный малярный скотч', 85.00, 150.00, 'шт', 200, 10, 2, 70, 1, '2026-05-14 04:21:38'),
(8, 4, 'Кварцвинил FineFloor 4мм', 'FIN-QV4', 'Кварцвиниловая плитка под дерево', 950.00, 1450.00, 'м²', 80, 10, 3, 72, 1, '2026-05-14 04:21:38'),
(9, 4, 'Ковролин Kalinka Нева 4м', 'KAL-NEV', 'Бытовой ковролин на джутовой основе', 450.00, 680.00, 'м²', 60, 10, 3, 65, 1, '2026-05-14 04:21:38'),
(10, 4, 'Наливной пол Knauf Tribon 25кг', 'KNF-TRI', 'Самовыравнивающая смесь для пола', 380.00, 550.00, 'мешок', 70, 10, 3, 78, 1, '2026-05-14 04:21:38'),
(11, 5, 'Керамогранит Italon 60x60 белый', 'ITA-6060', 'Итальянский керамогранит для пола', 950.00, 1500.00, 'м²', 100, 10, 4, 82, 1, '2026-05-14 04:21:38'),
(12, 5, 'Мозаика стеклянная 30x30', 'MOZ-3030', 'Стеклянная мозаика для ванной', 850.00, 1350.00, 'шт', 40, 10, 4, 68, 1, '2026-05-14 04:21:38'),
(13, 5, 'Гидроизоляция Ceresit CR65 25кг', 'CER-CR65', 'Цементная гидроизоляция', 650.00, 950.00, 'мешок', 30, 10, 4, 75, 1, '2026-05-14 04:21:38'),
(14, 6, 'Кабель ВВГнг-LS 3x1.5', 'VVG-315', 'Кабель для освещения', 38.00, 65.00, 'метр', 1500, 10, 3, 80, 1, '2026-05-14 04:21:38'),
(15, 6, 'Светильник светодиодный 36W', 'SVE-036', 'Встраиваемый светодиодный светильник', 350.00, 580.00, 'шт', 80, 10, 3, 78, 1, '2026-05-14 04:21:38'),
(16, 6, 'Дифференциальный автомат 25А', 'DIF-025', 'Диф автомат 25А 30мА', 850.00, 1350.00, 'шт', 40, 10, 3, 72, 1, '2026-05-14 04:21:38'),
(17, 6, 'Кабель-канал 25x16 белый', 'KAN-2516', 'Пластиковый кабель-канал', 45.00, 85.00, 'метр', 200, 10, 3, 65, 1, '2026-05-14 04:21:38'),
(18, 7, 'Раковина Santek Онега 60см', 'SAN-ONE', 'Керамическая раковина с тумбой', 2800.00, 4500.00, 'шт', 12, 10, 4, 75, 1, '2026-05-14 04:21:38'),
(19, 7, 'Душевая кабина Niagara 90x90', 'NIA-9090', 'Душевая кабина с гидромассажем', 18500.00, 28000.00, 'шт', 3, 10, 4, 60, 1, '2026-05-14 04:21:38'),
(20, 7, 'Полотенцесушитель Terminus 60x80', 'TER-6080', 'Водяной полотенцесушитель из нержавейки', 3200.00, 5200.00, 'шт', 8, 10, 4, 70, 1, '2026-05-14 04:21:38'),
(21, 7, 'Инсталляция Grohe Rapid SL', 'GRO-RAP', 'Инсталляция для подвесного унитаза', 4500.00, 7200.00, 'шт', 6, 10, 4, 68, 1, '2026-05-14 04:21:38'),
(22, 9, 'Дверь раздвижная на rollers', 'DVE-ROL', 'Раздвижная дверь на роликах', 4200.00, 6500.00, 'шт', 8, 10, 5, 62, 1, '2026-05-14 04:21:38'),
(23, 9, 'Фурнитура дверная магнитная', 'FUR-MAG', 'Магнитный замок с ручками', 850.00, 1400.00, 'комплект', 30, 10, 5, 72, 1, '2026-05-14 04:21:38');

-- --------------------------------------------------------

--
-- Структура таблицы `suppliers`
--

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL COMMENT 'ID поставщика',
  `название_компании` varchar(200) NOT NULL COMMENT 'Название компании',
  `контактное_лицо` varchar(100) DEFAULT NULL COMMENT 'Контактное лицо',
  `телефон` varchar(20) DEFAULT NULL COMMENT 'Телефон',
  `email` varchar(100) DEFAULT NULL COMMENT 'Email',
  `адрес` text DEFAULT NULL COMMENT 'Адрес',
  `срок_доставки_дней` int(11) DEFAULT NULL COMMENT 'Срок доставки в днях',
  `активно` tinyint(1) DEFAULT 1 COMMENT 'Активный поставщик',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Поставщики автозапчастей';

--
-- Дамп данных таблицы `suppliers`
--

INSERT INTO `suppliers` (`id`, `название_компании`, `контактное_лицо`, `телефон`, `email`, `адрес`, `срок_доставки_дней`, `активно`, `created_at`) VALUES
(1, 'АвтоВАЗ-Снаб', 'Петров Сергей Иванович', '+7(8482)55-66-77', 'petrov@avtovaz.ru', NULL, 3, 1, '2026-05-07 03:39:31'),
(2, 'ГАЗ-Запчасть', 'Иванов Алексей Петрович', '+7(831)422-33-44', 'ivanov@gaz.ru', NULL, 5, 1, '2026-05-07 03:39:31'),
(3, 'АвтоДеталь', 'Сидоров Михаил Андреевич', '+7(495)755-44-33', 'sidorov@autodetal.ru', NULL, 2, 1, '2026-05-07 03:39:31'),
(4, 'ЗапчастьТорг', 'Кузнецов Дмитрий Сергеевич', '+7(812)633-22-11', 'kuznetsov@zapchast.ru', NULL, 4, 1, '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL COMMENT 'ID пользователя',
  `email` varchar(100) NOT NULL COMMENT 'Email',
  `пароль` varchar(255) NOT NULL COMMENT 'Пароль',
  `имя` varchar(50) DEFAULT NULL COMMENT 'Имя',
  `фамилия` varchar(50) DEFAULT NULL COMMENT 'Фамилия',
  `телефон` varchar(20) DEFAULT NULL COMMENT 'Телефон',
  `роль` enum('пользователь','администратор','менеджер') DEFAULT 'пользователь' COMMENT 'Роль',
  `активно` tinyint(1) DEFAULT 1 COMMENT 'Активен',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Пользователи магазина';

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `email`, `пароль`, `имя`, `фамилия`, `телефон`, `роль`, `активно`, `created_at`, `updated_at`) VALUES
(1, 'admin@autoshop.ru', '$2y$10$HASHED_PASSWORD_ADMIN', 'Админ', 'Админов', '+7(900)111-22-33', 'администратор', 1, '2026-05-07 03:39:31', '2026-05-07 03:39:31'),
(2, 'manager@autoshop.ru', '$2y$10$HASHED_PASSWORD_MANAGER', 'Менеджер', 'Менеджеров', '+7(900)222-33-44', 'менеджер', 1, '2026-05-07 03:39:31', '2026-05-07 03:39:31'),
(3, 'ivan@mail.ru', '$2y$10$HASHED_PASSWORD_USER', 'Иван', 'Иванов', '+7(900)333-44-55', 'пользователь', 1, '2026-05-07 03:39:31', '2026-05-07 03:39:31'),
(4, 'petr@mail.ru', '$2y$10$HASHED_PASSWORD_USER2', 'Петр', 'Петров', '+7(900)444-55-66', 'пользователь', 1, '2026-05-07 03:39:31', '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `user_addresses`
--

CREATE TABLE `user_addresses` (
  `id` int(11) NOT NULL COMMENT 'ID адреса',
  `user_id` int(11) NOT NULL COMMENT 'ID пользователя',
  `адрес` text NOT NULL COMMENT 'Полный адрес',
  `город` varchar(100) NOT NULL COMMENT 'Город',
  `область` varchar(100) DEFAULT NULL COMMENT 'Область',
  `почтовый_индекс` varchar(20) DEFAULT NULL COMMENT 'Индекс',
  `страна` varchar(100) DEFAULT 'Россия' COMMENT 'Страна',
  `адрес_по_умолчанию` tinyint(1) DEFAULT 0 COMMENT 'По умолчанию',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Адреса пользователей';

--
-- Дамп данных таблицы `user_addresses`
--

INSERT INTO `user_addresses` (`id`, `user_id`, `адрес`, `город`, `область`, `почтовый_индекс`, `страна`, `адрес_по_умолчанию`, `created_at`) VALUES
(1, 3, 'ул. Ленина, д. 15, кв. 42', 'Москва', 'Московская область', '101000', 'Россия', 1, '2026-05-07 03:39:31'),
(2, 3, 'ул. Садовая, д. 8, офис 12', 'Москва', 'Московская область', '101001', 'Россия', 0, '2026-05-07 03:39:31'),
(3, 4, 'пр. Победы, д. 120, кв. 5', 'Санкт-Петербург', 'Ленинградская область', '190000', 'Россия', 1, '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `госномер` varchar(20) NOT NULL,
  `марка` varchar(100) DEFAULT NULL,
  `модель` varchar(100) DEFAULT NULL,
  `тип` varchar(50) DEFAULT 'фургон',
  `водитель` int(11) DEFAULT NULL,
  `статус` varchar(20) DEFAULT 'свободен'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `view_history`
--

CREATE TABLE `view_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT 1,
  `тип` varchar(20) DEFAULT 'услуга',
  `item_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `warehouses`
--

CREATE TABLE `warehouses` (
  `id` int(11) NOT NULL COMMENT 'ID склада',
  `название` varchar(100) NOT NULL COMMENT 'Название склада',
  `адрес` text NOT NULL COMMENT 'Адрес склада',
  `телефон` varchar(20) DEFAULT NULL COMMENT 'Телефон',
  `ответственный` varchar(100) DEFAULT NULL COMMENT 'Ответственное лицо',
  `активно` tinyint(1) DEFAULT 1 COMMENT 'Активный склад',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Склады автозапчастей';

--
-- Дамп данных таблицы `warehouses`
--

INSERT INTO `warehouses` (`id`, `название`, `адрес`, `телефон`, `ответственный`, `активно`, `created_at`) VALUES
(1, 'Основной склад', 'г. Москва, ул. Складская, 10', '+7(495)111-22-33', 'Смирнов И.И.', 1, '2026-05-07 03:39:31'),
(2, 'Склад №2', 'г. Санкт-Петербург, пр. Индустриальный, 25', '+7(812)444-55-66', 'Васильев А.Н.', 1, '2026-05-07 03:39:31'),
(3, 'Региональный склад', 'г. Екатеринбург, ул. Товарная, 5', '+7(343)777-88-99', 'Попов С.В.', 1, '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `warehouse_stocks`
--

CREATE TABLE `warehouse_stocks` (
  `id` int(11) NOT NULL COMMENT 'ID записи остатка',
  `product_id` int(11) NOT NULL COMMENT 'ID товара',
  `warehouse_id` int(11) NOT NULL COMMENT 'ID склада',
  `количество` int(11) NOT NULL DEFAULT 0 COMMENT 'Количество',
  `резерв` int(11) NOT NULL DEFAULT 0 COMMENT 'Зарезервировано',
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Остатки на складах';

--
-- Дамп данных таблицы `warehouse_stocks`
--

INSERT INTO `warehouse_stocks` (`id`, `product_id`, `warehouse_id`, `количество`, `резерв`, `updated_at`) VALUES
(1, 1, 1, 25, 5, '2026-05-07 03:39:31'),
(2, 1, 2, 20, 2, '2026-05-07 03:39:31'),
(3, 3, 1, 50, 10, '2026-05-07 03:39:31'),
(4, 3, 2, 30, 5, '2026-05-07 03:39:31'),
(5, 5, 1, 15, 3, '2026-05-07 03:39:31'),
(6, 7, 1, 30, 0, '2026-05-07 03:39:31'),
(7, 9, 1, 10, 2, '2026-05-07 03:39:31'),
(8, 13, 1, 100, 20, '2026-05-07 03:39:31'),
(9, 13, 3, 50, 10, '2026-05-07 03:39:31'),
(10, 15, 1, 40, 5, '2026-05-07 03:39:31'),
(11, 15, 2, 20, 0, '2026-05-07 03:39:31'),
(12, 15, 3, 20, 0, '2026-05-07 03:39:31'),
(13, 18, 1, 30, 5, '2026-05-07 03:39:31');

-- --------------------------------------------------------

--
-- Структура таблицы `wishlist`
--

CREATE TABLE `wishlist` (
  `id` int(11) NOT NULL COMMENT 'ID записи избранного',
  `user_id` int(11) NOT NULL COMMENT 'ID пользователя',
  `product_id` int(11) NOT NULL COMMENT 'ID товара',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Избранные товары';

--
-- Дамп данных таблицы `wishlist`
--

INSERT INTO `wishlist` (`id`, `user_id`, `product_id`, `created_at`) VALUES
(1, 3, 10, '2026-05-07 03:39:31'),
(2, 3, 6, '2026-05-07 03:39:31'),
(3, 4, 12, '2026-05-07 03:39:31');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Индексы таблицы `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `idx_cart_user` (`user_id`),
  ADD KEY `idx_cart_session` (`session_id`);

--
-- Индексы таблицы `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Индексы таблицы `car_brands`
--
ALTER TABLE `car_brands`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Индексы таблицы `car_models`
--
ALTER TABLE `car_models`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_model` (`car_brand_id`,`slug`);

--
-- Индексы таблицы `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Индексы таблицы `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `discount_coupons`
--
ALTER TABLE `discount_coupons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `промокод` (`промокод`);

--
-- Индексы таблицы `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `objects`
--
ALTER TABLE `objects`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `номер_заказа` (`номер_заказа`),
  ADD KEY `idx_номер_заказа` (`номер_заказа`),
  ADD KEY `idx_user_orders` (`user_id`),
  ADD KEY `idx_статус` (`статус`);

--
-- Индексы таблицы `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `idx_order_items` (`order_id`);

--
-- Индексы таблицы `page_views`
--
ALTER TABLE `page_views`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `артикул` (`артикул`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `brand_id` (`brand_id`),
  ADD KEY `idx_артикул` (`артикул`),
  ADD KEY `idx_цена` (`цена`),
  ADD KEY `idx_активно` (`активно`),
  ADD KEY `idx_популярный` (`популярный`);

--
-- Индексы таблицы `product_attributes`
--
ALTER TABLE `product_attributes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Индексы таблицы `product_compatibility`
--
ALTER TABLE `product_compatibility`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_compatibility` (`product_id`,`car_model_id`,`модификация`),
  ADD KEY `idx_car_model` (`car_model_id`);

--
-- Индексы таблицы `product_discounts`
--
ALTER TABLE `product_discounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Индексы таблицы `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Индексы таблицы `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `product_specifications`
--
ALTER TABLE `product_specifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Индексы таблицы `product_suppliers`
--
ALTER TABLE `product_suppliers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_product_supplier` (`product_id`,`supplier_id`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- Индексы таблицы `promotions`
--
ALTER TABLE `promotions`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Индексы таблицы `service_categories`
--
ALTER TABLE `service_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Индексы таблицы `shop_products`
--
ALTER TABLE `shop_products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `артикул` (`артикул`);

--
-- Индексы таблицы `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Индексы таблицы `user_addresses`
--
ALTER TABLE `user_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `госномер` (`госномер`);

--
-- Индексы таблицы `view_history`
--
ALTER TABLE `view_history`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `warehouses`
--
ALTER TABLE `warehouses`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `warehouse_stocks`
--
ALTER TABLE `warehouse_stocks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_склад_товар` (`product_id`,`warehouse_id`),
  ADD KEY `warehouse_id` (`warehouse_id`);

--
-- Индексы таблицы `wishlist`
--
ALTER TABLE `wishlist`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_wishlist` (`user_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `brands`
--
ALTER TABLE `brands`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID бренда', AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID записи корзины', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `car_brands`
--
ALTER TABLE `car_brands`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID марки автомобиля', AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `car_models`
--
ALTER TABLE `car_models`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID модели автомобиля', AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID категории', AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `clients`
--
ALTER TABLE `clients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `discount_coupons`
--
ALTER TABLE `discount_coupons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID купона', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `objects`
--
ALTER TABLE `objects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID заказа', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID позиции заказа', AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `page_views`
--
ALTER TABLE `page_views`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID товара', AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT для таблицы `product_attributes`
--
ALTER TABLE `product_attributes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID характеристики', AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT для таблицы `product_compatibility`
--
ALTER TABLE `product_compatibility`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID записи совместимости', AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT для таблицы `product_discounts`
--
ALTER TABLE `product_discounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID скидки', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID изображения', AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `product_reviews`
--
ALTER TABLE `product_reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID отзыва';

--
-- AUTO_INCREMENT для таблицы `product_specifications`
--
ALTER TABLE `product_specifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `product_suppliers`
--
ALTER TABLE `product_suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID связи', AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `promotions`
--
ALTER TABLE `promotions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `services`
--
ALTER TABLE `services`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT для таблицы `service_categories`
--
ALTER TABLE `service_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `shop_products`
--
ALTER TABLE `shop_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT для таблицы `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID поставщика', AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID пользователя', AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `user_addresses`
--
ALTER TABLE `user_addresses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID адреса', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `view_history`
--
ALTER TABLE `view_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `warehouses`
--
ALTER TABLE `warehouses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID склада', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `warehouse_stocks`
--
ALTER TABLE `warehouse_stocks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID записи остатка', AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT для таблицы `wishlist`
--
ALTER TABLE `wishlist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID записи избранного', AUTO_INCREMENT=4;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `car_models`
--
ALTER TABLE `car_models`
  ADD CONSTRAINT `car_models_ibfk_1` FOREIGN KEY (`car_brand_id`) REFERENCES `car_brands` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `product_attributes`
--
ALTER TABLE `product_attributes`
  ADD CONSTRAINT `product_attributes_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `product_compatibility`
--
ALTER TABLE `product_compatibility`
  ADD CONSTRAINT `product_compatibility_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_compatibility_ibfk_2` FOREIGN KEY (`car_model_id`) REFERENCES `car_models` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `product_discounts`
--
ALTER TABLE `product_discounts`
  ADD CONSTRAINT `product_discounts_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD CONSTRAINT `product_reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `product_specifications`
--
ALTER TABLE `product_specifications`
  ADD CONSTRAINT `product_specifications_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `product_suppliers`
--
ALTER TABLE `product_suppliers`
  ADD CONSTRAINT `product_suppliers_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_suppliers_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `user_addresses`
--
ALTER TABLE `user_addresses`
  ADD CONSTRAINT `user_addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `warehouse_stocks`
--
ALTER TABLE `warehouse_stocks`
  ADD CONSTRAINT `warehouse_stocks_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `warehouse_stocks_ibfk_2` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `wishlist`
--
ALTER TABLE `wishlist`
  ADD CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
