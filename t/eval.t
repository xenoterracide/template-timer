#!perl -Tw
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

use Test::More tests => 3;

BEGIN {
    use_ok( 'Template' );
}

BEGIN {
    use_ok( 'Template::Timer' );
}

my $tt =
    Template->new( {
        CONTEXT => Template::Timer->new
    } );

my $block = q{[% thing = 'doohickey' %]};

TODO: { # See RT # 13225
    local $TODO = 'Problem identified but not fixed';
    my $rc = $tt->process( \*DATA, { block => $block } );
    ok( $rc, 'eval' );
}

__DATA__
[% block | eval %]
[% thing %]
