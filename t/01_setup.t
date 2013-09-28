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

my $plugin_loaded = 0;
for my $action ($setup->action_chain) {
    my $name = ref($action);
    $plugin_loaded = 1 if $name eq 'Nephia::Setup::Action::CartonInstall';
}

ok $plugin_loaded == 1, 'Load plugins';

undef($guard);

done_testing;
