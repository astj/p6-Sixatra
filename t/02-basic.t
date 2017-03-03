use v6;
use Test;

use Crust::Test;
use HTTP::Request;

use Sixatra;

my module Testatra {
    use Sixatra;

    router ['GET'], '/list', -> $c {
        200, [], ['list'];
    };

    router ['GET'], '/array', -> $c {
        [200, [], ['array']];
    };
}

my $test = Crust::Test.create(sixatra-app());

{
    my $req = HTTP::Request.new(GET => "/list");
    my $res = $test.request($req);
    is $res.content.decode, "list";
}

{
    my $req = HTTP::Request.new(GET => "/array");
    my $res = $test.request($req);
    is $res.content.decode, "array";
}

done-testing;
