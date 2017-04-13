use lib 'lib';
use Saga;
use Data::Dumper;

Saga->cargar('WhiteWolf');

my $persona = Saga->despachar('Fabrica::Vampire')->hacer(protagonismo => 'principal');
print $persona->describir;