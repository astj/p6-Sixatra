use v6;
unit class Sixatra::Connection;

need Sixatra::Request;
use Template::Mojo;
use Hash::MultiValue;
use Crust::Response;
use JSON::Tiny;

has Sixatra::Request $.req;
has Hash $.params;

method render(Str $filename, *@args --> Crust::Response) {
    my $body = Template::Mojo.from-file($filename).render(|@args);
    my $headers = Hash::MultiValue.from-mixed-hash(
        Content-Type => 'text/html; charset=UTF-8'
    );
    Crust::Response.new(:status(200), :headers(Array($headers.all-pairs)), :body([$body]));
}

method render-json($object --> Crust::Response) {
    my $headers = Hash::MultiValue.from-mixed-hash(
        Content-Type => 'application/json'
    );
    Crust::Response.new(
        :status(200),
        :headers(Array($headers.all-pairs)),
        :body([to-json($object)])
    );
}
