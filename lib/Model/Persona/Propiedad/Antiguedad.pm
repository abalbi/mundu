package Persona::Propiedad::Antiguedad;
use strict;
use Data::Dumper;
use base qw(Persona::Propiedad);
use fields qw();

sub new {
	my $class = shift;
	my $params = Saga->params(@_)->params_validos(qw(key));
	$params->key('antiguedad');
  my $self = $class->SUPER::new($params);
  return $self;
}

sub valor {
	my $self = shift;
	return Saga->dt(Saga->entorno->fecha_actual)->year - Saga->dt($self->persona->abrazo->valor)->year;
}
1;