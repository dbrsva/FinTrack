<?php

define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', 'root');
define('DB_NAME', 'FinTrack_BD');
define('DB_PORT', 8889); 

$conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME, DB_PORT);

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error'   => 'Ошибка подключения к базе данных: ' . $conn->connect_error
    ]);
    exit;
}

$conn->set_charset('utf8mb4');
