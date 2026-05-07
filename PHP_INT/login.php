<?php
session_start();
require_once 'db.php';

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
    <title>avtoZ - Вход</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', system-ui, sans-serif;
            background: #1a202c;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-box {
            background: white;
            padding: 50px 40px;
            border-radius: 10px;
            width: 400px;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        .login-box .logo {
            font-size: 36px;
            font-weight: 800;
            margin-bottom: 10px;
            color: #1a202c;
        }
        .login-box .logo span { color: #e53e3e; }
        .login-box h2 { margin-bottom: 30px; color: #4a5568; font-size: 18px; }
        .form-group { margin-bottom: 20px; text-align: left; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 600; color: #4a5568; }
        .form-group input {
            width: 100%;
            padding: 14px;
            border: 2px solid #e2e8f0;
            border-radius: 5px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.2s;
        }
        .form-group input:focus { border-color: #e53e3e; }
        .btn-login {
            width: 100%;
            padding: 16px;
            background: #e53e3e;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
            transition: background 0.2s;
        }
        .btn-login:hover { background: #c53030; }
        .error { color: #e53e3e; margin-bottom: 15px; }
    </style>
</head>
<body>
    <div class="login-box">
        <div class="logo">avto<span>Z</span></div>
        <h2>Вход в систему</h2>
        
        <?php if ($error): ?>
            <div class="error"><?php echo $error; ?></div>
        <?php endif; ?>
        
        <form method="POST" autocomplete="off">
            <div class="form-group">
                <label>Логин</label>
                <input type="text" name="username" placeholder="Введите логин" required autocomplete="off">
            </div>
            <div class="form-group">
                <label>Пароль</label>
                <input type="password" name="password" placeholder="Введите пароль" required autocomplete="off">
            </div>
            <button type="submit" name="login" class="btn-login">Войти</button>
        </form>
    </div>
</body>
</html>