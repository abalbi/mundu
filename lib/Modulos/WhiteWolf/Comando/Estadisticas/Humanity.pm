package WhiteWolf::Comando::Estadisticas::Humanity;
use strict;
use Data::Dumper;
use fields qw();
use base qw(WhiteWolf::Comando::Estadisticas);

=item
Agrega sexo
=cut
sub _ejecutar {
  my $self = shift;
  my $params = Saga->params(@_)
    ->params_requeridos(qw(persona))->params_validos(qw(flags min max atributos humanity puntos));
  my $persona = $params->persona;
  my $humanity = $params->humanity;
  if(not defined $humanity){
    $humanity = $persona->self_control->valor + $persona->conscience->valor if $persona->tiene([qw(self_control conscience)]);
    $humanity = $self->max if $humanity > $self->max;
  }
  $humanity = Saga->azar([1..10]) if not defined $humanity;
  $params->min(0);
  $params->max(10);
  $params->puntos($humanity);
  $params->atributos([qw(humanity)]);
  $params->humanity($humanity);
  $params->flags([qw(advantage extra)]);
  $self->SUPER::_ejecutar($params);
}

1;

