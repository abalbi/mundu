package Fabrica::Vampire;
use Data::Dumper;
use fields qw();
use base qw(Base);
use List::Util qw(shuffle);

=item
Hacer Vampire
=cut
sub hacer {
  my $class = shift;
  my $params = Saga->params(@_)->params_libres;
  my $attributes = [shuffle(qw(7 5 3))];
  $params->physical(shift @$attributes);
  $params->social(shift @$attributes);
  $params->mental(shift @$attributes);
  my $abilities = [shuffle(qw(13 9 5))];
  $params->talent(shift @$abilities);
  $params->skill(shift @$abilities);
  $params->knowledge(shift @$abilities);
  $params->background(5);
  $params->virtue(7);
  my $comando = Saga->despachar('Comando::Hacer::Vampire')->new;
  my $persona = $comando->ejecutar( $params );
	return $persona;
}

1;