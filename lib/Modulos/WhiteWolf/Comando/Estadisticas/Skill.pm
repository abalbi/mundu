package WhiteWolf::Comando::Estadisticas::Skill;
use strict;
use Data::Dumper;
use fields qw();
use base qw(WhiteWolf::Comando::Estadisticas);

=item
Agrega sexo
=cut
sub _ejecutar {
	my $self = shift;
  my $atributos = [qw(animal_ken drive etiquette firearms  melee music repair security stealth survival)];
  my $params = Saga->params(@_)
    ->params_requeridos(qw(persona))->params_validos(@$atributos)->params_validos(qw(puntos flags min max atributos));
  $params->puntos($params->skill);
  $params->atributos($atributos);
  $params->min(0);
  $params->max(5);
  $params->flags([qw(skill ability)]);
  $self->SUPER::_ejecutar($params);
}

1;
