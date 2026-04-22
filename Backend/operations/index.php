<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
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
    $period = $_GET['period'] ?? 'all';
    $type   = $_GET['type']   ?? '';
    $catId  = isset($_GET['category_id']) ? (int)$_GET['category_id'] : 0;
    $sort   = in_array($_GET['sort'] ?? '', ['asc', 'desc']) ? $_GET['sort'] : 'desc';

    $where  = ['o.UserID = ?'];
    $params = [$userId];
    $types  = 'i';

    if ($period === 'today') {
        $where[] = 'DATE(o.OperationDate) = CURDATE()';
    } elseif ($period === 'week') {
        $where[] = 'o.OperationDate >= DATE_SUB(NOW(), INTERVAL 7 DAY)';
    } elseif ($period === 'month') {
        $where[] = 'MONTH(o.OperationDate) = MONTH(NOW()) AND YEAR(o.OperationDate) = YEAR(NOW())';
    }

    if ($type === 'income' || $type === 'expense') {
        $where[] = 'o.OperationType = ?';
        $params[] = $type;
        $types .= 's';
    }

    if ($catId > 0) {
        $where[] = 'o.CategoryID = ?';
        $params[] = $catId;
        $types .= 'i';
    }

    $sql = "SELECT o.OperationID, o.Sum, o.OperationType, o.OperationDate, o.Comment,
                   c.CategoryName, c.CategoryID
            FROM Operations o
            LEFT JOIN Categories c ON o.CategoryID = c.CategoryID
            WHERE " . implode(' AND ', $where) . "
            ORDER BY o.OperationDate $sort, o.OperationID $sort";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param($types, ...$params);
    $stmt->execute();
    $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    $stmt->close();
    $conn->close();
    echo json_encode(['success' => true, 'data' => $rows]);
    exit;
}

if ($method === 'POST') {
    $raw    = json_decode(file_get_contents('php://input'), true) ?? $_POST;
    $catId  = (int)($raw['category_id'] ?? 0);
    $sum    = (float)($raw['sum']       ?? 0);
    $opType = sanitize_string($raw['type']    ?? '');
    $opDate = sanitize_string($raw['date']    ?? date('Y-m-d H:i:s'));
    $comment= sanitize_string($raw['comment'] ?? '');

    if ($sum <= 0 || !in_array($opType, ['income', 'expense'])) {
        echo json_encode(['success' => false, 'error' => 'Неверные данные']);
        exit;
    }

    if ($catId === 0) {
        $stmt = $conn->prepare(
            'SELECT CategoryID FROM Categories WHERE CategoryName = ? AND IsDefault = 1 LIMIT 1'
        );
        $misc = 'Прочее';
        $stmt->bind_param('s', $misc);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();
        $catId = $row ? (int)$row['CategoryID'] : null;

        if (!$catId) {
            echo json_encode(['success' => false, 'error' => 'Категория не найдена']);
            exit;
        }
    }

    $stmt = $conn->prepare(
        'INSERT INTO Operations (UserID, CategoryID, Sum, OperationType, OperationDate, Comment)
         VALUES (?, ?, ?, ?, ?, ?)'
    );
    $stmt->bind_param('iidsss', $userId, $catId, $sum, $opType, $opDate, $comment);
    if ($stmt->execute()) {
        $newId = $conn->insert_id;
        $stmt->close();
        $conn->close();
        echo json_encode(['success' => true, 'id' => $newId]);
    } else {
        $err = $conn->error;
        $stmt->close();
        $conn->close();
        echo json_encode(['success' => false, 'error' => $err]);
    }
    exit;
}

if ($method === 'PUT') {
    $raw     = json_decode(file_get_contents('php://input'), true) ?? [];
    $opId    = (int)($raw['operation_id'] ?? 0);
    $catId   = (int)($raw['category_id']  ?? 0);
    $sum     = (float)($raw['sum']        ?? 0);
    $opType  = sanitize_string($raw['type']    ?? '');
    $opDate  = sanitize_string($raw['date']    ?? '');
    $comment = sanitize_string($raw['comment'] ?? '');

    if ($opId === 0 || $sum <= 0 || !in_array($opType, ['income', 'expense'])) {
        echo json_encode(['success' => false, 'error' => 'Неверные данные']);
        exit;
    }

    $stmt = $conn->prepare(
        'UPDATE Operations SET CategoryID=?, Sum=?, OperationType=?, OperationDate=?, Comment=?
         WHERE OperationID=? AND UserID=?'
    );
    $stmt->bind_param('idsssis', $catId, $sum, $opType, $opDate, $comment, $opId, $userId);
    $ok = $stmt->execute();
    $stmt->close();
    $conn->close();
    echo json_encode(['success' => $ok]);
    exit;
}

if ($method === 'DELETE') {
    $raw  = json_decode(file_get_contents('php://input'), true) ?? [];
    $opId = (int)($raw['operation_id'] ?? 0);

    if ($opId === 0) {
        echo json_encode(['success' => false, 'error' => 'ID не указан']);
        exit;
    }

    $stmt = $conn->prepare('DELETE FROM Operations WHERE OperationID=? AND UserID=?');
    $stmt->bind_param('ii', $opId, $userId);
    $ok = $stmt->execute();
    $stmt->close();
    $conn->close();
    echo json_encode(['success' => $ok]);
    exit;
}

http_response_code(405);
echo json_encode(['success' => false, 'error' => 'Метод не разрешён']);
