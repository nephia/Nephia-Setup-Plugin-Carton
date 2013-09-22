use strict;
use warnings;
use Test::More;
use File::Which;
use Nephia::Setup;
use Capture::Tiny 'capture';
use File::Temp 'tempdir';

unless ( which('carton') ) {
    plan skip_all => 'A setup flavor "Carton" requires "carton" command';
}

my $temp_dir = tempdir(CLEANUP => 1);
my $setup = Nephia::Setup->new(
    appname => 'Verdure::Memory',
    approot => $temp_dir,
    plugins => ['Carton'],
);

isa_ok $setup, 'Nephia::Setup';

subtest create => sub {
    no strict 'refs';
    no warnings 'redefine';
    local *{'Nephia::Setup::carton_install'} = sub { print "Installing modules using cpanfile" };
    use strict;
    use warnings;

    my($out, $err, @res) = capture {
        $setup->carton_install;
    };

    chomp(my $expect = join('',(<DATA>)));
    if ($^O eq 'MSWin32') {
        $expect =~ s/\//\\/g;
    }
    like $out, qr/^$expect/, 'setup step';
};

done_testing;

__DATA__
Installing modules using cpanfile
