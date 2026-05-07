<?php
session_start();
require_once 'db.php';

if (!isset($_SESSION['logged_in']) || $_SESSION['logged_in'] !== true) {
    header('Location: login.php');
    exit;
}

$lang = $_COOKIE['lang'] ?? 'ru';
$theme = $_COOKIE['theme'] ?? 'light';
$page = $_GET['page'] ?? 'dashboard';

if (isset($_POST['save_settings'])) {
    $lang = $_POST['lang'] ?? 'ru';
    $theme = $_POST['theme'] ?? 'light';
    setcookie('lang', $lang, time() + 365*24*3600, '/');
    setcookie('theme', $theme, time() + 365*24*3600, '/');
    header('Location: index.php');
    exit;
}

// Добавление в корзину
if (isset($_GET['add_to_cart']) && $db_connected) {
    $id = (int)$_GET['add_to_cart'];
    $type = $_GET['type'] ?? 'material';
    
    if ($type == 'material' && in_array('shop_products', $tables)) {
        $stmt = $pdo->prepare("SELECT цена_розница FROM shop_products WHERE id = ?");
        $stmt->execute([$id]);
        $price = $stmt->fetchColumn();
        if ($price) {
            $pdo->prepare("INSERT INTO cart (user_id, тип_товара, product_id, количество, цена_на_момент) VALUES (1, 'материал', ?, 1, ?)")->execute([$id, $price]);
        }
    } elseif ($type == 'service' && in_array('services', $tables)) {
        $stmt = $pdo->prepare("SELECT базовая_цена FROM services WHERE id = ?");
        $stmt->execute([$id]);
        $price = $stmt->fetchColumn();
        if ($price) {
            $pdo->prepare("INSERT INTO cart (user_id, тип_товара, service_id, количество, цена_на_момент) VALUES (1, 'услуга', ?, 1, ?)")->execute([$id, $price]);
        }
    }
    header('Location: ' . ($_SERVER['HTTP_REFERER'] ?? 'index.php'));
    exit;
}

// Удаление из корзины
if (isset($_GET['remove_from_cart']) && $db_connected) {
    $pdo->prepare("DELETE FROM cart WHERE id = ?")->execute([(int)$_GET['remove_from_cart']]);
    header('Location: ?page=cart');
    exit;
}

// Получаем данные
$stats = [];
$orders = [];
$services = [];
$products = [];
$cart_items = [];
$cart_total = 0;
$categories = [];
$all_tables_data = [];

if ($db_connected) {
    try {
        $stats['orders'] = $pdo->query("SELECT COUNT(*) FROM orders")->fetchColumn();
        $stats['active'] = $pdo->query("SELECT COUNT(*) FROM orders WHERE статус IN ('в_работе','согласование')")->fetchColumn();
        $stats['done'] = $pdo->query("SELECT COUNT(*) FROM orders WHERE статус = 'завершен'")->fetchColumn();
        $stats['revenue'] = $pdo->query("SELECT COALESCE(SUM(итоговая_стоимость),0) FROM orders WHERE статус!='отменен'")->fetchColumn();
        
        if (in_array('orders', $tables)) {
            $orders = $pdo->query("SELECT o.*, c.фамилия, c.имя, obj.адрес as адрес_объекта FROM orders o JOIN clients c ON o.client_id=c.id JOIN objects obj ON o.object_id=obj.id ORDER BY o.created_at DESC LIMIT 20")->fetchAll();
        }
        if (in_array('service_categories', $tables)) {
            $categories = $pdo->query("SELECT sc.*, (SELECT COUNT(*) FROM services WHERE category_id=sc.id) as cnt FROM service_categories sc ORDER BY sc.сортировка")->fetchAll();
        }
        if (in_array('services', $tables)) {
            $cat = $_GET['cat'] ?? '';
            $sql = "SELECT s.*, sc.название as кат_название FROM services s JOIN service_categories sc ON s.category_id=sc.id WHERE s.активно=1";
            if ($cat) $sql .= " AND s.category_id=".(int)$cat;
            $sql .= " ORDER BY s.популярность DESC";
            $services = $pdo->query($sql)->fetchAll();
        }
        if (in_array('shop_products', $tables)) {
            $products = $pdo->query("SELECT sp.*, sc.название as кат_название FROM shop_products sp JOIN service_categories sc ON sp.category_id=sc.id WHERE sp.активно=1 ORDER BY sp.популярность DESC")->fetchAll();
        }
        if (in_array('cart', $tables)) {
            $cart_items = $pdo->query("SELECT c.*, COALESCE(sp.название, srv.название) as товар, COALESCE(sp.артикул, 'услуга') as артикул FROM cart c LEFT JOIN shop_products sp ON c.product_id=sp.id LEFT JOIN services srv ON c.service_id=srv.id ORDER BY c.created_at DESC")->fetchAll();
            foreach ($cart_items as $item) $cart_total += $item['цена_на_момент'] * $item['количество'];
        }
    } catch (Exception $e) {}
}

