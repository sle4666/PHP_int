<?php
$db_connected = false;
$tables = [];
$db_error = '';
$current_user = '';

// Пробуем разные способы подключения
$connections = [
    ['host' => 'localhost', 'user' => 'root', 'pass' => ''],
    ['host' => '127.0.0.1', 'user' => 'root', 'pass' => ''],
    ['host' => 'localhost', 'user' => 'admin', 'pass' => 'admin'],
    ['host' => 'localhost', 'user' => 'student', 'pass' => ''],
    ['host' => 'localhost', 'user' => 'student', 'pass' => 'student'],
];

foreach ($connections as $conn) {
    try {
        $pdo = new PDO(
            "mysql:host={$conn['host']};dbname=SOS;charset=utf8mb4",
            $conn['user'],
            $conn['pass'],
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
        );
        $db_connected = true;
        $current_user = $conn['user'];
        
        // Получаем список таблиц
        $stmt = $pdo->query("SHOW TABLES");
        $tables = $stmt->fetchAll(PDO::FETCH_COLUMN);
        break;
    } catch (PDOException $e) {
        continue;
    }
}

if (!$db_connected) {
    $db_error = 'Не удалось подключиться к базе данных SOS';
}

function getTableData($pdo, $table) {
    $data = [
        'columns' => [],
        'rows' => [],
        'count' => 0,
        'error' => ''
    ];
    
    try {
        // Колонки
        $stmt = $pdo->query("SHOW COLUMNS FROM `$table`");
        $data['columns'] = $stmt->fetchAll(PDO::FETCH_COLUMN);
        
        // Количество
        $stmt = $pdo->query("SELECT COUNT(*) FROM `$table`");
        $data['count'] = $stmt->fetchColumn();
        
        // Данные
        $stmt = $pdo->query("SELECT * FROM `$table` LIMIT 100");
        $data['rows'] = $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (PDOException $e) {
        $data['error'] = $e->getMessage();
    }
    
    return $data;
}

function getTableStats($pdo, $tables) {
    $stats = [];
    foreach ($tables as $table) {
        try {
            $stmt = $pdo->query("SELECT COUNT(*) FROM `$table`");
            $stats[$table] = $stmt->fetchColumn();
        } catch (Exception $e) {
            $stats[$table] = '?';
        }
    }
    return $stats;
}
?>