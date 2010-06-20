#!perl
use strict;
use warnings;
use Template::Timer;
use Template::Test;

my $tt = Template->new({
    CONTEXT => Template::Timer->new
});

my $vars = {
    var => 'world',
};

# fake output for consistent output
no warnings;
sub Time::HiRes::gettimeofday { return 0.000; };
sub Time::HiRes::tv_interval { return 0.000; };
use warnings;

test_expect(\*DATA, $tt, $vars);

__DATA__
--test--
hello [% var %]
--expect--
