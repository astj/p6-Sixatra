use v6;
use Test;

use Crust::Test;
use HTTP::Request;

use Sixatra;

my module Testatra {
    use Sixatra;

    router ['GET'], '/', sub {
        200, [], ['getting'];
    };

    router ['PATCH'], '/', sub {
        200, [], ['patched'];
    };
}

my $test = Crust::Test.create(sixatra-app());

{
    my $req = HTTP::Request.new(GET => "/");
    my $res = $test.request($req);
    is $res.content.decode, "getting";
}

{
    my $req = HTTP::Request.new(PATCH => "/");
    my $res = $test.request($req);
    is $res.content.decode, "patched";
}

{
    my $req = HTTP::Request.new(HEAD => "/");
    my $res = $test.request($req);
    is $res.code, 404;
}

done-testing;
