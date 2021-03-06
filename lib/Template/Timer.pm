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
package Template::Timer;
BEGIN {
  $Template::Timer::VERSION = '1.00';
}

use parent qw( Template::Context );
use Time::HiRes ();

our @totals;

foreach my $sub ( qw( process include ) ) {
    no strict 'refs';
    my $super = __PACKAGE__->can("SUPER::$sub") or die;
    *{$sub} = sub {
        my $self = shift;
        my $what = shift;

        my $template
            = ref($what) eq 'Template::Document' ? $what->name
            : ref($what) eq 'ARRAY'              ? join( ' + ', @{$what} )
            : ref($what) eq 'SCALAR'             ? '(evaluated block)'
            :                                      $what
            ;

        my $level;
        my $processed_data;
        my $epoch_elapsed_start;
        my $epoch_elapsed_end;
        my $now   = [Time::HiRes::gettimeofday];
        my $start = [@{$now}];
        DOIT: {
			my $epoch = undef;
			my $depth = 0;
            $epoch = $epoch ? $epoch : [@{$now}];
            $depth = $depth + 1;
            $level = $depth;
            $epoch_elapsed_start = _diff_disp($epoch);
            $processed_data = $super->($self, $what, @_);
            $epoch_elapsed_end = _diff_disp($epoch);
        }
        my $spacing = ' ' x $level;
        my $level_elapsed = _diff_disp($start);
        my $ip = uc substr( $sub, 0, 1 );
        my $start_stats = "L$level $epoch_elapsed_start         $spacing$ip $template";
        my $end_stats =   "L$level $epoch_elapsed_end $level_elapsed $spacing$ip $template";
        @totals = ( $start_stats, @totals, $end_stats );
        if ( $level > 1 ) {
            return $processed_data;
        }

        my $summary = join( "\n",
            '<!-- SUMMARY',
            @totals,
            '-->',
            '',
        );
        @totals = ();
        return "$processed_data\n$summary\n";
    }; # sub
} # for


sub _diff_disp {
    my $starting_point = shift;

    return sprintf( '%7.3f', Time::HiRes::tv_interval($starting_point) * 1000 );
}
1;

# ABSTRACT: Rudimentary profiling for Template Toolkit


__END__
=pod

=head1 NAME

Template::Timer - Rudimentary profiling for Template Toolkit

=head1 VERSION

version 1.00

=head1 SYNOPSIS

Template::Timer provides inline timings of the template processing
througout your code.  It's an overridden version of L<Template::Context>
that wraps the C<process()> and C<include()> methods.

Using Template::Timer is simple.

    use Template::Timer;

    my %config = ( # Whatever your config is
        INCLUDE_PATH    => '/my/template/path',
        COMPILE_EXT     => '.ttc',
        COMPILE_DIR     => '/tmp/tt',
    );

    if ( $development_mode ) {
        $config{ CONTEXT } = Template::Timer->new( %config );
    }

    my $template = Template->new( \%config );

Now when you process templates, HTML comments will get embedded in your
output, which you can easily grep for.  The nesting level is also shown.

    <!-- TIMER START: L1 process mainmenu/mainmenu.ttml -->
    <!-- TIMER START: L2 include mainmenu/cssindex.tt -->
    <!-- TIMER START: L3 process mainmenu/cssindex.tt -->
    <!-- TIMER END:   L3 process mainmenu/cssindex.tt (17.279 ms) -->
    <!-- TIMER END:   L2 include mainmenu/cssindex.tt (17.401 ms) -->

    ....

    <!-- TIMER END:   L3 process mainmenu/footer.tt (3.016 ms) -->
    <!-- TIMER END:   L2 include mainmenu/footer.tt (3.104 ms) -->
    <!-- TIMER END:   L1 process mainmenu/mainmenu.ttml (400.409 ms) -->

Note that since INCLUDE is a wrapper around PROCESS, calls to INCLUDEs
will be doubled up, and slightly longer than the PROCESS call.

=head1 BUGS

Please report any bugs or feature requests to
C<bug-template-timer at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically
be notified of progress on your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

Thanks to
Randal Schwartz,
Bill Moseley,
and to Gavin Estey for the original code.

=head1 AUTHORS

=over 4

=item *

Andy Lester

=item *

Caleb Cushing <xenoterracide@gmail.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2010 by Andy Lester.

This is free software, licensed under:

  The Artistic License 2.0

=cut

