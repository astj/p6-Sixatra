use v6;
use Test;

use Crust::Test;
use HTTP::Request;

use Sixatra;

my module Testatra {
    use Sixatra;

    router 'GET', '/', -> $c {
        200, [], ['getting'];
    };

    get '/another', -> $c {
        200, [], ['getting another'];
    };

    router 'PATCH', '/', -> $c {
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
    my $req = HTTP::Request.new(GET => "/nop");
    my $res = $test.request($req);
    is $res.code, 404;
}

{
    my $req = HTTP::Request.new(GET => "/another");
    my $res = $test.request($req);
    is $res.content.decode, "getting another";
}

{
    my $req = HTTP::Request.new(HEAD => "/another");
    my $res = $test.request($req);
    is $res.content.decode, "getting another";
}

{
    my $req = HTTP::Request.new(POST => "/another");
    my $res = $test.request($req);
    is $res.code, 405;
}

{
    my $req = HTTP::Request.new(PATCH => "/");
    my $res = $test.request($req);
    is $res.content.decode, "patched";
}

{
    my $req = HTTP::Request.new(HEAD => "/");
    my $res = $test.request($req);
    is $res.code, 405;
}

done-testing;
