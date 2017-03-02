use v6;
use Test;

use Sixatra::Connection;

{
    my $c = Sixatra::Connection.new;
    my $res = $c.render('t/data/render.tm', {a => 'foo', c => 'bar'});
    is $res.status, 200;
    is $res.headers, [:Content-Type<text/html; charset=UTF-8>];
    is $res.body, [q:to/END/];
    foo

    bar
    END
}

{
    my $c = Sixatra::Connection.new;
    my $res = $c.render-json({ a => [1, 2], b => "c" });
    is $res.status, 200;
    is $res.headers, [:Content-Type<application/json>];
    is $res.body, [q/{ "a" : [ 1, 2 ], "b" : "c" }/];
}

done-testing;
