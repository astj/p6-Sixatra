use v6;
unit module Sixatra;

use Crust::Response;
use Router::Boost::Method;

use Sixatra::Request;
use Sixatra::Connection;

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
            my $c = Sixatra::Connection.new(:$req, :params($match<captured>));
            my $res = $match<stuff>.app.($c);
            # If response is not Crust::Response, convert.
            if $res !~~ Crust::Response {
                given $res {
                    when Array { return $res; } # Seems raw PSGI Response
                    when Int { $res = Crust::Response.new(:status($res), :headers([]), :body([])); }
                    when Str { $res = Crust::Response.new(:status(200), :headers([]), :body([$res])); }
                    default { return 500, [], ['Unexpected response!']; }
                }
            }
            return $res.finalize;
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

  get '/', -> $c {
      200, [], ['hello'];
  };

And run MyApp with crustup as follows:

  crustup -e 'use Sixatra; sixatra-app("MyApp");'

=head1 DESCRIPTION

Sixatra is ...

=head1 AUTHOR

Asato Wakisaka <asato.wakisaka@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 Asato Wakisaka

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
