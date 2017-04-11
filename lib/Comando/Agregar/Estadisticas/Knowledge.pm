package Comando::Agregar::Estadisticas::Knowledge;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando::Agregar::Estadisticas);

=item
Agrega sexo
=cut
sub _ejecutar {
	my $self = shift;
  my $atributos = [qw(bureaucracy computer finance investigation law linguistics medicine occult politics science)];
  my $params = Saga->params(@_)
    ->params_requeridos(qw(persona puntos))->params_validos(@$atributos)->params_validos(qw(flags min max atributos));
  $params->atributos($atributos);
  $params->min(0);
  $params->max(5);
  $params->flags([qw(knowledge ability)]);
  $self->SUPER::_ejecutar($params);
}

1;
