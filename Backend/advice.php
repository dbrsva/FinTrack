<?php
header('Content-Type: application/json');
require_once __DIR__ . '/db.php';

$stmt = $conn->prepare('SELECT TipID, Title, TipText FROM Tips ORDER BY TipID ASC');
$stmt->execute();
$result = $stmt->get_result();
$tips = $result->fetch_all(MYSQLI_ASSOC);
$stmt->close();
$conn->close();

echo json_encode($tips);