function statusBadge($s) {
    $b = ['новый'=>['#bee3f8','#2b6cb0','Новый'],'в_работе'=>['#c6f6d5','#276749','В работе'],'завершен'=>['#c6f6d5','#22543d','Завершен'],'отменен'=>['#fed7d7','#9b2c2c','Отменен']];
    $x = $b[$s] ?? ['#e2e8f0','#4a5568',$s];
    return "<span style='background:{$x[0]};color:{$x[1]};padding:3px 8px;border-radius:10px;font-size:11px;font-weight:600;'>{$x[2]}</span>";
}
?>
<!DOCTYPE html>
<html lang="ru" data-theme="<?php echo $theme; ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ремонт-Хаб</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header class="header">
        <div class="header-main">
            <div class="container header-main-inner">
                <a href="index.php" class="logo">
                    <span class="logo-icon">🏗️</span>
                    <div><div class="logo-text">Ремонт<span class="logo-accent">Хаб</span></div><div class="logo-slogan">ремонт квартир под ключ</div></div>
                </a>
                
                <!-- Кнопка КАТАЛОГ -->
                <div class="dropdown">
                    <button class="catalog-btn">📂 Каталог ▼</button>
                    <div class="dropdown-menu">
                        <?php foreach ($categories as $cat): ?>
                            <div class="dropdown-group">
                                <a href="?page=services&cat=<?php echo $cat['id']; ?>" class="dropdown-title">
                                    <?php echo $cat['иконка']; ?> <?php echo $cat['название']; ?>
                                    <span class="dropdown-count"><?php echo $cat['cnt']; ?></span>
                                </a>
                            </div>
                        <?php endforeach; ?>
                        <div class="dropdown-divider"></div>
                        <a href="?page=shop" class="dropdown-title">🛒 Магазин материалов</a>
                    </div>
                </div>
                
                <div class="search-box">
                    <input type="text" placeholder="Поиск услуги или товара...">
                    <button>🔍</button>
                </div>
                
                <div class="header-icons">
                    <a href="?page=cart" class="cart-icon-link">
                        🛒
                        <?php if (count($cart_items) > 0): ?>
                            <span class="cart-badge"><?php echo count($cart_items); ?></span>
                        <?php endif; ?>
                    </a>
                    <button class="icon-btn" onclick="openModal('settingsModal')">⚙️</button>
                    <a href="logout.php" class="icon-btn">🚪</a>
                </div>
            </div>
        </div>
        <nav class="header-nav">
            <div class="container">
                <a href="index.php" class="<?php echo $page=='dashboard'?'active':''; ?>">📊 Дашборд</a>
                <a href="?page=orders" class="<?php echo $page=='orders'?'active':''; ?>">📋 Заказы</a>
                <a href="?page=clients" class="<?php echo $page=='clients'?'active':''; ?>">👥 Клиенты</a>
                <a href="?page=staff" class="<?php echo $page=='staff'?'active':''; ?>">👷 Персонал</a>
                <a href="?page=logistics" class="<?php echo $page=='logistics'?'active':''; ?>">🚚 Логистика</a>
            </div>
        </nav>
    </header>
    
    <main class="main-content">
        <div class="container">
        <?php if ($page == 'services'): ?>
            <h2 class="section-title">🔧 Услуги <?php echo isset($_GET['cat']) ? '- ' . ($categories[array_search($_GET['cat'], array_column($categories, 'id'))]['название'] ?? '') : ''; ?></h2>
            
            <!-- Фильтр -->
            <div class="filter-bar">
                <a href="?page=services" class="filter-btn <?php echo empty($_GET['cat'])?'active':''; ?>">Все услуги</a>
                <?php foreach ($categories as $c): ?>
                    <a href="?page=services&cat=<?php echo $c['id']; ?>" class="filter-btn <?php echo ($_GET['cat']??'')==$c['id']?'active':''; ?>"><?php echo $c['иконка']; ?> <?php echo $c['название']; ?></a>
                <?php endforeach; ?>
            </div>
            
            <div class="products-grid">
                <?php foreach ($services as $s): ?>
                    <div class="product-card">
                        <div class="product-card-header">
                            <span class="category-badge"><?php echo $s['кат_название']; ?></span>
                            <span>⭐ <?php echo $s['популярность']; ?></span>
                        </div>
                        <h3><?php echo $s['название']; ?></h3>
                        <p class="text-muted"><?php echo mb_substr($s['описание']??'', 0, 100); ?>...</p>
                        <div class="product-meta">
                            <span>📏 <?php echo $s['единица_измерения']; ?></span>
                            <span>⏱️ <?php echo $s['срок_выполнения']; ?></span>
                        </div>
                        <div class="product-price">от <?php echo number_format($s['базовая_цена'], 0, ',', ' '); ?> ₽</div>
                        <a href="?add_to_cart=<?php echo $s['id']; ?>&type=service" class="btn-add-cart">🛒 В корзину</a>
                    </div>
                <?php endforeach; ?>
            </div>
            
        <?php elseif ($page == 'shop'): ?>
            <h2 class="section-title">🛒 Магазин материалов</h2>
            
            <div class="products-grid">
                <?php foreach ($products as $p): ?>
                    <div class="product-card">
                        <div class="product-card-header">
                            <span class="category-badge">📦 <?php echo $p['кат_название']; ?></span>
                            <?php if ($p['количество_на_складе'] > 0): ?>
                                <span style="color:#48bb78;font-size:12px;">✅ В наличии</span>
                            <?php else: ?>
                                <span style="color:#e53e3e;font-size:12px;">❌ Нет</span>
                            <?php endif; ?>
                        </div>
                        <h3><?php echo $p['название']; ?></h3>
                        <p class="text-muted">Арт: <?php echo $p['артикул']; ?></p>
                        <p class="text-muted"><?php echo mb_substr($p['описание'],0,80); ?>...</p>
                        <div class="product-price"><?php echo number_format($p['цена_розница'], 0, ',', ' '); ?> ₽</div>
                        <?php if ($p['количество_на_складе'] > 0): ?>
                            <a href="?add_to_cart=<?php echo $p['id']; ?>&type=material" class="btn-add-cart">🛒 В корзину</a>
                        <?php endif; ?>
                    </div>
                <?php endforeach; ?>
            </div>
            
        <?php elseif ($page == 'cart'): ?>
            <h2 class="section-title">🛒 Корзина</h2>
            <?php if (!empty($cart_items)): ?>
                <div class="card">
                    <table class="data-table">
                        <thead><tr><th>Товар/Услуга</th><th>Цена</th><th>Кол-во</th><th>Сумма</th><th></th></tr></thead>
                        <tbody>
                            <?php foreach ($cart_items as $item): 
                                $sum = $item['цена_на_момент'] * $item['количество'];
                            ?>
                                <tr>
                                    <td><strong><?php echo $item['товар']; ?></strong><br><small><?php echo $item['артикул']; ?></small></td>
                                    <td><?php echo number_format($item['цена_на_момент'], 0, ',', ' '); ?> ₽</td>
                                    <td><?php echo $item['количество']; ?></td>
                                    <td><strong><?php echo number_format($sum, 0, ',', ' '); ?> ₽</strong></td>
                                    <td><a href="?remove_from_cart=<?php echo $item['id']; ?>" style="color:#e53e3e;text-decoration:none;">❌</a></td>
                                </tr>
                            <?php endforeach; ?>
                            <tr style="font-size:18px;font-weight:700;background:#f7fafc;">
                                <td colspan="3" style="text-align:right;padding:15px;">Итого:</td>
                                <td style="color:#f97316;padding:15px;"><?php echo number_format($cart_total, 0, ',', ' '); ?> ₽</td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                    <div style="text-align:right;margin-top:20px;">
                        <button class="btn-primary" style="width:auto;padding:15px 40px;">📋 Оформить заказ</button>
                    </div>
                </div>
            <?php else: ?>
                <div class="card" style="text-align:center;padding:60px;">
                    <p style="font-size:64px;">🛒</p>
                    <h3>Корзина пуста</h3>
                    <p class="text-muted">Добавьте услуги из каталога или товары из магазина</p>
                    <a href="?page=services" class="btn-primary" style="display:inline-block;width:auto;margin-top:20px;text-decoration:none;">🔧 Перейти к услугам</a>
                </div>
            <?php endif; ?>
            
        <?php elseif ($page == 'orders'): ?>
            <h2 class="section-title">📋 Заказы</h2>
            <div class="card"><table class="data-table"><thead><tr><th>Номер</th><th>Клиент</th><th>Адрес</th><th>Сумма</th><th>Статус</th></tr></thead><tbody>
                <?php foreach($orders as $o): ?>
                    <tr><td><strong><?php echo $o['номер_заказа']; ?></strong></td><td><?php echo $o['фамилия'].' '.$o['имя']; ?></td><td><?php echo mb_substr($o['адрес_объекта'],0,30); ?>...</td><td><?php echo number_format($o['итоговая_стоимость'],0,',',' '); ?> ₽</td><td><?php echo statusBadge($o['статус']); ?></td></tr>
                <?php endforeach; ?>
            </tbody></table></div>
            
        <?php else: ?>
            <h2 class="section-title">📊 Дашборд</h2>
            <div class="stats-grid">
                <div class="stat-card" style="--accent:#4299e1;"><div class="stat-icon">📋</div><div class="stat-number"><?php echo $stats['orders']??0; ?></div><div class="stat-label">Заказов</div></div>
                <div class="stat-card" style="--accent:#f97316;"><div class="stat-icon">🔨</div><div class="stat-number"><?php echo $stats['active']??0; ?></div><div class="stat-label">В работе</div></div>
                <div class="stat-card" style="--accent:#48bb78;"><div class="stat-icon">✅</div><div class="stat-number"><?php echo $stats['done']??0; ?></div><div class="stat-label">Завершено</div></div>
                <div class="stat-card" style="--accent:#ed8936;"><div class="stat-icon">💰</div><div class="stat-number"><?php echo number_format(($stats['revenue']??0)/1000,1); ?>K</div><div class="stat-label">Выручка</div></div>
            </div>
            <?php if (!empty($categories)): ?>
                <div class="card"><h3>📂 Популярные категории</h3><div class="categories-grid">
                    <?php foreach(array_slice($categories,0,6) as $c): ?>
                        <a href="?page=services&cat=<?php echo $c['id']; ?>" class="category-card">
                            <div class="category-icon-big"><?php echo $c['иконка']; ?></div>
                            <h3><?php echo $c['название']; ?></h3>
                        </a>
                    <?php endforeach; ?>
                </div></div>
            <?php endif; ?>
        <?php endif; ?>
        </div>
    </main>
    
    <!-- ФУТЕР -->
    <footer class="footer">
        <div class="container">
            <div class="footer-grid">
                <div class="footer-col">
                    <h4>Контакты</h4>
                    <div class="footer-contact-item">
                        <a href="mailto:sle4666hoi4@gmail.com">sle4666hoi4@gmail.com</a>
                        <span>консультация по заказам, технические вопросы, работа с юридическими лицами</span>
                    </div>
                    <div class="footer-contact-item">
                        <a href="mailto:sle4666hoi4@gmail.com">sle4666hoi4@gmail.com</a>
                        <span>предложения о сотрудничестве, реклама</span>
                    </div>
                </div>
                <div class="footer-col">
                    <h4>Адрес</h4>
                    <p class="footer-address">территория ГМ АЗС, с20/27,<br>посёлок городского типа Инской,<br>Кемеровская область — Кузбасс</p>
                    <div class="footer-rating"><div class="rating-value">4,8</div><div class="rating-text">Рейтинг организации в Яндексе</div></div>
                </div>
                <div class="footer-col">
                    <h4>Информация</h4>
                    <ul class="footer-links">
                        <li><a href="#">Политика обработки персональных данных</a></li>
                        <li><a href="#">Оферта</a></li>
                        <li><a href="#">Согласие на обработку персональных данных</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Услуги</h4>
                    <ul class="footer-links">
                        <?php foreach(array_slice($categories,0,8) as $cat): ?>
                            <li><a href="?page=services&cat=<?php echo $cat['id']; ?>"><?php echo $cat['иконка']; ?> <?php echo $cat['название']; ?></a></li>
                        <?php endforeach; ?>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom"><p>© 2026 Ремонт-Хаб | Система управления заказами на ремонт квартир</p></div>
        </div>
    </footer>
    
    <!-- Настройки -->
    <div id="settingsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header"><h3>⚙️ Настройки</h3><span class="close" onclick="closeModal('settingsModal')">&times;</span></div>
            <div class="modal-body">
                <form method="POST">
                    <div class="setting-group"><label>Тема</label>
                        <div class="theme-options">
                            <label class="theme-option <?php echo $theme=='light'?'active':''; ?>"><input type="radio" name="theme" value="light" <?php echo $theme=='light'?'checked':''; ?>>☀️ Светлая</label>
                            <label class="theme-option <?php echo $theme=='dark'?'active':''; ?>"><input type="radio" name="theme" value="dark" <?php echo $theme=='dark'?'checked':''; ?>>🌙 Тёмная</label>
                        </div>
                    </div>
                    <button type="submit" name="save_settings" class="btn-primary">💾 Сохранить</button>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        function openModal(id){document.getElementById(id).style.display='block';}
        function closeModal(id){document.getElementById(id).style.display='none';}
        window.onclick=function(e){if(e.target.className==='modal')e.target.style.display='none';}
    </script>
</body>
</html>