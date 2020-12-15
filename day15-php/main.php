<?php

ini_set('memory_limit', '256M');

$data = [0, 14, 1, 3, 7, 9];

$visited = [];
for ($i = 1; $i < sizeof($data); $i++) {
    $visited[$data[$i - 1]] = $i;
}
$last = $data[sizeof($data) - 1];

for ($i = sizeof($visited) + 1; $i <= 30000000; $i++) {
    if ($i == 2020 || $i == 30000000) {
        echo "$i = $last\n";
    }

    $prev = $visited[$last];
    $visited[$last] = $i;
    $new_val = 0;
    if ($prev != null) {
        $new_val = $i - $prev;
    }

    $last = $new_val;
}
