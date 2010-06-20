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
<!-- START: process input text -->
<!-- START: process t/templates/wrapper.tt -->
Well,
hello world
It's a beatiful day.
<!-- STOP:  process t/templates/wrapper.tt -->
<!-- START: process t/templates/how.tt -->
How are you today?
<!-- STOP:  process t/templates/how.tt -->
<!-- STOP:  process input text -->
-- test --
[% BLOCK bold   %]<b>[% content %]</b>[% END -%]
[% BLOCK italic %]<i>[% content %]</i>[% END -%]
[% WRAPPER bold+italic %]Hello World[% END -%]
-- expect --
<!-- START: process input text -->
<!-- START: process bold -->
<b><!-- START: process italic -->
<i>Hello World</i><!-- STOP:  process italic -->
</b><!-- STOP:  process bold -->
<!-- STOP:  process input text -->
