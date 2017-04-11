package Comando::Agregar::Estadisticas::Background;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando::Agregar::Estadisticas);

=item
Agrega sexo
=cut
sub _ejecutar {
	my $self = shift;
  my $atributos = [qw(allies contacts fame influence mentor resources status herd retainers)];
  my $params = Saga->params(@_)
    ->params_requeridos(qw(persona))->params_validos(@$atributos)->params_validos(qw(puntos flags min max atributos));
  $params->puntos($params->background);
  $params->atributos($atributos);
  $params->min(0);
  $params->max(5);
  $params->flags([qw(advantage background)]);
  $self->SUPER::_ejecutar($params);
}

1;


