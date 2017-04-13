package WhiteWolf::Fabrica::Vampire;
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
  my $attributes;
  my $abilities;
  if($params->generacion) {
    $params->esteriotipo(Saga->azar([qw(neonato ancilla)])) if $params->generacion == 9;
    $params->esteriotipo('ancilla') if $params->generacion <= 8;
    $params->esteriotipo(Saga->azar([qw(ancilla elder)])) if $params->generacion == 7;
    $params->esteriotipo('elder') if $params->generacion <= 6;
  }
  if($params->fecha_abrazo && not $params->esteriotipo) {
    $params->fecha_abrazo(Saga->dt_random($params->fecha_abrazo));
    my $edad = Saga->dt(Saga->entorno->fecha_inicio)->year - Saga->dt($params->fecha_abrazo)->year;
    $params->esteriotipo('neonato') if $edad < 50;
    $params->esteriotipo('ancilla') if $edad >= 50;
    $params->esteriotipo('elder') if $edad > 300;
  }
  if(!$params->esteriotipo) {
    $params->esteriotipo('neonato');
  }
  if($params->esteriotipo eq 'neonato') {
    $attributes = [shuffle(qw(7 5 3))];
    $abilities = [shuffle(qw(13 9 5))];
    $params->background(7) if not defined $params->background;
    $params->virtue(7) if not defined $params->virtue;
    $params->generacion(Saga->azar([9..13])) if not defined $params->generacion;
  }
  if($params->esteriotipo eq 'ancilla') {
    $attributes = [shuffle(qw(9 6 4))];
    $abilities = [shuffle(qw(18 12 6))];
    $params->background(7) if not defined $params->background;
    $params->virtue(10) if not defined $params->virtue;
    $params->willpower(8) if not defined $params->willpower;
    $params->generacion(Saga->azar([7..9])) if not defined $params->generacion;
  }
  if($params->esteriotipo eq 'elder') {
    $attributes = [shuffle(qw(10 7 5))];
    $abilities = [shuffle(qw(21 14 7))];
    $params->background(12) if not defined $params->background;
    $params->virtue(6) if not defined $params->virtue;
    $params->willpower(9) if not defined $params->willpower;
    $params->generacion(Saga->azar([5..7])) if not defined $params->generacion;
  }
  $params->physical(shift @$attributes);
  $params->social(shift @$attributes);
  $params->mental(shift @$attributes);
  $params->talent(shift @$abilities);
  $params->skill(shift @$abilities);
  $params->knowledge(shift @$abilities);
  my $comando = Saga->despachar('Comando::Hacer::Vampire')->new;
  my $persona = $comando->ejecutar( $params );
	return $persona;
}

1;