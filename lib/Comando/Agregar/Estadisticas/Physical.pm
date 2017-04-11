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
    ->params_requeridos(qw(persona))->params_validos(qw(puntos physical min max atributos flags strength dexterity stamina));
  $params->puntos($params->physical);  
  $params->atributos([qw(strength dexterity stamina)]);
  $params->min(1);
  $params->max(5);
  $params->flags([qw(physical attribute)]);
  $self->SUPER::_ejecutar( $params );
}

1;
