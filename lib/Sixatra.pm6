use v6;
unit module Sixatra;

use Router::Boost::Method;
use Sixatra::Request;
need Crust::Response;

our $ROUTER = Router::Boost::Method.new;

multi sixatra-app (Str $package --> Callable) is export {
    use MONKEY-SEE-NO-EVAL;
    EVAL "use $package;";
    sixatra-app;
}

multi sixatra-app ( --> Callable) is export {
    return sub ($env) {
        my $req = Sixatra::Request.new($env);

        my $match = $ROUTER.match($req.method, $req.path-info);
        return 405, [], ['Method Not Allowed'] if $match<is-method-not-allowed>;
        with $match<stuff> {
            $req.captured = $match<captured>;
            given $match<stuff>.app.($req) {
                when Crust::Response { return .finalize }
                default { return $_ }
            }
        }
        return 404, [], ['Not Found'];
    };
}

my class RoutingStaff {
    has Callable $.app;
};

multi router(Array $methods, Str $path, Callable $app) is export {
    $ROUTER.add(@$methods, $path, RoutingStaff.new(:$app));
}

multi router(Str $method, Str $path, Callable $app) is export {
    router([$method], $path, $app);
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
