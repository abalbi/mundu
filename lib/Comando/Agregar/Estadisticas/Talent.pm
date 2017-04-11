package Comando::Agregar::Estadisticas::Talent;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando::Agregar::Estadisticas);

=item
Agrega sexo
=cut
sub _ejecutar {
	my $self = shift;
  my $atributos = [qw(acting alertness athletics brawl dodge empathy expression intimidation leadership streetwise subterfuge)];
  my $params = Saga->params(@_)
    ->params_requeridos(qw(persona))->params_validos(@$atributos)->params_validos(qw(puntos atributos min max flags));
  $params->puntos($params->talent);  
  $params->atributos($atributos);
  $params->min(0);
  $params->max(5);
  $params->flags([qw(talent ability)]);
  $self->SUPER::_ejecutar($params);
}

1;
