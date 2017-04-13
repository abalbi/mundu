use lib 'lib';
use Saga;
use Data::Dumper;

my $persona = Fabrica::Vampire->hacer;
$Data::Dumper::Maxdepth = 4;
print STDERR Dumper [$persona->dexterity];
print $persona->describir;