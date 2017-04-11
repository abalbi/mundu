package Comando::Agregar::Atributos::Talent;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando::Agregar::Atributos);

=item
Agrega sexo
=cut
sub _ejecutar {
	my $self = shift;
  my $atributos = [qw(acting alertness athletics brawl dodge empathy expression intimidation leadership streetwise subterfuge)];
  my $params = Saga->params(@_)
    ->params_requeridos(qw(persona puntos))->params_validos(@$atributos)->params_validos(qw(atributos min max flags));
  $params->atributos($atributos);
  $params->min(0);
  $params->max(5);
  $params->flags([qw(talent ability)]);
  $self->SUPER::_ejecutar($params);
}

1;
