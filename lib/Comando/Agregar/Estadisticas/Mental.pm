package Comando::Agregar::Estadisticas::Mental;
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
    ->params_requeridos(qw(persona puntos))->params_validos(qw(min max atributos flags perception intelligence wits));
  $params->atributos([qw(perception intelligence wits)]);
  $params->min(1);
  $params->max(5);
  $params->flags([qw(mental attribute)]);
  $self->SUPER::_ejecutar( $params );
}

1;
