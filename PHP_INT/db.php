<?php
$db_connected = false;
$tables = [];
$db_error = '';
$current_user = '';

$connections = [
    ['host' => 'localhost', 'user' => 'root', 'pass' => ''],
    ['host' => '127.0.0.1', 'user' => 'root', 'pass' => ''],
    ['host' => 'localhost', 'user' => 'student', 'pass' => ''],
    ['host' => 'localhost', 'user' => 'student', 'pass' => 'student'],
];

foreach ($connections as $conn) {
    try {
        $pdo = new PDO(
            "mysql:host={$conn['host']};dbname=remont_stroy;charset=utf8mb4",
            $conn['user'],
            $conn['pass'],
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
        );
        $db_connected = true;
        $current_user = $conn['user'];
        $stmt = $pdo->query("SHOW TABLES");
        $tables = $stmt->fetchAll(PDO::FETCH_COLUMN);
        break;
    } catch (PDOException $e) {
        continue;
    }
}

if (!$db_connected) {
    $db_error = 'База данных remont_stroy недоступна';
}

function getTableData($pdo, $table) {
    $data = ['columns' => [], 'rows' => [], 'count' => 0];
    try {
        $stmt = $pdo->query("SHOW COLUMNS FROM `$table`");
        $data['columns'] = $stmt->fetchAll(PDO::FETCH_COLUMN);
        $stmt = $pdo->query("SELECT COUNT(*) FROM `$table`");
        $data['count'] = $stmt->fetchColumn();
        $stmt = $pdo->query("SELECT * FROM `$table` LIMIT 50");
        $data['rows'] = $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (PDOException $e) {}
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