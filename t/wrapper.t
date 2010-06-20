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
use strict;
use warnings;
use Template::Timer;
use Template::Test;

$Template::Test::DEBUG = 1;

my $tt = Template->new({
    CONTEXT => Template::Timer->new,
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
-- test --
[% WRAPPER t/templates/wrapper.tt -%]
hello [% var %]
[%- END -%]
[% PROCESS t/templates/how.tt -%]
-- expect --
Well,
hello world
It's a beatiful day.
How are you today?

<!-- SUMMARY
L1   0.000          P input text
L2   0.000           P t/templates/how.tt
L2   0.000           I t/templates/wrapper.tt
L3   0.000            P t/templates/wrapper.tt
L3   0.000   0.000    P t/templates/wrapper.tt
L2   0.000   0.000   I t/templates/wrapper.tt
L2   0.000   0.000   P t/templates/how.tt
L1   0.000   0.000  P input text
-->
-- test --
[% BLOCK bold   %]<b>[% content %]</b>[% END -%]
[% BLOCK italic %]<i>[% content %]</i>[% END -%]
[% WRAPPER bold+italic %]Hello World[% END -%]
-- expect --
<b><i>Hello World</i></b>
<!-- SUMMARY
L1   0.000          P input text
L2   0.000           I bold
L3   0.000            P bold
L2   0.000           I italic
L3   0.000            P italic
L3   0.000   0.000    P italic
L2   0.000   0.000   I italic
L3   0.000   0.000    P bold
L2   0.000   0.000   I bold
L1   0.000   0.000  P input text
-->
