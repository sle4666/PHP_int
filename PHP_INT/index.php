<?php
session_start();
require_once 'db.php';

// Проверка авторизации
if (!isset($_SESSION['logged_in']) || $_SESSION['logged_in'] !== true) {
    header('Location: login.php');
    exit;
}

// Настройки
$lang = $_COOKIE['lang'] ?? 'ru';
$theme = $_COOKIE['theme'] ?? 'light';

// Сохранение настроек
if (isset($_POST['save_settings'])) {
    $lang = $_POST['lang'] ?? 'ru';
    $theme = $_POST['theme'] ?? 'light';
    setcookie('lang', $lang, time() + 365*24*3600, '/');
    setcookie('theme', $theme, time() + 365*24*3600, '/');
    header('Location: index.php');
    exit;
}

// Словарь
$tr = [
    'ru' => [
        'home' => 'Главная', 'catalog' => 'Каталог', 'tables' => 'База данных',
        'settings' => 'Настройки', 'logout' => 'Выход', 'search' => 'Поиск запчастей...',
        'popular' => 'Популярные товары', 'all_products' => 'Все товары',
        'price' => 'Цена', 'buy' => 'Купить', 'in_stock' => 'В наличии',
        'out_of_stock' => 'Нет в наличии', 'article' => 'Артикул',
        'categories' => 'Категории', 'brands' => 'Бренды',
        'language' => 'Язык', 'theme' => 'Тема', 'save' => 'Сохранить',
        'cancel' => 'Отмена', 'translate' => 'Переводчик',
        'translate_text' => 'Введите текст', 'translate_btn' => 'Перевести',
        'result' => 'Результат', 'russian' => 'Русский', 'english' => 'English',
        'light' => 'Светлая', 'dark' => 'Тёмная',
    ],
    'en' => [
        'home' => 'Home', 'catalog' => 'Catalog', 'tables' => 'Database',
        'settings' => 'Settings', 'logout' => 'Logout', 'search' => 'Search parts...',
        'popular' => 'Popular Products', 'all_products' => 'All Products',
        'price' => 'Price', 'buy' => 'Buy', 'in_stock' => 'In Stock',
        'out_of_stock' => 'Out of Stock', 'article' => 'Article',
        'categories' => 'Categories', 'brands' => 'Brands',
        'language' => 'Language', 'theme' => 'Theme', 'save' => 'Save',
        'cancel' => 'Cancel', 'translate' => 'Translator',
        'translate_text' => 'Enter text', 'translate_btn' => 'Translate',
        'result' => 'Result', 'russian' => 'Russian', 'english' => 'English',
        'light' => 'Light', 'dark' => 'Dark',
    ]
];

function t($key) { global $tr, $lang; return $tr[$lang][$key] ?? $key; }

// Получаем данные
$page = $_GET['page'] ?? 'home';
$categories = [];
$products = [];
$brands = [];

if ($db_connected) {
    try {
        if (in_array('categories', $tables)) {
            $categories = $pdo->query("SELECT * FROM categories LIMIT 20")->fetchAll();
        }
        if (in_array('products', $tables)) {
            $products = $pdo->query("SELECT * FROM products WHERE активно = 1 LIMIT 12")->fetchAll();
        }
        if (in_array('brands', $tables)) {
            $brands = $pdo->query("SELECT * FROM brands LIMIT 10")->fetchAll();
        }
    } catch (Exception $e) {}
}

// Товары по категории
$selected_category = $_GET['category'] ?? '';
$category_products = [];
if ($selected_category && $db_connected) {
    try {
        $stmt = $pdo->prepare("SELECT * FROM products WHERE category_id = ? LIMIT 50");
        $stmt->execute([$selected_category]);
        $category_products = $stmt->fetchAll();
    } catch (Exception $e) {}
}

// Данные таблиц
$selected_table = $_GET['table'] ?? '';
$table_data = ['columns' => [], 'rows' => [], 'count' => 0];
if ($selected_table && $db_connected && $page == 'tables') {
    $table_data = getTableData($pdo, $selected_table);
}
$table_stats = $db_connected ? getTableStats($pdo, $tables) : [];

