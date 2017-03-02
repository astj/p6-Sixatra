use v6;
unit class Sixatra::Connection;

need Sixatra::Request;
use Template::Mojo;
use Hash::MultiValue;
use Crust::Response;

has Sixatra::Request $.req;
has Hash $.params;

method render(Str $filename, *@args) {
    my $body = Template::Mojo.from-file($filename).render(|@args);
    my $headers = Hash::MultiValue.from-mixed-hash(
        Content-Type => 'text/html; charset=UTF-8'
    );
    Crust::Response.new(:status(200), :headers(Array($headers.all-pairs)), :body([$body]));
}
