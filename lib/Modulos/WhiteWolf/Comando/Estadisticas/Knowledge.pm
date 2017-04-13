package WhiteWolf::Comando::Estadisticas::Knowledge;
use strict;
use Data::Dumper;
use fields qw();
use base qw(WhiteWolf::Comando::Estadisticas);

=item
Agrega sexo
=cut
sub _ejecutar {
	my $self = shift;
  my $atributos = [qw(bureaucracy computer finance investigation law linguistics medicine occult politics science)];
  my $params = Saga->params(@_)
    ->params_requeridos(qw(persona))->params_validos(@$atributos)->params_validos(qw(puntos flags min max atributos));
  $params->puntos($params->knowledge);  
  $params->atributos($atributos);
  $params->min(0);
  $params->max(5);
  $params->flags([qw(knowledge ability)]);
  $self->SUPER::_ejecutar($params);
}

1;
