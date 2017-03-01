use v6;
unit class Sixatra::Connection;

need Sixatra::Request;
has Sixatra::Request $.req;
has Hash $.params;