// Перевод через Google
if (isset($_POST['ajax_translate'])) {
    header('Content-Type: application/json');
    $text = $_POST['text'] ?? '';
    $from = $_POST['from'] ?? 'en';
    $to = $_POST['to'] ?? 'ru';
    
    $url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl={$from}&tl={$to}&dt=t&q=" . urlencode($text);
    $response = @file_get_contents($url);
    
    if ($response) {
        $json = json_decode($response, true);
        $translated = '';
        if (isset($json[0])) {
            foreach ($json[0] as $seg) $translated .= $seg[0];
        }
        echo json_encode(['translated' => $translated]);
    } else {
        echo json_encode(['translated' => '']);
    }
    exit;
}
?>
<!DOCTYPE html>
<html lang="<?php echo $lang; ?>" data-theme="<?php echo $theme; ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>avtoZ - <?php echo t($page == 'home' ? 'home' : $page); ?></title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Шапка -->
    <header class="header">
        <div class="header-top">
            <div class="container header-inner">
                <a href="index.php" class="logo">
                    <span class="logo-icon">🚗</span>
                    <span class="logo-text">avto<span class="logo-accent">Z</span></span>
                </a>
                
                <div class="search-box">
                    <input type="text" placeholder="<?php echo t('search'); ?>" class="search-input">
                    <button class="search-btn">🔍</button>
                </div>
                
                <div class="header-actions">
                    <button class="icon-btn" onclick="openModal('translatorModal')" title="<?php echo t('translate'); ?>">
                        🌐
                    </button>
                    <button class="icon-btn" onclick="openModal('settingsModal')" title="<?php echo t('settings'); ?>">
                        ⚙️
                    </button>
                    <a href="logout.php" class="btn-logout"><?php echo t('logout'); ?></a>
                </div>
            </div>
        </div>
        
        <nav class="header-nav">
            <div class="container">
                <a href="index.php" class="nav-link <?php echo $page == 'home' ? 'active' : ''; ?>">
                    🏠 <?php echo t('home'); ?>
                </a>
                <a href="?page=catalog" class="nav-link <?php echo $page == 'catalog' ? 'active' : ''; ?>">
                    📂 <?php echo t('catalog'); ?>
                </a>
                <a href="?page=tables" class="nav-link <?php echo $page == 'tables' ? 'active' : ''; ?>">
                    🗄️ <?php echo t('tables'); ?>
                </a>
            </div>
        </nav>
    </header>
    
    <!-- Основной контент -->
    <main class="container main-content">
        <?php if ($page == 'catalog' && $selected_category): ?>
            <!-- Товары категории -->
            <div class="section">
                <h2 class="section-title">📁 Товары в категории</h2>
                <div class="products-grid">
                    <?php foreach ($category_products as $p): ?>
                        <div class="product-card">
                            <div class="product-image">
                                <img src="https://via.placeholder.com/300x300/e2e8f0/4a5568?text=<?php echo urlencode($p['название'] ?? $p['name'] ?? 'Part'); ?>" 
                                     alt="<?php echo htmlspecialchars($p['название'] ?? $p['name'] ?? ''); ?>">
                                <?php if (($p['количество_на_складе'] ?? $p['quantity'] ?? 0) > 0): ?>
                                    <span class="stock-badge in-stock">✅ <?php echo t('in_stock'); ?></span>
                                <?php else: ?>
                                    <span class="stock-badge out-of-stock">❌ <?php echo t('out_of_stock'); ?></span>
                                <?php endif; ?>
                            </div>
                            <div class="product-info">
                                <h3><?php echo htmlspecialchars(mb_substr($p['название'] ?? $p['name'] ?? '', 0, 50)); ?></h3>
                                <p class="product-article"><?php echo t('article'); ?>: <?php echo htmlspecialchars($p['артикул'] ?? $p['article'] ?? '-'); ?></p>
                                <div class="product-price"><?php echo number_format($p['цена'] ?? $p['price'] ?? 0, 0, ',', ' '); ?> ₽</div>
                                <button class="btn btn-primary">🛒 <?php echo t('buy'); ?></button>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>
            </div>
            
        <?php elseif ($page == 'catalog'): ?>
            <!-- Каталог категорий -->
            <div class="section">
                <h2 class="section-title">📂 <?php echo t('categories'); ?></h2>
                <div class="categories-grid">
                    <?php foreach ($categories as $cat): ?>
                        <a href="?page=catalog&category=<?php echo $cat['id']; ?>" class="category-card">
                            <div class="category-img">
                                <img src="https://via.placeholder.com/400x300/e2e8f0/4a5568?text=<?php echo urlencode($cat['name'] ?? $cat['название'] ?? ''); ?>" 
                                     alt="<?php echo htmlspecialchars($cat['name'] ?? $cat['название'] ?? ''); ?>">
                            </div>
                            <div class="category-info">
                                <h3><?php echo htmlspecialchars($cat['name'] ?? $cat['название'] ?? ''); ?></h3>
                            </div>
                        </a>
                    <?php endforeach; ?>
                </div>
            </div>
            
        <?php elseif ($page == 'tables'): ?>
            <!-- Таблицы БД -->
            <div class="section">
                <h2 class="section-title">🗄️ <?php echo t('tables'); ?></h2>
                <div class="tabs-nav">
                    <?php foreach ($tables as $table): ?>
                        <a href="?page=tables&table=<?php echo urlencode($table); ?>" 
                           class="tab-link <?php echo $table === $selected_table ? 'active' : ''; ?>">
                            <?php echo htmlspecialchars($table); ?>
                        </a>
                    <?php endforeach; ?>
                </div>
                
                <?php if ($selected_table): ?>
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <?php foreach ($table_data['columns'] as $col): ?>
                                        <th><?php echo htmlspecialchars($col); ?></th>
                                    <?php endforeach; ?>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($table_data['rows'] as $i => $row): ?>
                                <tr>
                                    <td><?php echo $i + 1; ?></td>
                                    <?php foreach ($row as $val): ?>
                                        <td><?php echo htmlspecialchars(mb_substr($val ?? '', 0, 100)); ?></td>
                                    <?php endforeach; ?>
                                </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                <?php endif; ?>
            </div>
            
        <?php else: ?>
            <!-- Главная -->
            <?php if (!empty($products)): ?>
                <div class="section">
                    <h2 class="section-title">⭐ <?php echo t('popular'); ?></h2>
                    <div class="products-grid">
                        <?php foreach ($products as $p): ?>
                            <div class="product-card">
                                <div class="product-image">
                                    <img src="https://via.placeholder.com/300x300/e2e8f0/4a5568?text=<?php echo urlencode(mb_substr($p['название'] ?? $p['name'] ?? 'Part', 0, 20)); ?>" 
                                         alt="<?php echo htmlspecialchars($p['название'] ?? $p['name'] ?? ''); ?>">
                                    <?php if (($p['количество_на_складе'] ?? $p['quantity'] ?? 0) > 0): ?>
                                        <span class="stock-badge in-stock">✅ <?php echo t('in_stock'); ?></span>
                                    <?php else: ?>
                                        <span class="stock-badge out-of-stock">❌ <?php echo t('out_of_stock'); ?></span>
                                    <?php endif; ?>
                                </div>
                                <div class="product-info">
                                    <h3><?php echo htmlspecialchars(mb_substr($p['название'] ?? $p['name'] ?? '', 0, 50)); ?></h3>
                                    <p class="product-article"><?php echo t('article'); ?>: <?php echo htmlspecialchars($p['артикул'] ?? $p['article'] ?? '-'); ?></p>
                                    <div class="product-price"><?php echo number_format($p['цена'] ?? $p['price'] ?? 0, 0, ',', ' '); ?> ₽</div>
                                    <button class="btn btn-primary">🛒 <?php echo t('buy'); ?></button>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </div>
            <?php endif; ?>
            
            <?php if (!empty($categories)): ?>
                <div class="section">
                    <h2 class="section-title">📂 <?php echo t('categories'); ?></h2>
                    <div class="categories-grid">
                        <?php foreach (array_slice($categories, 0, 4) as $cat): ?>
                            <a href="?page=catalog&category=<?php echo $cat['id']; ?>" class="category-card">
                                <div class="category-img">
                                    <img src="https://via.placeholder.com/400x300/e2e8f0/4a5568?text=<?php echo urlencode($cat['name'] ?? $cat['название'] ?? ''); ?>" 
                                         alt="<?php echo htmlspecialchars($cat['name'] ?? $cat['название'] ?? ''); ?>">
                                </div>
                                <div class="category-info">
                                    <h3><?php echo htmlspecialchars($cat['name'] ?? $cat['название'] ?? ''); ?></h3>
                                </div>
                            </a>
                        <?php endforeach; ?>
                    </div>
                </div>
            <?php endif; ?>
            
        <?php endif; ?>
    </main>
    
    <!-- Футер -->
    <footer class="footer">
        <div class="container">
            <p>© 2025 avtoZ. Все права защищены.</p>
        </div>
    </footer>
    
    <!-- Модальное окно: Переводчик -->
    <div id="translatorModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>🌐 <?php echo t('translate'); ?></h3>
                <span class="close" onclick="closeModal('translatorModal')">&times;</span>
            </div>
            <div class="modal-body">
                <div class="translate-row">
                    <select id="translateFrom" class="form-select">
                        <option value="en">English</option>
                        <option value="ru">Русский</option>
                        <option value="auto">Auto</option>
                    </select>
                    <span>→</span>
                    <select id="translateTo" class="form-select">
                        <option value="ru">Русский</option>
                        <option value="en">English</option>
                    </select>
                </div>
                <textarea id="translateInput" class="form-textarea" placeholder="<?php echo t('translate_text'); ?>..." rows="4"></textarea>
                <button class="btn btn-primary" onclick="doTranslate()"><?php echo t('translate_btn'); ?></button>
                <div id="translateResult" class="translate-result" style="display:none;">
                    <h4><?php echo t('result'); ?>:</h4>
                    <p id="translatedText"></p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Модальное окно: Настройки -->
    <div id="settingsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>⚙️ <?php echo t('settings'); ?></h3>
                <span class="close" onclick="closeModal('settingsModal')">&times;</span>
            </div>
            <div class="modal-body">
                <form method="POST">
                    <div class="setting-group">
                        <label><?php echo t('language'); ?></label>
                        <select name="lang" class="form-select">
                            <option value="ru" <?php echo $lang == 'ru' ? 'selected' : ''; ?>>🇷🇺 <?php echo t('russian'); ?></option>
                            <option value="en" <?php echo $lang == 'en' ? 'selected' : ''; ?>>🇬🇧 <?php echo t('english'); ?></option>
                        </select>
                    </div>
                    <div class="setting-group">
                        <label><?php echo t('theme'); ?></label>
                        <div class="theme-options">
                            <label class="theme-option <?php echo $theme == 'light' ? 'active' : ''; ?>">
                                <input type="radio" name="theme" value="light" <?php echo $theme == 'light' ? 'checked' : ''; ?>>
                                <span class="theme-preview light-preview"></span>
                                ☀️ <?php echo t('light'); ?>
                            </label>
                            <label class="theme-option <?php echo $theme == 'dark' ? 'active' : ''; ?>">
                                <input type="radio" name="theme" value="dark" <?php echo $theme == 'dark' ? 'checked' : ''; ?>>
                                <span class="theme-preview dark-preview"></span>
                                🌙 <?php echo t('dark'); ?>
                            </label>
                        </div>
                    </div>
                    <div class="settings-actions">
                        <button type="submit" name="save_settings" class="btn btn-primary">💾 <?php echo t('save'); ?></button>
                        <button type="button" class="btn btn-secondary" onclick="closeModal('settingsModal')"><?php echo t('cancel'); ?></button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        function openModal(id) { document.getElementById(id).style.display = 'block'; }
        function closeModal(id) { document.getElementById(id).style.display = 'none'; }
        window.onclick = function(e) { if (e.target.className === 'modal') e.target.style.display = 'none'; }
        
        async function doTranslate() {
            const text = document.getElementById('translateInput').value;
            const from = document.getElementById('translateFrom').value;
            const to = document.getElementById('translateTo').value;
            if (!text.trim()) return;
            
            const formData = new FormData();
            formData.append('ajax_translate', '1');
            formData.append('text', text);
            formData.append('from', from);
            formData.append('to', to);
            
            try {
                const resp = await fetch('index.php', { method: 'POST', body: formData });
                const data = await resp.json();
                document.getElementById('translatedText').textContent = data.translated;
                document.getElementById('translateResult').style.display = 'block';
            } catch(e) {}
        }
    </script>
        <!-- ФУТЕР -->
    <footer class="footer">
        <div class="container">
            <div class="footer-grid">
                <!-- Колонка 1: Контакты -->
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
                
                <!-- Колонка 2: Адрес и рейтинг -->
                <div class="footer-col">
                    <h4>Адрес</h4>
                    <p class="footer-address">
                        территория ГМ АЗС, с20/27,<br>
                        посёлок городского типа Инской,<br>
                        Кемеровская область — Кузбасс
                    </p>
                    
                    <div class="footer-rating">
                        <div class="rating-value">4,8</div>
                        <div class="rating-text">Рейтинг организации в Яндексе</div>
                    </div>
                </div>
                
                <!-- Колонка 3: Информация -->
                <div class="footer-col">
                    <h4>Информация</h4>
                    <ul class="footer-links">
                        <li><a href="#">Политикой обработки персональных данных</a></li>
                        <li><a href="#">Оферта</a></li>
                        <li><a href="#">Согласие на обработку персональных данных</a></li>
                    </ul>
                </div>
                
                <!-- Колонка 4: Каталог -->
                <div class="footer-col">
                    <h4>Каталог</h4>
                    <ul class="footer-links">
                        <?php if (!empty($categories)): ?>
                            <?php foreach (array_slice($categories, 0, 6) as $cat): ?>
                                <li>
                                    <a href="?category=<?php echo $cat['id']; ?>">
                                        <?php echo htmlspecialchars($cat['name'] ?? $cat['название'] ?? 'Категория'); ?>
                                    </a>
                                </li>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <li><a href="?catalog=1">Двигатель</a></li>
                            <li><a href="?catalog=1">Трансмиссия</a></li>
                            <li><a href="?catalog=1">Тормозная система</a></li>
                            <li><a href="?catalog=1">Подвеска</a></li>
                            <li><a href="?catalog=1">Электрика</a></li>
                            <li><a href="?catalog=1">Фильтры</a></li>
                        <?php endif; ?>
                    </ul>
                </div>
            </div>
            
            <!-- Нижняя строка -->
            <div class="footer-bottom">
                <p>© 2026 Интернет-магазин автозапчастей — avtoZ</p>
            </div>
        </div>
    </footer>
</body>
</html>