package WhiteWolf::Comando::Estadisticas::Virtue;
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
    ->params_requeridos(qw(persona))->params_validos(qw(puntos virtue min max atributos flags conscience self_control courage));
  $params->puntos($params->virtue);  
  $params->atributos([qw(conscience self_control courage)]);
  $params->min(1);
  $params->max(5);
  $params->flags([qw(virtue advantage)]);
  $self->SUPER::_ejecutar( $params );
}

1;
