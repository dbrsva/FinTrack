<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(204); exit; }

session_start();

if (empty($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'Не авторизован']);
    exit;
}

require_once __DIR__ . '/../db.php';

$userId = (int)$_SESSION['user_id'];
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $period = $_GET['period'] ?? 'month'; 

    $stmt = $conn->prepare(
        'SELECT * FROM Budget WHERE UserID = ? AND PeriodType = ? ORDER BY CreatedAt DESC LIMIT 1'
    );
    $stmt->bind_param('is', $userId, $period);
    $stmt->execute();
    $budget = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    if (!$budget) {
        echo json_encode(['success' => true, 'budget' => null, 'spent' => 0, 'remaining' => 0, 'percent' => 0]);
        $conn->close(); exit;
    }

    if ($period === 'month') {
        $dateFilter = 'MONTH(OperationDate) = MONTH(NOW()) AND YEAR(OperationDate) = YEAR(NOW())';
    } elseif ($period === 'week') {
        $dateFilter = 'OperationDate >= DATE_SUB(NOW(), INTERVAL 7 DAY)';
    } else {
        $dateFilter = 'DATE(OperationDate) = CURDATE()';
    }

    $stmt = $conn->prepare(
        "SELECT COALESCE(SUM(Sum), 0) AS spent FROM Operations
         WHERE UserID = ? AND OperationType = 'expense' AND $dateFilter"
    );
    $stmt->bind_param('i', $userId);
    $stmt->execute();
    $spent = (float)$stmt->get_result()->fetch_assoc()['spent'];
    $stmt->close();
    $conn->close();

    $limit    = (float)$budget['SumLimit'];
    $remaining = max(0, $limit - $spent);
    $percent   = $limit > 0 ? round(min(100, ($spent / $limit) * 100), 1) : 0;

    echo json_encode([
        'success'   => true,
        'budget'    => $budget,
        'spent'     => $spent,
        'remaining' => $remaining,
        'percent'   => $percent,
    ]);
    exit;
}

if ($method === 'POST') {
    $raw    = json_decode(file_get_contents('php://input'), true) ?? $_POST;
    $limit  = (float)($raw['limit'] ?? 0);
    $period = $raw['period'] ?? 'month';

    if (!in_array($period, ['month', 'week', 'day'])) {
        echo json_encode(['success' => false, 'error' => 'Неверный период']); exit;
    }
    if ($limit <= 0) {
        echo json_encode(['success' => false, 'error' => 'Лимит должен быть > 0']); exit;
    }

    $stmt = $conn->prepare(
        'SELECT BudgetID FROM Budget WHERE UserID = ? AND PeriodType = ? LIMIT 1'
    );
    $stmt->bind_param('is', $userId, $period);
    $stmt->execute();
    $existing = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    if ($existing) {
        $stmt = $conn->prepare('UPDATE Budget SET SumLimit = ? WHERE BudgetID = ?');
        $stmt->bind_param('di', $limit, $existing['BudgetID']);
    } else {
        $stmt = $conn->prepare('INSERT INTO Budget (UserID, SumLimit, PeriodType) VALUES (?, ?, ?)');
        $stmt->bind_param('ids', $userId, $limit, $period);
    }

    $ok = $stmt->execute();
    $stmt->close(); $conn->close();
    echo json_encode(['success' => $ok]);
    exit;
}

http_response_code(405);
echo json_encode(['success' => false, 'error' => 'Метод не разрешён']);
