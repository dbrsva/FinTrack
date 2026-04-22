<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
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

$sql = "SELECT
  COALESCE(SUM(CASE WHEN OperationType='income'  AND DATE(OperationDate)=CURDATE() THEN Sum ELSE 0 END), 0) AS income_today,
  COALESCE(SUM(CASE WHEN OperationType='expense' AND DATE(OperationDate)=CURDATE() THEN Sum ELSE 0 END), 0) AS expense_today,
  COALESCE(SUM(CASE WHEN OperationType='income'  AND MONTH(OperationDate)=MONTH(NOW()) AND YEAR(OperationDate)=YEAR(NOW()) THEN Sum ELSE 0 END), 0) AS income_month,
  COALESCE(SUM(CASE WHEN OperationType='expense' AND MONTH(OperationDate)=MONTH(NOW()) AND YEAR(OperationDate)=YEAR(NOW()) THEN Sum ELSE 0 END), 0) AS expense_month,
  COALESCE(SUM(CASE WHEN OperationType='income'  THEN Sum ELSE 0 END), 0) AS income_total,
  COALESCE(SUM(CASE WHEN OperationType='expense' THEN Sum ELSE 0 END), 0) AS expense_total
FROM Operations WHERE UserID = ?";

$stmt = $conn->prepare($sql);
$stmt->bind_param('i', $userId);
$stmt->execute();
$summary = $stmt->get_result()->fetch_assoc();
$stmt->close();

$stmt = $conn->prepare(
    "SELECT c.CategoryName, COALESCE(SUM(o.Sum),0) AS total
     FROM Operations o
     LEFT JOIN Categories c ON o.CategoryID = c.CategoryID
     WHERE o.UserID = ? AND o.OperationType = 'expense'
       AND MONTH(o.OperationDate)=MONTH(NOW()) AND YEAR(o.OperationDate)=YEAR(NOW())
     GROUP BY c.CategoryID ORDER BY total DESC LIMIT 6"
);
$stmt->bind_param('i', $userId);
$stmt->execute();
$byCategory = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
$stmt->close();

$stmt = $conn->prepare(
    "SELECT o.OperationID, o.Sum, o.OperationType, o.OperationDate, o.Comment, c.CategoryName
     FROM Operations o
     LEFT JOIN Categories c ON o.CategoryID = c.CategoryID
     WHERE o.UserID = ? AND DATE(o.OperationDate) = CURDATE()
     ORDER BY o.OperationDate DESC, o.OperationID DESC LIMIT 5"
);
$stmt->bind_param('i', $userId);
$stmt->execute();
$todayOps = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
$stmt->close();
$conn->close();

$balance = (float)$summary['income_total'] - (float)$summary['expense_total'];
$savings = (float)$summary['income_month']  - (float)$summary['expense_month'];

echo json_encode([
    'success'     => true,
    'income_today'   => (float)$summary['income_today'],
    'expense_today'  => (float)$summary['expense_today'],
    'income_month'   => (float)$summary['income_month'],
    'expense_month'  => (float)$summary['expense_month'],
    'income_total'   => (float)$summary['income_total'],
    'expense_total'  => (float)$summary['expense_total'],
    'balance'        => $balance,
    'savings_month'  => $savings,
    'by_category'    => $byCategory,
    'today_ops'      => $todayOps,
]);
