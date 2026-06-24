<?php
session_start();
require_once 'db.php';

if (!isset($_SESSION['logged_in']) || $_SESSION['logged_in'] !== true) {
    header('Location: login.php');
    exit;
}

$page = $_GET['page'] ?? 'dashboard';

// Добавление в корзину
if (isset($_GET['add_to_cart']) && $db_connected) {
    $id = (int)$_GET['add_to_cart'];
    $type = $_GET['type'] ?? 'material';
    
    if ($type == 'service' && in_array('services', $tables)) {
        $stmt = $pdo->prepare("SELECT базовая_цена FROM services WHERE id=?");
        $stmt->execute([$id]);
        $price = $stmt->fetchColumn();
        if ($price) {
            $pdo->prepare("INSERT INTO cart (user_id, тип_товара, service_id, количество, цена_на_момент) VALUES (1,'услуга',?,1,?)")->execute([$id,$price]);
        }
    } elseif (in_array('shop_products', $tables)) {
        $stmt = $pdo->prepare("SELECT цена_розница FROM shop_products WHERE id=?");
        $stmt->execute([$id]);
        $price = $stmt->fetchColumn();
        if ($price) {
            $pdo->prepare("INSERT INTO cart (user_id, тип_товара, product_id, количество, цена_на_момент) VALUES (1,'материал',?,1,?)")->execute([$id,$price]);
        }
    }
    header('Location: ' . ($_SERVER['HTTP_REFERER'] ?? 'index.php'));
    exit;
}

// Удаление из корзины
if (isset($_GET['remove_from_cart']) && $db_connected) {
    $pdo->prepare("DELETE FROM cart WHERE id=?")->execute([(int)$_GET['remove_from_cart']]);
    header('Location: ?page=cart');
    exit;
}

// Данные
$stats = [];
$services = [];
$products = [];
$cart_items = [];
$cart_total = 0;
$cart_count = 0;

if ($db_connected) {
    try {
        $stats['orders'] = $pdo->query("SELECT COUNT(*) FROM orders")->fetchColumn();
        $stats['active'] = $pdo->query("SELECT COUNT(*) FROM orders WHERE статус IN ('в_работе','согласование')")->fetchColumn();
        $stats['done'] = $pdo->query("SELECT COUNT(*) FROM orders WHERE статус='завершен'")->fetchColumn();
        $stats['revenue'] = $pdo->query("SELECT COALESCE(SUM(итоговая_стоимость),0) FROM orders WHERE статус!='отменен'")->fetchColumn();
        
        if (in_array('services', $tables)) {
            $services = $pdo->query("SELECT s.*, sc.название as кат_название FROM services s JOIN service_categories sc ON s.category_id=sc.id WHERE s.активно=1 LIMIT 12")->fetchAll();
        }
        if (in_array('shop_products', $tables)) {
            $products = $pdo->query("SELECT * FROM shop_products WHERE активно=1 LIMIT 12")->fetchAll();
        }
        if (in_array('cart', $tables)) {
            $cart_items = $pdo->query("SELECT c.*, COALESCE(sp.название, srv.название) as товар FROM cart c LEFT JOIN shop_products sp ON c.product_id=sp.id LEFT JOIN services srv ON c.service_id=srv.id")->fetchAll();
            foreach ($cart_items as $item) $cart_total += $item['цена_на_момент'] * $item['количество'];
            $cart_count = count($cart_items);
        }
    } catch (Exception $e) {}
}
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ремонт-Хаб</title>
    <style>
        <?php echo file_get_contents('css/style.css'); ?>
    </style>
