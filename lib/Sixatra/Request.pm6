use v6;
need Crust::Request;
unit class Sixatra::Request is Crust::Request;

has Hash $.captured is rw;
