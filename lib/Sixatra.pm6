use v6;
unit module Sixatra;

use Router::Boost;
use Crust::Request;
need Crust;

our $ROUTER = Router::Boost.new();

sub sixatra-app ( --> Callable) is export {
    return -> $env {
        my $req = Crust::Request.new($env);
        my $match = $ROUTER.match($req.path-info);
        with $match<stuff> {
            # TODO pass $match<captured>
            $match<stuff>.app.();
        } else {
            200, [], ['heyhey'];
        }
    };
}

my class RoutingStaff {
    has Array $.methods;
    has Callable $.app;
};

sub router(Array $methods, Str $path, Callable $app) is export {
    $ROUTER.add($path, RoutingStaff.new(:$methods, :$app));
}

=begin pod

=head1 NAME

Sixatra - Sinatra-like simple Web Application Framework

=head1 SYNOPSIS

  unit module MyApp;
  use Sixatra;

  get '/', -> {
      200, [], ['hello'];
  };

And run MyApp with crustup as follows:

  crustup -e 'use MyApp; use Sixatra; sixatra-app;'

=head1 DESCRIPTION

Sixatra is ...

=head1 AUTHOR

Asato Wakisaka <asato.wakisaka@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 Asato Wakisaka

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