</head>
<body>
    <header class="header">
        <div class="header-main">
            <div class="container header-main-inner">
                <a href="index.php" class="logo">
                    <span class="logo-icon">🏗️</span>
                    <div>
                        <div class="logo-text">Ремонт<span class="logo-accent">Хаб</span></div>
                        <div class="logo-slogan">ремонт квартир под ключ</div>
                    </div>
                </a>
                <div class="search-box">
                    <input type="text" placeholder="Поиск...">
                    <button>🔍</button>
                </div>
                <div class="header-icons">
                    <a href="?page=cart" class="cart-icon-link">
                        🛒
                        <?php if ($cart_count > 0): ?>
                            <span class="cart-badge"><?php echo $cart_count; ?></span>
                        <?php endif; ?>
                    </a>
                    <a href="logout.php" class="icon-btn">🚪</a>
                </div>
            </div>
        </div>
        <nav class="header-nav">
            <div class="container">
                <a href="index.php" class="<?php echo $page=='dashboard'?'active':''; ?>">📊 Дашборд</a>
                <a href="?page=services" class="<?php echo $page=='services'?'active':''; ?>">🔧 Услуги</a>
                <a href="?page=shop" class="<?php echo $page=='shop'?'active':''; ?>">🛒 Магазин</a>
                <a href="?page=cart" class="<?php echo $page=='cart'?'active':''; ?>">🛒 Корзина</a>
            </div>
        </nav>
    </header>
    
    <main class="main-content">
        <div class="container">
            <?php if ($page == 'services'): ?>
                <h2 class="section-title">🔧 Услуги</h2>
                <div class="products-grid">
                    <?php foreach ($services as $s): ?>
                        <div class="product-card">
                            <div class="product-card-header">
                                <span class="category-badge"><?php echo $s['кат_название'] ?? 'Услуга'; ?></span>
                            </div>
                            <h3><?php echo $s['название']; ?></h3>
                            <div class="product-price">от <?php echo number_format($s['базовая_цена'], 0, ',', ' '); ?> ₽</div>
                            <div class="product-actions">
                                <a href="?add_to_cart=<?php echo $s['id']; ?>&type=service" class="btn-add-cart">🛒 В корзину</a>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>
                
            <?php elseif ($page == 'shop'): ?>
                <h2 class="section-title">🛒 Магазин материалов</h2>
                <div class="products-grid">
                    <?php foreach ($products as $p): ?>
                        <div class="product-card">
                            <div class="product-card-header">
                                <span class="category-badge">📦 Товар</span>
                                <?php if ($p['количество_на_складе'] > 0): ?>
                                    <span style="color:#22c55e;">✅ В наличии</span>
                                <?php endif; ?>
                            </div>
                            <h3><?php echo $p['название']; ?></h3>
                            <p class="text-muted">Арт: <?php echo $p['артикул']; ?></p>
                            <div class="product-price"><?php echo number_format($p['цена_розница'], 0, ',', ' '); ?> ₽</div>
                            <div class="product-actions">
                                <?php if ($p['количество_на_складе'] > 0): ?>
                                    <a href="?add_to_cart=<?php echo $p['id']; ?>&type=material" class="btn-add-cart">🛒 В корзину</a>
                                <?php endif; ?>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>
                
            <?php elseif ($page == 'cart'): ?>
                <h2 class="section-title">🛒 Корзина</h2>
                <?php if (!empty($cart_items)): ?>
                    <div class="card">
                        <table class="data-table">
                            <thead><tr><th>Товар</th><th>Цена</th><th>Кол-во</th><th>Сумма</th><th></th></tr></thead>
                            <tbody>
                                <?php foreach ($cart_items as $item): 
                                    $sum = $item['цена_на_момент'] * $item['количество'];
                                ?>
                                    <tr>
                                        <td><strong><?php echo $item['товар']; ?></strong></td>
                                        <td><?php echo number_format($item['цена_на_момент'],0,',',' '); ?> ₽</td>
                                        <td><?php echo $item['количество']; ?></td>
                                        <td><strong><?php echo number_format($sum,0,',',' '); ?> ₽</strong></td>
                                        <td><a href="?remove_from_cart=<?php echo $item['id']; ?>" style="color:#ef4444;">❌</a></td>
                                    </tr>
                                <?php endforeach; ?>
                                <tr style="font-size:18px;font-weight:700;background:#f8fafc;">
                                    <td colspan="3" style="text-align:right;padding:15px;">Итого:</td>
                                    <td style="color:#f97316;padding:15px;"><?php echo number_format($cart_total,0,',',' '); ?> ₽</td>
                                    <td></td>
                                </tr>
                            </tbody>
                        </table>
                        <div style="text-align:right;margin-top:20px;">
                            <button class="btn-primary">📋 Оформить заказ</button>
                        </div>
                    </div>
                <?php else: ?>
                    <div style="text-align:center;padding:80px 20px;">
                        <div style="font-size:80px;">🛒</div>
                        <h3>Корзина пуста</h3>
                        <p style="color:#64748b;">Добавьте услуги или товары</p>
                        <a href="?page=services" class="btn-primary" style="margin-top:20px;">🔧 К услугам</a>
                    </div>
                <?php endif; ?>
                
            <?php else: ?>
                <h2 class="section-title">📊 Дашборд</h2>
                <div class="stats-grid">
                    <div class="stat-card" style="--accent:#3b82f6;"><div class="stat-icon">📋</div><div class="stat-number"><?php echo $stats['orders']??0; ?></div><div class="stat-label">ЗАКАЗОВ</div></div>
                    <div class="stat-card" style="--accent:#f97316;"><div class="stat-icon">🔨</div><div class="stat-number"><?php echo $stats['active']??0; ?></div><div class="stat-label">В РАБОТЕ</div></div>
                    <div class="stat-card" style="--accent:#22c55e;"><div class="stat-icon">✅</div><div class="stat-number"><?php echo $stats['done']??0; ?></div><div class="stat-label">ЗАВЕРШЕНО</div></div>
                    <div class="stat-card" style="--accent:#eab308;"><div class="stat-icon">💰</div><div class="stat-number"><?php echo number_format(($stats['revenue']??0)/1000,1); ?>K</div><div class="stat-label">ВЫРУЧКА</div></div>
                </div>
            <?php endif; ?>
        </div>
    </main>
    
    <footer class="footer">
        <div class="container">
            <div class="footer-grid">
                <div class="footer-col">
                    <h4>Контакты</h4>
                    <div class="footer-contact-item">
                        <a href="mailto:sle4666hoi4@gmail.com">sle4666hoi4@gmail.com</a>
                        <span>консультация по заказам</span>
                    </div>
                </div>
                <div class="footer-col">
                    <h4>Адрес</h4>
                    <p class="footer-address">территория ГМ АЗС, с20/27,<br>пгт Инской, Кемеровская обл.</p>
                    <div class="footer-rating">
                        <div class="rating-value">4,8</div>
                        <div class="rating-text">Рейтинг в Яндексе</div>
                    </div>
                </div>
                <div class="footer-col">
                    <h4>Информация</h4>
                    <ul class="footer-links">
                        <li><a href="#">Политика обработки данных</a></li>
                        <li><a href="#">Оферта</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom"><p>© 2026 Ремонт-Хаб</p></div>
        </div>
    </footer>
</body>
</html>
