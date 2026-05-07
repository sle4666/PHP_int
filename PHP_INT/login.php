<?php
session_start();
if (isset($_SESSION['logged_in']) && $_SESSION['logged_in'] === true) {
    header('Location: index.php');
    exit;
}

$error = '';
if (isset($_POST['login'])) {
    if (($_POST['username'] ?? '') === 'admin' && ($_POST['password'] ?? '') === 'admin') {
        $_SESSION['logged_in'] = true;
        $_SESSION['username'] = 'admin';
        header('Location: index.php');
        exit;
    }
    $error = 'Неверный логин или пароль';
}
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ремонт-Хаб | Вход</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #1a202c; min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .login-box { background: #fff; padding: 50px 40px; border-radius: 15px; width: 400px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); text-align: center; }
        .logo { font-size: 32px; font-weight: 800; margin-bottom: 10px; color: #1a202c; }
        .logo span { color: #f97316; }
        h2 { margin-bottom: 30px; color: #718096; font-size: 16px; }
        .form-group { margin-bottom: 20px; text-align: left; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 600; }
        .form-group input { width: 100%; padding: 14px; border: 2px solid #e2e8f0; border-radius: 8px; font-size: 16px; outline: none; }
        .form-group input:focus { border-color: #f97316; }
        .btn { width: 100%; padding: 16px; background: #f97316; color: #fff; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; margin-top: 10px; }
        .btn:hover { background: #ea580c; }
        .error { color: #e53e3e; margin-bottom: 15px; }
    </style>
</head>
<body>
    <div class="login-box">
        <div class="logo">Ремонт<span>Хаб</span></div>
        <h2>Система управления заказами</h2>
        <?php if ($error): ?><div class="error"><?php echo $error; ?></div><?php endif; ?>
        <form method="POST" autocomplete="off">
            <div class="form-group"><label>Логин</label><input type="text" name="username" placeholder="Введите логин" required></div>
            <div class="form-group"><label>Пароль</label><input type="password" name="password" placeholder="Введите пароль" required></div>
            <button type="submit" name="login" class="btn">Войти в систему</button>
        </form>
    </div>
</body>
</html>