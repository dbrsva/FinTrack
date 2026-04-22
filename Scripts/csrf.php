<?php

define('CSRF_TTL', 60);

function csrf_generate(): string {
    if (session_status() === PHP_SESSION_NONE) session_start();
    $token = bin2hex(random_bytes(32));
    $_SESSION['csrf_token']    = $token;
    $_SESSION['csrf_token_ts'] = time();
    return $token;
}

function csrf_validate(string $token): bool {
    if (session_status() === PHP_SESSION_NONE) session_start();
    if (empty($_SESSION['csrf_token']) || empty($_SESSION['csrf_token_ts'])) return false;
    if ((time() - $_SESSION['csrf_token_ts']) > CSRF_TTL) {
        unset($_SESSION['csrf_token'], $_SESSION['csrf_token_ts']);
        return false;
    }
    return hash_equals($_SESSION['csrf_token'], $token);
}
