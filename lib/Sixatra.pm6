use v6;
unit module Sixatra;

use Router::Boost;
use Sixatra::Request;

our $ROUTERS = {};

multi sixatra-app (Str $package --> Callable) is export {
    use MONKEY-SEE-NO-EVAL;
    EVAL "use $package;";
    sixatra-app;
}

multi sixatra-app ( --> Callable) is export {
    return sub ($env) {
        my $req = Sixatra::Request.new($env);
        my $router = $ROUTERS{$req.method()};

        with $router {
            my $match = $router.match($req.path-info);
            with $match<stuff> {
                $req.captured = $match<captured>;
                return $match<stuff>.app.($req);
            }
        }
        # TODO we should return 405?
        return 404, [], ['Not Found'];
    };
}

my class RoutingStaff {
    has Callable $.app;
};

multi router(Array $methods, Str $path, Callable $app) is export {
    for @$methods -> $method {
        router($method, $path, $app);
    }
}

multi router(Str $method, Str $path, Callable $app) is export {
    $ROUTERS{$method} //= Router::Boost.new;
    $ROUTERS{$method}.add($path, RoutingStaff.new(:$app));
}

sub get(Str $path, Callable $app) is export {
    router ["GET", "HEAD"], $path, $app;
}

sub post(Str $path, Callable $app) is export {
    router "POST", $path, $app;
}

=begin pod

=head1 NAME

Sixatra - Sinatra-like simple Web Application Framework

=head1 SYNOPSIS

  unit module MyApp;
  use Sixatra;

  get '/', -> $req {
      200, [], ['hello'];
  };

And run MyApp with crustup as follows:

  crustup -e 'use Sixatra; sixatra-app(MyApp);'

=head1 DESCRIPTION

Sixatra is ...

=head1 AUTHOR

Asato Wakisaka <asato.wakisaka@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 Asato Wakisaka

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
