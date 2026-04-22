<?php

function sanitize_string(string $str): string {
    return htmlspecialchars(strip_tags(trim($str)), ENT_QUOTES | ENT_HTML5, 'UTF-8');
}
