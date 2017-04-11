package Comando::Agregar::Estadisticas::Willpower;
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
    ->params_requeridos(qw(persona))->params_validos(qw(flags min max atributos willpower puntos));
  my $willpower = $params->persona->courage->valor if $params->persona->tiene('courage');
  $willpower = Saga->azar([1..10]) if not defined $willpower;
  $params->min(0);
  $params->max(10);
  $params->puntos($willpower);
  $params->atributos([qw(willpower)]);
  $params->willpower($willpower);
  $params->flags([qw(advantage extra)]);
  $self->SUPER::_ejecutar($params);
}

1;

