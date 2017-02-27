use v6;
unit module Sixatra;

use Router::Boost;
use Crust::Request;

our $ROUTERS = {};

sub sixatra-app ( --> Callable) is export {
    return sub ($env) {
        my $req = Crust::Request.new($env);
        my $router = $ROUTERS{$req.method()};

        with $router {
            my $match = $router.match($req.path-info);
            with $match<stuff> {
                # TODO pass $match<captured>
                return $match<stuff>.app.();
            }
        }
        # TODO we should return 405?
        return 404, [], ['Not Found'];
    };
}

my class RoutingStaff {
    has Array $.methods;
    has Callable $.app;
};

sub router(Array $methods, Str $path, Callable $app) is export {
    for $methods -> $method {
        $ROUTERS{$method} //= Router::Boost.new;
        $ROUTERS{$method}.add($path, RoutingStaff.new(:$methods, :$app));
    }
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
