package Comando::Agregar::Estadisticas::Social;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando::Agregar::Estadisticas);

=item
Agrega sexo
=cut
sub _ejecutar {
	my $self = shift;
  my $params = Saga->params(@_)
    ->params_requeridos(qw(persona))->params_validos(qw(puntos min max atributos flags charisma manipulation appearance));
  $params->puntos($params->social);  
  $params->atributos([qw(charisma manipulation appearance)]);
  $params->min(1);
  $params->max(5);
  $params->flags([qw(social attribute)]);
  $self->SUPER::_ejecutar( $params );
}

1;
