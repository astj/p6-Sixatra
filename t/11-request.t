use v6;
use Test;
use Hash::MultiValue;

use Sixatra::Request;

{
    my $req = Sixatra::Request.new({
        :REMOTE_ADDR<127.0.0.1>,
        :QUERY_STRING<foo=bar&foo=baz>,
        'p6sgi.input' => open('t/dat/query.txt'),
        :HTTP_USER_AGENT<hoge>,
        :CONTENT_TYPE<application/x-www-form-urlencoded>
    });
    is $req.body-parameters.('key'), 'val';
}

{
    my $req = Sixatra::Request.new({
        :REMOTE_ADDR<127.0.0.1>,
        :QUERY_STRING<foo=bar&foo=baz>,
        'p6sgi.input' => open('t/dat/json.txt'),
        :HTTP_USER_AGENT<hoge>,
        :CONTENT_TYPE<application/json>
    });
    is $req.body-parameters.('jsonkey').join(', '), 'val1, val2'
}

{
    my $req = Sixatra::Request.new({
        :REMOTE_ADDR<127.0.0.1>,
        :QUERY_STRING<foo=bar&foo=baz>,
        'p6sgi.input' => open('t/dat/invalid-json.txt'),
        :HTTP_USER_AGENT<hoge>,
        :CONTENT_TYPE<application/json>
    });
    is $req.body-parameters.keys, [];
}

done-testing;
