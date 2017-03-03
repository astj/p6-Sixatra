[![Build Status](https://travis-ci.org/astj/p6-Sixatra.svg?branch=master)](https://travis-ci.org/astj/p6-Sixatra)

NAME
====

Sixatra - 🦋 Sinatra-like simple Web Application Framework 🐯

SYNOPSIS
========

    unit module MyApp;
    use Sixatra;

    get '/', -> $c {
        200, [], ['hello'];
    };

And run MyApp with crustup as follows:

    crustup -e 'use Sixatra; sixatra-app("MyApp");'

DESCRIPTION
===========

Sixatra is ...

AUTHOR
======

Asato Wakisaka <asato.wakisaka@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2017 Asato Wakisaka

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.
