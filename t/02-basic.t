use v6;
use Test;

use Crust::Test;
use HTTP::Request;

use Sixatra;

my module Testatra {
    use Sixatra;

    router ['GET'], '/', -> $req {
        200, [], ['getting'];
    };
}

test-psgi sixatra-app(), -> $cb {
    my $req = HTTP::Request.new(GET => "/");
    my $res = $cb($req);
    is $res.content.decode, "getting";
};

done-testing;
