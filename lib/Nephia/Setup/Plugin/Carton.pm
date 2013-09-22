package Nephia::Setup::Plugin::Carton;
use 5.008005;
use strict;
use warnings;
use parent 'Nephia::Setup::Plugin';
use File::pushd;
use File::Which;
use File::Spec;

our $VERSION = "0.01";

sub fix_setup {
    my $self = shift;
    $self->SUPER::fix_setup;
    my $setup = $self->setup;
    my $chain = $setup->action_chain;
    $chain->append(CartonInstall => \&carton_install);
}

sub carton_install {
    my $setup = shift;

    if (! which('carton')) {
        print 'A setup plugin "Nephia::Setup::Plugin::Carton" requires "carton" command';
    } else {
        my $path = File::Spec->catdir($setup->approot);
        my $dir = pushd($path);
        system('carton', 'install');
    }
}

1;

__END__

=encoding utf-8

=head1 NAME

Nephia::Setup::Plugin::Carton - Setup Plugin for Nephia

=head1 SYNOPSIS

    $ nephia-setup MyApp --plugin=Minimal,Carton

=head1 DESCRIPTION

This module is setup plugin for Nephia that initialize the Carton.

=head1 LICENSE

Copyright (C) papix.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

papix E<lt>mail@papix.netE<gt>

=cut

