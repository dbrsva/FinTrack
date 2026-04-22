<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(204); exit; }

session_start();

if (empty($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Не авторизован']);
    exit;
}

require_once __DIR__ . '/../db.php';
require_once __DIR__ . '/../../Scripts/sanitize.php';

$userId = (int)$_SESSION['user_id'];
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $stmt = $conn->prepare(
        'SELECT CategoryID, CategoryName, IsDefault FROM Categories
         WHERE IsDefault = 1 OR UserID = ?
         ORDER BY IsDefault DESC, CategoryName ASC'
    );
    $stmt->bind_param('i', $userId);
    $stmt->execute();
    $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    $stmt->close();
    $conn->close();
    echo json_encode(['success' => true, 'data' => $rows]);
    exit;
}

if ($method === 'POST') {
    $raw  = json_decode(file_get_contents('php://input'), true) ?? $_POST;
    $name = sanitize_string($raw['name'] ?? '');

    if (empty($name)) {
        echo json_encode(['success' => false, 'error' => 'Укажите название']);
        exit;
    }

    $stmt = $conn->prepare('INSERT INTO Categories (UserID, CategoryName, IsDefault) VALUES (?, ?, 0)');
    $stmt->bind_param('is', $userId, $name);
    if ($stmt->execute()) {
        $id = $conn->insert_id;
        $stmt->close();
        $conn->close();
        echo json_encode(['success' => true, 'id' => $id, 'name' => $name]);
    } else {
        $err = $conn->error;
        $stmt->close();
        $conn->close();
        echo json_encode(['success' => false, 'error' => $err]);
    }
    exit;
}

if ($method === 'DELETE') {
    $raw   = json_decode(file_get_contents('php://input'), true) ?? [];
    $catId = (int)($raw['category_id'] ?? 0);

    if ($catId === 0) {
        echo json_encode(['success' => false, 'error' => 'ID не указан']);
        exit;
    }

    $stmt = $conn->prepare('DELETE FROM Categories WHERE CategoryID = ? AND UserID = ? AND IsDefault = 0');
    $stmt->bind_param('ii', $catId, $userId);
    $ok = $stmt->execute();
    $affected = $stmt->affected_rows;
    $stmt->close();
    $conn->close();

    if (!$ok) {
        echo json_encode(['success' => false, 'error' => 'Ошибка удаления']);
        exit;
    }
    if ($affected === 0) {
        echo json_encode(['success' => false, 'error' => 'Нельзя удалить стандартную или чужую категорию']);
        exit;
    }
    echo json_encode(['success' => true]);
    exit;
}

http_response_code(405);
echo json_encode(['success' => false, 'error' => 'Метод не разрешён']);
