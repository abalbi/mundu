package Comando::Agregar::Estadisticas::Physical;
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
    ->params_requeridos(qw(persona puntos))->params_validos(qw(min max atributos flags strength dexterity stamina));
  $params->atributos([qw(strength dexterity stamina)]);
  $params->min(1);
  $params->max(5);
  $params->flags([qw(physical attribute)]);
  $self->SUPER::_ejecutar( $params );
}

1;
