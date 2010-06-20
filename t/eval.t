#!perl
#
# This file is part of Template-Timer
#
# This software is Copyright (c) 2010 by Andy Lester.
#
# This is free software, licensed under:
#
#   The Artistic License 2.0
#
use strict;
use warnings;
use Template::Timer;
use Template::Test;

$Template::Test::DEBUG = 1;

my $tt = Template->new({
    CONTEXT => Template::Timer->new,
});

my $vars = {
    place => 'hat',
    fragment => "The cat sat on the [% place %]\n",
};

# fake output for consistent output
no warnings;
sub Time::HiRes::gettimeofday { return 0.000; };
sub Time::HiRes::tv_interval { return 0.000; };
use warnings;

test_expect(\*DATA, $tt, $vars);

__DATA__
-- test --
[% fragment | eval -%]
-- expect --
The cat sat on the hat

<!-- SUMMARY
L1   0.000          P input text
L2   0.000           P (evaluated block)
L2   0.000   0.000   P (evaluated block)
L1   0.000   0.000  P input text
-->
