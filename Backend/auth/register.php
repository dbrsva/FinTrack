<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

require_once __DIR__ . '/../../Scripts/csrf.php';
require_once __DIR__ . '/../../Scripts/sanitize.php';
require_once __DIR__ . '/../db.php';

session_start();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'error' => 'Метод не разрешён']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
if (!$data) {
    $data = $_POST;
}

$csrf = $data['csrf_token'] ?? '';
if (!csrf_validate($csrf)) {
    echo json_encode(['success' => false, 'error' => 'Недействительный или устаревший токен. Обновите страницу.']);
    exit;
}

$email    = sanitize_string($data['email'] ?? '');
$password = trim($data['password'] ?? '');

if (empty($email) || empty($password)) {
    echo json_encode(['success' => false, 'error' => 'Заполните все поля']);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(['success' => false, 'error' => 'Неверный формат email']);
    exit;
}

if (strlen($password) < 6) {
    echo json_encode(['success' => false, 'error' => 'Пароль должен быть не менее 6 символов']);
    exit;
}

$stmt = $conn->prepare('SELECT UserID FROM Users WHERE Email = ?');
$stmt->bind_param('s', $email);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    echo json_encode(['success' => false, 'error' => 'Пользователь с таким email уже существует']);
    $stmt->close();
    $conn->close();
    exit;
}
$stmt->close();

$passwordHash = password_hash($password, PASSWORD_BCRYPT);

$stmt = $conn->prepare('INSERT INTO Users (Email, PasswordHash, Currency, ThemeMode) VALUES (?, ?, ?, ?)');
$currency  = '₽';
$themeMode = 'light';
$stmt->bind_param('ssss', $email, $passwordHash, $currency, $themeMode);

if ($stmt->execute()) {
    $newUserId = $conn->insert_id;
    $stmt->close();

    $_SESSION['user_id'] = $newUserId;
    $_SESSION['email']   = $email;

    echo json_encode([
        'success' => true,
        'message' => 'Регистрация прошла успешно!',
        'user_id' => $newUserId
    ]);
} else {
    $stmt->close();
    echo json_encode(['success' => false, 'error' => 'Ошибка при создании аккаунта: ' . $conn->error]);
}

$conn->close();
