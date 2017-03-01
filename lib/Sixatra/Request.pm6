use v6;
need Crust::Request;
use JSON::Tiny;
use Crust::Utils;

unit class Sixatra::Request is Crust::Request;

has Hash $.captured is rw;
has Bool $!has-parsed-body = False;
has Hash $.env;

method body-parameters() {
    return $!env<crust.request.body> if $!has-parsed-body;
    # If request body seems json, try to parse;
    $!has-parsed-body = True;
    if self.content-type {
        my ($type) = parse-header-item(self.content-type);
        if $type eq 'application/json' {
            my %h = from-json(self.content.decode('ascii'));
            CATCH {
                # ignore malformed json
                when X::JSON::Tiny::Invalid {
                    return $!env<crust.request.body> = Hash::MultiValue.new;
                }
            }
            return $!env<crust.request.body> = Hash::MultiValue.from-mixed-hash(%h);
        }
    }
    nextsame;
}
