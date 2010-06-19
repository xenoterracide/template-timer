#!perl
#
# This file is part of Template-ShowStartStop
#
# This software is Copyright (c) 2010 by Caleb Cushing.
#
# This is free software, licensed under:
#
#   The Artistic License 2.0
#
use strict;
use warnings;
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

test_expect(\*DATA, $tt, $vars);

__DATA__
-- test --
[% fragment | eval -%]
-- expect --
The cat sat on the hat

<!-- SUMMARY
L1   0.014          P input text
L2   0.188           P (evaluated block)
L2   0.692   0.519   P (evaluated block)
L1   0.736   0.743  P input text
-->
