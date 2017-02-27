use v6;
use Test;

use Crust::Test;
use HTTP::Request;

use Sixatra;

my module Testatra {
    use Sixatra;

    router ['GET'], '/users/:id', -> $req {
        200, [], ['your id is ' ~ $req.captured<id>];
    };
}

test-psgi sixatra-app(), -> $cb {
    my $req = HTTP::Request.new(GET => "/users/tom");
    my $res = $cb($req);
    is $res.content.decode, "your id is tom";
};

done-testing;
