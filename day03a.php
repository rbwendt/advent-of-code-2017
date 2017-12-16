<?php

function splitup($x) {
    $a = explode("\n", $x);
    $b = array_map(function($y) {
        return preg_split("/\s+/", $y);
    }, $a);
    return $b;  
}

function linesums($x) {
    return array_map('linesum', $x);
}

function linesum($x) {
    $sum = 0;
    foreach($x as $i) {
        foreach ($x as $j) {
            if ($i != $j && ($j / $i) == floor($j / $i)) {
                $sum += $j / $i;
            }
        }
    }
    return $sum;
}

$x = file_get_contents('data/day3.txt');
$vals = splitup($x);
$sums = linesums($vals);
$sum = array_reduce($sums, function($a, $i) {return $a + $i;}, 0);

//265 is correct.
echo "$sum\n";
