use strict;
use warnings;
use Test::More;
use File::Which;
use Nephia::Setup;
use Capture::Tiny 'capture';
use File::Temp 'tempdir';
use Cwd;
use Guard;

unless ( which('carton') ) {
    plan skip_all => 'A setup flavor "Carton" requires "carton" command';
}

my $pwd = getcwd;
my $temp_dir = tempdir(CLEANUP => 1);
chdir $temp_dir;
my $guard = guard { chdir $pwd };

my $setup = Nephia::Setup->new(
    appname => 'Verdure::Memory',
    plugins => ['Minimal', 'Carton'],
);

isa_ok $setup, 'Nephia::Setup';

subtest create => sub {
    no strict 'refs';
    no warnings 'redefine';
    local *{'Nephia::Setup::Action::CartonInstall'} = sub { print "Installing modules using cpanfile" };
    use strict;
    use warnings;

    my($out, $err, @res) = capture {
        $setup->do_task;
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
