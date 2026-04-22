<?php

header('Content-Type: application/json');

require_once __DIR__ . '/../../Scripts/csrf.php';

session_start();
echo json_encode(['csrf_token' => csrf_generate()]);
