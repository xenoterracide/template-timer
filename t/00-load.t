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

use Test::More tests => 1;

BEGIN {
    use_ok( 'Template::Timer' );
}

diag( "Testing Template::Timer $Template::Timer::VERSION" );
