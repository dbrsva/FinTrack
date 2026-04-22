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

$stmt = $conn->prepare('SELECT UserID, Email, PasswordHash FROM Users WHERE Email = ?');
$stmt->bind_param('s', $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(['success' => false, 'error' => 'Неверный email или пароль']);
    $stmt->close();
    $conn->close();
    exit;
}

$user = $result->fetch_assoc();
$stmt->close();

if (!password_verify($password, $user['PasswordHash'])) {
    echo json_encode(['success' => false, 'error' => 'Неверный email или пароль']);
    $conn->close();
    exit;
}

$_SESSION['user_id'] = $user['UserID'];
$_SESSION['email']   = $user['Email'];

echo json_encode([
    'success' => true,
    'message' => 'Вы успешно вошли!',
    'user_id' => $user['UserID'],
    'email'   => $user['Email']
]);

$conn->close();
