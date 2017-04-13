use lib 'lib';
use Saga;
use Data::Dumper;

my $persona = Fabrica::Vampire->hacer;
print $persona->describir;