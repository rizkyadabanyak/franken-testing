<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});


Route::get('/phpinfo', function () {
    dd(phpinfo());
});

Route::get('/testing', function () {
//    dd(phpinfo());
    $user = \App\Models\User::all();


    foreach ($user as $u) {

        $angka = 2+9;

        $u->angka = $angka;
    }

    $sum = 0;
    for ($i = 0; $i < 100000000; $i++) {
        $sum += $i;
    }

    return response()->json($sum);
});


