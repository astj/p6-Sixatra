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

done-testing;
